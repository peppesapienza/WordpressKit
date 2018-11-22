//
//  WordpressRequestType.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 06/06/18.
//  Copyright © 2018 Giuseppe Sapienza. All rights reserved.
//

import Foundation

public enum WordpressEndpoint {
    case posts
    case post(id: String)
    case revisions
    case categories
    case tags
    case pages
    case comments
    case taxonomies
    case media
    case users
    case types
    case statuses
    case settings
    case custom(namespace: String, path: String)
    
    
    public func path() throws -> URLComponents {
        guard
            let root = Wordpress.root,
            let namespace = Wordpress.namespace,
            let baseURL = URL.init(string: root)
        else {
            throw WordpressResponseError.wordpressKitNotInitialized
        }
        
        var relativeURL: URL
        
        switch self {
        case .custom( _, _): relativeURL = baseURL
        default:
            relativeURL = baseURL.appendingPathComponent(namespace)
        }
        
        guard
            let components = URLComponents.init(
                url: relativeURL.appendingPathComponent(self.rawValue),
                resolvingAgainstBaseURL: true)
            else {
                throw WordpressResponseError.relativePathNotInitialized
        }
        
        return components
    }
}


extension WordpressEndpoint: RawRepresentable {
    public typealias RawValue = String
    typealias endpoint = WordpressEndpoint
    
    public init?(rawValue: RawValue) {
        return nil
    }
    
    public var rawValue: RawValue {
        switch self {
        case .post(let id): return "\(endpoint.posts)/" + id
        case .custom(let namespace, let path): return namespace + "/" + path
        default: return "\(self)"
        }
    }
}
