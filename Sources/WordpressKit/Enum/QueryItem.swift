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


public struct WordpressQueryItems: Hashable {
    
    fileprivate var dict: [WordpressQueryKey: String] = [:]
    
    public mutating func add(key: WordpressQueryKey, value: String) {
        dict.updateValue(value, forKey: key)
    }
    
    public func value() -> [URLQueryItem] {
        return dict.map({ URLQueryItem.init(name: $0.rawValue, value: $1) })
    }
    
}
