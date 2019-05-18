//
//  WordpressResponse.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 06/06/18.
//  Copyright © 2018 Giuseppe Sapienza. All rights reserved.
//

import Foundation

public enum WordpressResult<T> {
    case value(T)
    case error(Error)
}

public enum WordpressResponseError: Error, LocalizedError {
    case encondingDataToUtf8
    case wordpressKitNotInitialized
    case rootNotConvertableToURL
    case requestUrlWithQueryNotInitialized
    case relativePathNotInitialized
    case pageNegative
    case sessionDataIsNil
    
    public var localizedDescription: String {
        switch self {
        case .encondingDataToUtf8: return "[🤬][Error] Can't convert Data to String utf8"
        case .wordpressKitNotInitialized: return "[🤬][Error] Before using WordpressKit you need to perform the Wordpress.initialize method\n example: Wordpress.initialize(rootURL: \"https://www.xcoding.it\", version: .v2)"
        case .rootNotConvertableToURL: return "[🤬][Error] Your root path isn't a URL, please add a valid link"
        case .pageNegative: return "[🤬][Error] Page number couldn't be negative"
        case .requestUrlWithQueryNotInitialized: return "[🤬][Error] Can't generate the URL of the request with queries"
        case .relativePathNotInitialized: return "[🤬][Error] Can't generate the URL path of the request"
        case .sessionDataIsNil: return "[🤬][Error] URLSession Data is nil"
        }
    }
}
