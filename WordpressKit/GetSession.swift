//
//  Request.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 06/06/18.
//  Copyright © 2018 Giuseppe Sapienza. All rights reserved.
//

import Foundation

class WordpressGet: WordpressGetSession {
    
    internal init(baseURL: URL, endpoint: WordpressEndpoint) {
        self.baseURL = baseURL
        self.endpoint = endpoint
        self.queries = WordpressQueryItems.init()
    }
    
    fileprivate let baseURL: URL
    fileprivate let endpoint: WordpressEndpoint
    fileprivate var queries: WordpressQueryItems
    
    fileprivate lazy var sessionManager = WordpressSessionManager(delegate: self)
    fileprivate lazy var sessionQueue = OperationQueue()
    fileprivate var sessionDataTask: URLSessionDataTask?
    
    fileprivate lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "Content-Type" : "application/json"
        ]
        
        return URLSession(
            configuration: configuration,
            delegate: sessionManager,
            delegateQueue: sessionQueue)
    }()
    
    fileprivate var handlers: [WordpressRequestHandlerExecutable] = [] {
        willSet {
            resume()
        }
    }

    @discardableResult
    public func json(result: @escaping ResultHandler<Any>) -> Self {
        handlers.append(JsonHandler(operation: result))
        return self
    }
    
    @discardableResult
    public func string(result: @escaping ResultHandler<String>) -> Self {
        handlers.append(StringHandler(operation: result))
        return self
    }
    
    @discardableResult
    public func data(result: @escaping ResultHandler<Data>) -> Self {
        handlers.append(DataHandler(operation: result))
        return self
    }
    
    @discardableResult
    public func decode<T>(type: T.Type, result: @escaping ResultHandler<T>) -> Self where T: Decodable {
        handlers.append(DecodeHandler(type: type, operation: result))
        return self
    }
    
    @discardableResult
    public func query(key: WordpressQueryKey, value: String) -> Self {
        guard !value.isEmpty else { return self }
        queries.add(key: key, value: value)
        return self
    }
    
    @discardableResult
    public func embed() -> Self {
        queries.add(key: ._embed, value: "1")
        return self
    }
    
    fileprivate func url() throws -> URL {
        return try WordpressFinalPath(baseURL: baseURL, endpoint: endpoint, queries: queries.value()).url()
    }
    
    fileprivate func resume() {
        guard sessionDataTask == nil else { return }
        do {
            sessionDataTask = session.dataTask(with: URLRequest(url: try url()))
            sessionDataTask?.resume()
        } catch {
            print("[🤬][Error] \(error)")
        }
        
    }

    deinit {
        print("[🔥] WordpressRequest deinit")
    }
    
}


extension WordpressGet: WordpressSessionDelegate {
    
    func wordpressTask(data: Data?, didCompleteWith error: Error?) {
        self.handlers.forEach({ $0.execute(data: data, error: error) })
    }
    
}
