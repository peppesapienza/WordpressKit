//
//  WordpressResponse.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 06/06/18.
//  Copyright © 2018 Giuseppe Sapienza. All rights reserved.
//

import Foundation

public enum WordpressResponseError: Error, LocalizedError {
    case encondingDataToUtf8
    case invalidResponse
    case mimeTypeIsNotJSON
    case rootNotConvertableToURL
    case requestUrlWithQueryNotInitialized
    case relativePathNotInitialized
    case pageNegative
    case sessionDataIsNil
    case urlError(URLError)
    
    public var localizedDescription: String {
        switch self {
        case .encondingDataToUtf8: return "[🤬][Error] Can't convert Data to String utf8"
        case .invalidResponse: return "[🤬][Error] Invalid response. Check the status code or the connection"
        case .mimeTypeIsNotJSON: return "[🤬][Error] Mime Type is not application/json"
        case .rootNotConvertableToURL: return "[🤬][Error] Your root path isn't a URL, please add a valid link"
        case .pageNegative: return "[🤬][Error] Page number couldn't be negative"
        case .requestUrlWithQueryNotInitialized: return "[🤬][Error] Can't generate the URL of the request with queries"
        case .relativePathNotInitialized: return "[🤬][Error] Can't generate the URL path of the request"
        case .sessionDataIsNil: return "[🤬][Error] URLSession Data is nil"
        case .urlError(let e): return "[🤬][Error] URLError: \(e.localizedDescription)"
        }
    }
}
