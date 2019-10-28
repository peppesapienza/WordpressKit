//
//  File.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 10/06/18.
//  Copyright © 2018 Giuseppe Sapienza. All rights reserved.
//

import Foundation

public enum WordpressQueryKey: String {
    case page
    case per_page
    case search
    case _embed
    case after
    case author
    case author_exclude
    case before
    case exclude
    case include
    case offset
    case order
    case orderby
    case slug
    case status
    case categories
    case categories_exclude
    case tags
    case tags_exclude
    case sticky
}


struct WordpressQueryItems {
    
    fileprivate var dict: [WordpressQueryKey: String] = [:]
    
    mutating func add(key: WordpressQueryKey, value: String) {
        dict.updateValue(value, forKey: key)
    }
    
    func value() -> [URLQueryItem] {
        dict.map({ URLQueryItem.init(name: $0.rawValue, value: $1) })
    }
    
    fileprivate func toString(_ array: [String]) -> String {
        var result: String = ""
        array.forEach({result += $0 + ","})
        result.removeLast()
        return result
    }
    
}
