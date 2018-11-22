//
//  URLComposer.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 10/06/18.
//  Copyright © 2018 Giuseppe Sapienza. All rights reserved.
//

import Foundation

struct URLComposer {
    init(endpoint: WordpressEndpoint, queries: [URLQueryItem]) {
        self.endpoint = endpoint
        self.queries = queries
    }
    
    fileprivate let endpoint: WordpressEndpoint
    fileprivate let queries: [URLQueryItem]
    
    func value() throws -> URL {
        var path = try self.endpoint.path()
        
        path.queryItems = self.queries.isEmpty ? nil : self.queries
        
        guard let url = path.url else {
            throw WordpressResponseError.requestUrlWithQueryNotInitialized
        }
                
        return url
    }
    
}
