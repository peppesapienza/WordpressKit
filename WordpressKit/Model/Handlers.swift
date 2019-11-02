//
//  RequestHandler.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 19/07/18.
//  Copyright © 2018 Giuseppe Sapienza. All rights reserved.
//

import Foundation

struct JsonHandler: WordpressHandler, WordpressHandlerExecutable {
    
    var operation: (WordpressResult<Any>) -> ()
    
    func execute(data: Data?, error: Error?) {
        guard
            error == nil,
            let data = data
        else {
            operation(WordpressResult(value: nil, error: error))
            return
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            operation(WordpressResult(value: json, error: nil))
        } catch let e {
            operation(WordpressResult(value: nil, error: e))
        }
    }

}

struct StringHandler: WordpressHandler, WordpressHandlerExecutable {
    
    var operation: (WordpressResult<String>) -> ()
    
    func execute(data: Data?, error: Error?) {
        guard error == nil else {
            operation(WordpressResult(value: nil, error: error))
            return
        }
        
        guard let s = String(data: data!, encoding: .utf8) else {
            operation(WordpressResult(value: nil, error: WordpressResponseError.encondingDataToUtf8))
            return
        }
        
        operation(WordpressResult(value: s, error: nil))
    }
    
}

struct DecodeHandler<Element: Decodable>: WordpressHandler, WordpressHandlerExecutable {
    
    var type: Element.Type
    var operation: (WordpressResult<Element>) -> ()
    
    func execute(data: Data?, error: Error?) {
        guard
            error == nil,
            let data = data
        else {
            operation(WordpressResult(value: nil, error: error))
            return
        }
        
        do {
            let result = try JSONDecoder().decode(Element.self, from: data)
            operation(WordpressResult(value: result, error: nil))
        } catch let e {
            operation(WordpressResult(value: nil, error: e))
        }
    }

}

struct DataHandler: WordpressHandler, WordpressHandlerExecutable {
    
    var operation: (WordpressResult<Data>) -> ()
    
    func execute(data: Data?, error: Error?) {
        operation(WordpressResult(value: data, error: error))
    }

}
