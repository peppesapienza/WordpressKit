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
    case custom(path: String)
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
        case .custom(let path): return path
        default: return "\(self)"
        }
    }
}

public enum WordpressNamespace {
    case wp(v: Version)
    case plugin(name: String, v: Version)
    case custom(path: String)
    
    public enum Version: RawRepresentable {
        public typealias RawValue = String
        
        case v1
        case v2
        case v3
        case v(x: String)
        case custom(v: String)
        
        public init?(rawValue: RawValue) {
            return nil
        }
        
        public var rawValue: RawValue {
            switch self {
            case .v1: return "v1"
            case .v2: return "v2"
            case .v3: return "v3"
            case .v(let x): return "v\(x)"
            case .custom(let v): return v
            }
        }
        
    }
}

extension WordpressNamespace: RawRepresentable {
    public typealias RawValue = String
    
    public init?(rawValue: RawValue) {
        return nil
    }
    
    public var rawValue: RawValue {
        switch self {
        case .wp(let v): return "wp/\(v.rawValue)"
        case .plugin(let name, let v): return "\(name)/\(v.rawValue)"
        case .custom(let path): return path
        }
    }
    
}
