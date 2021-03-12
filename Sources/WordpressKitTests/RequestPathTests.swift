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
    
    func test_base_url() {
        let wordpress = Wordpress(route: "https://www.ilfattoquotidiano.it/wp-json", namespace: .custom(path: "wp/v2"))
        XCTAssertTrue(wordpress.baseURL().pathComponents.elementsEqual(["/", "wp-json", "wp", "v2"]))
    }

    
    func test_url_query() {
        do {
            let wordpress = Wordpress(route: "https://www.ilfattoquotidiano.it/wp-json/", namespace: .wp(v: .v2))
            var items = WordpressQueryItems.init()
            items.add(key: ._embed, value: "1")
            items.add(key: .per_page, value: "10")
            let path = WordpressFinalPath.init(baseURL: wordpress.baseURL(), endpoint: .posts, queries: items.value())
            let url = try path.url()
            XCTAssertNotNil(url.query)
            XCTAssertTrue(url.query!.contains("_embed=1"))
            XCTAssertTrue(url.query!.contains("per_page=10"))
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }

}
