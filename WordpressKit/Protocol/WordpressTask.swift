//
//  WordpressTask.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 26/10/2019.
//  Copyright © 2019 Giuseppe Sapienza. All rights reserved.
//

import Foundation

public protocol WordpressTask {
    typealias ResultHandler<T> = (WordpressResult<T>) -> ()
    
    @discardableResult
    func json(result: @escaping ResultHandler<Any>) -> Self
    
    @discardableResult
    func string(result: @escaping ResultHandler<String>) -> Self
    
    @discardableResult
    func data(result: @escaping ResultHandler<Data>) -> Self
    
    @discardableResult
    func decode<T>(type: T.Type, result: @escaping ResultHandler<T>) -> Self where T: Decodable
}

protocol WordpressTaskDelegate {
    func wordpressTask(data: Data?, didCompleteWith error: Error?)
}
