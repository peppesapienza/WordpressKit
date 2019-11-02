//
//  Request.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 06/06/18.
//  Copyright © 2018 Giuseppe Sapienza. All rights reserved.
//

import Foundation

open class WordpressGet: WordpressGetSession {
    
    required public init(baseURL: URL, endpoint: WordpressEndpoint) {
        self.baseURL = baseURL
        self.endpoint = endpoint
        self.queries = WordpressQueryItems.init()
    }
        
    fileprivate let baseURL: URL
    fileprivate let endpoint: WordpressEndpoint
    fileprivate var queries: WordpressQueryItems
    
    fileprivate lazy var sessionManager = WordpressSessionManager(delegate: self)
    fileprivate lazy var sessionQueue = OperationQueue()
    
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
        
    fileprivate var tasks: [WordpressGetTask] = []
    
    @discardableResult
    public func json(result: @escaping ResultHandler<Any>) -> Self {
        addHandlerToActiveTask(JsonHandler(operation: result))
        return self
    }
    
    @discardableResult
    public func string(result: @escaping ResultHandler<String>) -> Self {
        addHandlerToActiveTask(StringHandler(operation: result))
        return self
    }
    
    @discardableResult
    public func data(result: @escaping ResultHandler<Data>) -> Self {
        addHandlerToActiveTask(DataHandler(operation: result))
        return self
    }
    
    @discardableResult
    public func decode<T>(type: T.Type, result: @escaping ResultHandler<T>) -> Self where T: Decodable {
        addHandlerToActiveTask(DecodeHandler(type: type, operation: result))
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
    
    @discardableResult
    public func invalidateAndCancel() -> Self {
        tasks.forEach({ $0.cancel() })
        session.invalidateAndCancel()
        return self
    }
    
    fileprivate func url() throws -> URL {
        return try WordpressFinalPath(baseURL: baseURL, endpoint: endpoint, queries: queries.value()).url()
    }
    
    fileprivate func createTask() throws -> WordpressGetTask {
        let task = session.dataTask(with: URLRequest(url: try url()))
        return WordpressGetTask(task: task)
    }
    
    fileprivate func appendTask() {
        do {
            tasks.append(try createTask())
        } catch {
            print("[🤬][Error] \(error)")
        }
    }
    
    fileprivate func addHandlerToActiveTask(_ handler: WordpressHandlerExecutable) {
        guard
            let task = tasks.first(where: { $0.state == .suspended || $0.state == .running })
        else {
            appendTask()
            addHandlerToActiveTask(handler)
            return
        }
        
        task.add(handler: handler)
        task.resume()
    }

    deinit {
        print("[🔥] WordpressRequest deinit")
    }
    
}


extension WordpressGet: WordpressSessionDelegate {
    func wordpressTask(task: URLSessionTask, didCompleteWith error: Error?) {
        tasks.first(where: {$0.taskIdentifier == task.taskIdentifier })?.complete(with: error)
    }
    
    func wordpressTask(task: URLSessionDataTask, didReceive data: Data) {
        tasks.first(where: {$0.taskIdentifier == task.taskIdentifier })?.received(data: data)
    }
    
}
