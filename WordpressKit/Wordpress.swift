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
    
    public init(domain: String, namespace: String = "/wp/v2") {
        guard let domain = URL(string: domain) else {
            fatalError(WordpressResponseError.rootNotConvertableToURL.localizedDescription)
        }
        
        self.domain = domain
        self.namespace = namespace
    }
    
    fileprivate let domain: URL
    fileprivate let namespace: String
    
    func baseURL() -> URL {
        return domain.appendingPathComponent(namespace)
    }
    
    public func get(endpoint: WordpressEndpoint) -> WordpressGetSession {
        return WordpressGet(
            baseURL: baseURL(),
            endpoint: endpoint
        )
    }
    
}
