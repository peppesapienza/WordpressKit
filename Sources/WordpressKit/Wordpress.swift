//
//  Wordpress.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 05/06/18.
//  Copyright © 2018 Giuseppe Sapienza. All rights reserved.
//

import Foundation
import UIKit

open class Wordpress {
    
    public init(route: String, namespace: WordpressNamespace = .wp(v: .v2)) {
        guard let route = URL(string: route) else {
            fatalError(WordpressResponseError.rootNotConvertableToURL.localizedDescription)
        }
        
        self.route = route
        self.namespace = namespace
    }
    
    fileprivate let route: URL
    fileprivate let namespace: WordpressNamespace
    
    public func baseURL() -> URL {
        route.appendingPathComponent(namespace.rawValue)
    }
    
    public func get(endpoint: WordpressEndpoint) -> WordpressGetSession {
        WordpressGet(
            baseURL: baseURL(),
            endpoint: endpoint
        )
    }
    
}
