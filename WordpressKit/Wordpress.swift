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
    
    public init(domain: String, namespace: WordpressNamespace = .wp(v: .v2)) {
        guard let domain = URL(string: domain) else {
            fatalError(WordpressResponseError.rootNotConvertableToURL.localizedDescription)
        }
        
        self.domain = domain
        self.namespace = namespace
    }
    
    fileprivate let domain: URL
    fileprivate let namespace: WordpressNamespace
    
    public func baseURL() -> URL {
        domain.appendingPathComponent(namespace.rawValue)
    }
    
    public func get(endpoint: WordpressEndpoint) -> WordpressGetSession {
        WordpressGet(
            baseURL: baseURL(),
            endpoint: endpoint
        )
    }
    
}
