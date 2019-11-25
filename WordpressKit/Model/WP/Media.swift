//
//  Media.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 16/06/18.
//  Copyright © 2018 Giuseppe Sapienza. All rights reserved.
//

import Foundation

public struct WordpressMedia: Codable {
    public let id: Int?
    public let date: String?
    public let slug: String?
    public let type: String?
    public let link: String?
    public let title: WordpressText?
    public let author: Int?
    public let caption: WordpressText?
    public let alt_text: String?
    public let media_type: String?
    public let mime_type: String?
    public let media_details: WordpressMediaDetails?
    public let source_url: String?
    public let _links: WordpressLinks?
}

public struct WordpressMediaDetails: Codable {
    public let width: Double?
    public let height: Double?
    public let file: String?
    public let sizes: WordpressMediaSizes?
}

public struct WordpressMediaSizes: Codable {
    public let thumbnail: WordpressMediaSize?
    public let medium: WordpressMediaSize?
    public let medium_large: WordpressMediaSize?
    public let large: WordpressMediaSize?
    public let full: WordpressMediaSize?
}

public struct WordpressMediaSize: Codable {
    public let file: String?
    public let width: Double?
    public let height: Double?
    public let mime_type: String?
    public let source_url: String?
}
