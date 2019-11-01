//
//  Request.swift
//  WordpressKitTests
//
//  Created by Giuseppe Sapienza on 10/06/18.
//  Copyright © 2018 Giuseppe Sapienza. All rights reserved.
//

import XCTest
@testable import WordpressKit

class Request: XCTestCase {
    
    let timeout: TimeInterval = 15
    var wordpress: Wordpress!
    
    override func setUp() {
        super.setUp()
        wordpress = Wordpress(root: "https://www.ilfattoquotidiano.it", namespace: "wp-json/wp/v2")
    }
    
    func test_posts_string() {
        let expectation = self.expectation(description: "request string result")
        
        self.wordpress.get(endpoint: .posts).string { result in
            switch result {
            case .value(let s): XCTAssert(!s.isEmpty)
            case .error(let e): XCTFail(e.localizedDescription)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_posts_decode() {
        let expectation = self.expectation(description: "request posts decode")
        
        wordpress
            .get(endpoint: .posts)
            .embed()
            .decode(type: [WordpressPost].self)
        { (result) in
            print(result)
            switch result {
            case .value(let array):
                // array.forEach({print( $0.title.rendered )})
                XCTAssert(!array.isEmpty)
                
            case .error(let e):
                XCTFail(e.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    
    func test_posts_query_decode() {
        let expectation = self.expectation(description: "request posts decode with query")
        
        wordpress
            .get(endpoint: .posts)
            .query(key: .page, value: "1")
            .query(key: .search, value: "casa")
            .decode(type: [WordpressPost].self)
        { (result) in
                switch result {
                case .value(let array):
                    XCTAssert(!array.isEmpty)
                    
                case .error(let e):
                    XCTFail(e.localizedDescription)
                }
                
                expectation.fulfill()
        }
                
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_post_query_decode() {
        let expectation = self.expectation(description: "request post decode")
        
        wordpress
            .get(endpoint: .post(id: "5508442"))
            .embed()
            .decode(type: WordpressPost.self)
        { (result) in
            switch result {
            case .value(let post):
                XCTAssert(!post.title.rendered.isEmpty)
                
            default: return
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_posts_json() {
        let expectation = self.expectation(description: "request json result")

        wordpress.get(endpoint: .media).json { result in
            switch result {
            case .value(let object):
                XCTAssert(object is NSArray)
            case .error(let e): XCTFail(e.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
    waitForExpectations(timeout: timeout, handler: nil)
    }
    
}
