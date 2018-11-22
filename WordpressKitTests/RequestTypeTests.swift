//
//  WordpressKitTests.swift
//  WordpressKitTests
//
//  Created by Giuseppe Sapienza on 05/06/18.
//  Copyright © 2018 Giuseppe Sapienza. All rights reserved.
//

import XCTest
@testable import WordpressKit

class RequestPathTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    func test_posts_path() {
        do {
            let path = try WordpressEndpoint.posts.path()
            XCTAssert(path.url?.absoluteString == Wordpress.root + "/posts")
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }

    func test_url_query() {
        do {
            var items = WordpressQueryItems.init()
            items.add(key: .per_page, value: "10")
            items.add(key: ._embed, value: "1")
            let composer = URLComposer.init(endpoint: .posts, queries: items.value())
            let url = try composer.value()
            XCTAssert(url.absoluteString ==  Wordpress.root + "/posts?_embed=1&per_page=10")
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }
    /*
    func test_url_variadic_query() {
        do {
            var items = WordpressQueryItems.init()
            items.add(key: .tags, value: "124","125","126")
            let composer = URLComposer.init(endpoint: .posts, queries: items.value())
            let url = try composer.value()
            XCTAssert(url.absoluteString == "https://www.xcoding.it/wp-json/wp/v2/posts?tags=124,125,126")
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    } */
}
