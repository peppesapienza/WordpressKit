//
//  RequestHandler.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 19/07/18.
//  Copyright © 2018 Giuseppe Sapienza. All rights reserved.
//

import Foundation

protocol WordpressRequestHandler {
    associatedtype T
    var operation: (T) -> () { get set }
}

protocol WordpressRequestHandlerExecutable {
    func execute(data: Data?, error: Error?)
}

struct JsonHandler: WordpressRequestHandler, WordpressRequestHandlerExecutable {
    var operation: (WordpressResult<Any>) -> ()
    
    func execute(data: Data?, error: Error?) {
        guard error == nil else {
            operation(WordpressResult.error(error!))
            return
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
            operation(WordpressResult.value(json))
        } catch let e {
            operation(WordpressResult.error(e))
        }
    }
}

struct StringHandler: WordpressRequestHandler, WordpressRequestHandlerExecutable {
    var operation: (WordpressResult<String>) -> ()
    
    func execute(data: Data?, error: Error?) {
        guard error == nil else {
            operation(WordpressResult.error(error!))
            return
        }
        
        guard let s = String(data: data!, encoding: .utf8) else {
            operation(WordpressResult.error(
                WordpressResponseError.encondingDataToUtf8
            ))
            return
        }
        
        operation(WordpressResult.value(s))
    }
}

struct DecodeHandler<Element: Decodable>: WordpressRequestHandler, WordpressRequestHandlerExecutable {
    var type: Element.Type
    var operation: (WordpressResult<Element>) -> ()
    
    func execute(data: Data?, error: Error?) {
        guard error == nil else {
            operation(WordpressResult.error(error!))
            return
        }
        
        do {
            let decoder = JSONDecoder.init()
            let result = try decoder.decode(Element.self, from: data!)
            operation(WordpressResult.value(result))
        } catch let e {
            operation(WordpressResult.error(e))
        }
    }
}

struct DataHandler: WordpressRequestHandler, WordpressRequestHandlerExecutable {
    var operation: (WordpressResult<Data>) -> ()
    
    func execute(data: Data?, error: Error?) {
        guard error == nil else {
            operation(WordpressResult.error(error!))
            return
        }
        
        operation(WordpressResult.value(data!))
    }
}
