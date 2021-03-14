//
//  WordpressSession.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 26/10/2019.
//  Copyright © 2019 Giuseppe Sapienza. All rights reserved.
//

import Foundation

public protocol WordpressSession {
    typealias ResultHandler<T> = (WordpressResult<T>) -> ()
    init(baseURL: URL, endpoint: WordpressEndpoint)
    
    @discardableResult
    func invalidateAndCancel() -> Self
}

public protocol WordpressGetSession: WordpressSession {
    @discardableResult
    func json(result: @escaping ResultHandler<Any>) -> Self
    
    @discardableResult
    func string(result: @escaping ResultHandler<String>) -> Self
    
    @discardableResult
    func data(result: @escaping ResultHandler<Data>) -> Self
    
    @discardableResult
    func decode<T>(type: T.Type, result: @escaping ResultHandler<T>) -> Self where T: Decodable
    
    @discardableResult
    func query(key: WordpressQueryKey, value: String) -> Self
    
    @discardableResult
    func embed() -> Self
}

protocol WordpressSessionDelegate {
    func wordpressTask(task: URLSessionTask, didCompleteWith error: Error?)
    func wordpressTask(task: URLSessionDataTask, didReceive data: Data)
}

