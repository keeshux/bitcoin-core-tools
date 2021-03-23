//
//  RPC.swift
//
//
//  Created by Davide De Rosa on 2/17/21.
//

import Foundation
import Combine

public class RPC {
    private let version: String
    
    private let id: String
    
    private let transport: Transport
    
    private let configuration: Configuration
    
    public init(version: String, id: String, transport: Transport, configuration: Configuration) {
        self.version = version
        self.id = id
        self.transport = transport
        self.configuration = configuration
    }

    public func executePublisher(_ method: String, path: String? = nil, arguments: [Data]? = nil, timeout: TimeInterval = 0.0) -> AnyPublisher<Data, Error> {
        guard let url = configuration.url(withPath: path) else {
            preconditionFailure("RPC configuration parameters are malformed")
        }
        var request = URLRequest(url: url)
        
        let loginString = String(format: "%@:%@", configuration.username, configuration.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        request.timeoutInterval = timeout
        request.httpMethod = "POST"
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try encodedRequest(method: method, arguments: arguments)
            if let reqBody = request.httpBody, let reqBodyString = String(data: reqBody, encoding: .utf8) {
                JSONRPC.logger.debug("RPC <- \(reqBodyString)")
            }
        } catch let e {
            JSONRPC.logger.error("RPC <- (encoding): \(e)")
            return Fail<Data, Error>(error: e)
                .eraseToAnyPublisher()
        }
        return transport.writePublisher(request)
            .mapError { $0 }
            .eraseToAnyPublisher()
    }

    private func encodedRequest(method: String, arguments: [Data]?) throws -> Data {
        var body: [String: Any] = [:]
        body["jsonrpc"] = version
        body["id"] = id
        body["method"] = method
        if let arguments = arguments, !arguments.isEmpty {
            body["params"] = try arguments.map {
                try JSONSerialization.jsonObject(with: $0, options: [.allowFragments])
            }
        }
        return try JSONSerialization.data(withJSONObject: body, options: [])
    }
}

extension RPC {
    public struct Configuration: Codable {
        public let username: String
        
        public let password: String
        
        public let hostname: String
        
        public let port: UInt16
        
        public init(_ username: String, _ password: String, _ hostname: String, _ port: UInt16) {
            self.username = username
            self.password = password
            self.hostname = hostname
            self.port = port
        }

        fileprivate func url(withPath path: String? = nil) -> URL? {
            guard let encodedUsername = username.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) else {
                return nil
            }
            guard let encodedPassword = password.addingPercentEncoding(withAllowedCharacters: .urlPasswordAllowed) else {
                return nil
            }
            guard let encodedHostname = hostname.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                return nil
            }
            return URL(string: "http://\(encodedUsername):\(encodedPassword)@\(encodedHostname):\(port)\(path ?? "")")
        }
    }
}
