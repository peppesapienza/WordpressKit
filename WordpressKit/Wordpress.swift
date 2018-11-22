//
//  Wordpress.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 05/06/18.
//  Copyright © 2018 Giuseppe Sapienza. All rights reserved.
//

import Foundation
import UIKit

public class Wordpress {
    
    fileprivate init() { }
    
    public static func initialize(root: String, namespace: String = "/wp/v2") {
        guard let _ = URL.init(string: root) else {
            fatalError(WordpressResponseError.rootNotConvertableToURL.localizedDescription)
        }
        
        self.root = root
        self.namespace = namespace
    }
    
    internal static var root: String!
    internal static var namespace: String!
    
    public static func get(endpoint: WordpressEndpoint) -> WordpressGetRequest {
        return WordpressGetRequest.init(endpoint: endpoint)
    }
    
}
