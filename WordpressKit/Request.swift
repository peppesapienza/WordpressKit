//
//  Request.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 06/06/18.
//  Copyright © 2018 Giuseppe Sapienza. All rights reserved.
//

import Foundation


public protocol WordpressTask {
    typealias Result<T> = (WordpressResult<T>) -> ()
    
    @discardableResult
    func json(result: @escaping Result<Any>) -> Self
    
    @discardableResult
    func string(result: @escaping Result<String>) -> Self
    
    @discardableResult
    func data(result: @escaping Result<Data>) -> Self
    
    @discardableResult
    func decode<T>(type: T.Type, result: @escaping Result<T>) -> Self where T: Decodable
}

public class WordpressGetRequest: WordpressTask {
    
    internal init(endpoint: WordpressEndpoint) {
        self.endpoint = endpoint
        self.queries = WordpressQueryItems.init()
    }
    
    fileprivate var endpoint: WordpressEndpoint
    fileprivate var queries: WordpressQueryItems
    
    fileprivate lazy var sessionManager = WordpressSessionManager.init(request: self)
    fileprivate lazy var sessionQueue = OperationQueue.init()
    
    fileprivate lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(WordpressGetRequest.handleSessionComplete),
                         name: .sessionDidComplete,
                         object: self.sessionManager)
        return URLSession.init(
            configuration: configuration,
            delegate: self.sessionManager,
            delegateQueue: self.sessionQueue)
    }()
    
    fileprivate var isResumed: Bool = false
    fileprivate var handlers: [WordpressRequestHandlerExecutable] = []

    @discardableResult
    public func json(result: @escaping Result<Any>) -> Self {
        self.handlers.append(JsonHandler.init(operation: result))
        self.resume()
        return self
    }
    
    @discardableResult
    public func string(result: @escaping Result<String>) -> Self {
        self.handlers.append(StringHandler.init(operation: result))
        self.resume()
        return self
    }
    
    @discardableResult
    public func data(result: @escaping Result<Data>) -> Self {
        self.handlers.append(DataHandler.init(operation: result))
        self.resume()
        return self
    }
    
    @discardableResult
    public func decode<T>(type: T.Type, result: @escaping Result<T>) -> Self where T: Decodable {
        self.handlers.append(DecodeHandler.init(type: type, operation: result))
        self.resume()
        return self
    }
    
    @discardableResult
    public func query(key: WordpressQueryKey, value: String) -> Self {
        guard !value.isEmpty else { return self }
        self.queries.add(key: key, value: value)
        return self
    }
    
    public func embed() -> Self {
        self.queries.add(key: ._embed, value: "1")
        return self
    }
    
    fileprivate func resume() {
        guard !isResumed else { return }
        do {
            defer { self.isResumed = true }
            let queries = self.queries.value()
            let url = try URLComposer.init(endpoint: self.endpoint, queries: queries).value()
            self.session.dataTask(with: url).resume()
        } catch let e {
            print(e)
        }
        
    }
    
    @objc fileprivate func handleSessionComplete(_ sender: Notification) {
        DispatchQueue.main.async {
            if let error = sender.userInfo?["error"] as? Error {
                print(error)
                self.handlers.forEach({ $0.execute(data: nil, error: error) })
                return
            }
            
            if let data = sender.userInfo?["data"] as? Data {
                self.handlers.forEach({ $0.execute(data: data, error: nil) })
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("[🔥] WordpressRequest deinit")
    }
    
}
