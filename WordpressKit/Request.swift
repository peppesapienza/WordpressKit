//
//  Request.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 06/06/18.
//  Copyright © 2018 Giuseppe Sapienza. All rights reserved.
//

import Foundation

public class WordpressGetRequest: WordpressTask {
    
    internal init(baseURL: URL, endpoint: WordpressEndpoint) {
        self.baseURL = baseURL
        self.endpoint = endpoint
        self.queries = WordpressQueryItems.init()
    }
    
    fileprivate let baseURL: URL
    fileprivate let endpoint: WordpressEndpoint
    
    fileprivate var queries: WordpressQueryItems
    
    fileprivate lazy var sessionManager = WordpressSessionManager(delegate: self)
    fileprivate lazy var sessionQueue = OperationQueue.init()
    
    fileprivate lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "Content-Type" : "application/json"
        ]
        
        return URLSession.init(
            configuration: configuration,
            delegate: sessionManager,
            delegateQueue: sessionQueue)
    }()
    
    fileprivate var isResumed: Bool = false
    fileprivate var handlers: [WordpressRequestHandlerExecutable] = [] {
        didSet {
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
    
    public func embed() -> Self {
        queries.add(key: ._embed, value: "1")
        return self
    }
    
    fileprivate func url() throws -> URL {
        return try WordpressFinalPath.init(baseURL: baseURL, endpoint: endpoint, queries: queries.value()).url()
    }
    
    fileprivate func resume() {
        guard !isResumed else { return }
        do {
            defer { isResumed = true }
            session.dataTask(with: URLRequest.init(url: try url())).resume()
        } catch {
            print("[🤬][Error] \(error)")
            isResumed = false
        }
        
    }

    deinit {
        print("[🔥] WordpressRequest deinit")
    }
    
}


extension WordpressGetRequest: WordpressTaskDelegate {
    
    func wordpressTask(data: Data?, didCompleteWith error: Error?) {
        guard let data = data else {
            self.handlers.forEach({ $0.execute(data: nil, error: error!) })
            return
        }
        
        self.handlers.forEach({ $0.execute(data: data, error: nil) })
    }
    
}
