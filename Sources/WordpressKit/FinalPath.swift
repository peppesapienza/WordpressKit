//
//  URLComposer.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 10/06/18.
//  Copyright © 2018 Giuseppe Sapienza. All rights reserved.
//

import Foundation

struct WordpressFinalPath {
    init(baseURL: URL, endpoint: WordpressEndpoint, queries: [URLQueryItem]) {
        self.baseURL = baseURL
        self.endpoint = endpoint
        self.queries = queries
    }
    
    fileprivate let baseURL: URL
    fileprivate let endpoint: WordpressEndpoint
    fileprivate let queries: [URLQueryItem]

    
    func url() throws -> URL {
        
        guard var components = URLComponents.init(
            url: baseURL.appendingPathComponent(self.endpoint.rawValue),
            resolvingAgainstBaseURL: true)
        else { throw WordpressResponseError.relativePathNotInitialized }
        
        components.queryItems = queries.isEmpty ? nil : queries
        
        guard let url = components.url else {
            throw WordpressResponseError.requestUrlWithQueryNotInitialized
        }
                
        return url
    }
    
}
