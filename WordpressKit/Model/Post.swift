//
//  WordpressPost.swift
//  WordpressKit
//
//  Created by Giuseppe Sapienza on 10/06/18.
//  Copyright © 2018 Giuseppe Sapienza. All rights reserved.
//

import Foundation

open class WordpressPost: Codable {
    public let id: Int
    public let date: String
    public let date_gmt: String
    public let guid: WordpressText
    public let modified: String
    public let modified_gmt: String
    public let slug: String
    public let status: String
    public let type: String
    public let link: String
    public let title: WordpressText
    public let content: WordpressProtectedText
    public let excerpt: WordpressProtectedText?
    public let author: Int
    public let featured_media: Int?
    public let comment_status: String?
    public let ping_status: String?
    public let sticky: Bool?
    public let format: String?
    public let categories: [Int]?
    public let tags: [Int]?
    public let _links: WordpressLinks?
    public var _embedded: WordpressEmbeddedPost?
}

public struct WordpressLinks: Codable {
    public let _self: [WordpressLink]?
    public let collection: [WordpressLink]?
    public let about: [WordpressLink]?
    public let author: [WordpressEmbeddableLink]?
    public let replies: [WordpressEmbeddableLink]?
    public let version_history: [WordpressLink]?
    public let wp_featuredmedia: [WordpressEmbeddableLink]?
    public let wp_attachment: [WordpressLink]?
    public let wp_term: [WordpressTerm]?
    
    enum CodingKeys: String, CodingKey {
        case _self = "self"
        case version_history = "version-history"
        case wp_featuredmedia = "wp:featuredmedia"
        case wp_attachment = "wp:attachment"
        case wp_term = "wp:term"
        case collection, about, author, replies
    }
    
}

public struct WordpressEmbeddedPost: Codable {
    public let author: [WordpressAuthor]?
    public let wp_featuredmedia: [WordpressMedia]?
    public let wp_term: [[WordpressEmbeddedTerm]]?
    
    enum CodingKeys: String, CodingKey {
        case author
        case wp_featuredmedia = "wp:featuredmedia"
        case wp_term = "wp:term"
    }
}

public struct WordpressAuthor: Codable {
    public let id: Int
    public let name: String?
    public let url: String?
    public let description: String?
    public let link: String?
    public let slug: String?
    public let avatar_urls: [Int:String]?
}

public struct WordpressText: Codable {
    public let rendered: String
}

public struct WordpressProtectedText: Codable {
    public let rendered: String
    public let protected: Bool?
}

public struct WordpressLink: Codable {
    public let href: String
}

public struct WordpressEmbeddableLink: Codable {
    public let href: String?
    public let embeddable: Bool?
}

public struct WordpressTerm: Codable {
    public let taxonomy: String?
    public let embeddable: Bool?
    public let href: String?
}

public struct WordpressEmbeddedTerm: Codable {
    public let id: Int?
    public let link: String?
    public let name: String?
    public let slug: String?
    public let taxonomy: String?
    public let _links: WordpressLinks?
}
