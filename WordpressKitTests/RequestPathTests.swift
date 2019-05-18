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
    
    let wordpress = Wordpress.init(root: "https://ispazio.net/", namespace: "xcodingapi/wp/v2")
    
    override func setUp() {
        super.setUp()
    }
    
    func test_base_url() {
        XCTAssert(wordpress.baseURL().absoluteString == "https://ispazio.net/xcodingapi/wp/v2")
    }

    func test_url_query() {
        do {
            var items = WordpressQueryItems.init()
            items.add(key: ._embed, value: "1")
            items.add(key: .per_page, value: "10")
            let path = WordpressFinalPath.init(baseURL: wordpress.baseURL(), endpoint: .posts, queries: items.value())
            let url = try path.url()
            print(url.absoluteString)
            XCTAssert(url.absoluteString ==  wordpress.baseURL().absoluteString + "/posts?per_page=10&_embed=1")
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }

}
