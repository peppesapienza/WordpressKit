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
    
    let timeout: TimeInterval = 10
    
    override func setUp() {
        super.setUp()
        Wordpress.initialize(root: "https://ispazio.net/", namespace: "xcodingapi/wp/v2")
    }
    
    func test_posts_string() {
        let expectation = self.expectation(description: "request string result")
        
        Wordpress.get(endpoint: .posts).string { result in
            switch result {
            case .value(let s): XCTAssert(!s.isEmpty)
            case .error(let e): XCTFail(e.localizedDescription)
            }
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_posts_decode() {
        let expectation = self.expectation(description: "request string result")
        
        Wordpress.get(endpoint: .posts).embed().decode(type: [WordpressPost].self) { (result) in
            switch result {
            case .value(let array):
                XCTAssert(!array.isEmpty)
                
            case .error(let e): XCTFail(e.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_posts_query_decode() {
        let expectation = self.expectation(description: "request string result")
        
        Wordpress
            .get(endpoint: .post(id: "1863739"))
            .embed()
            .decode(type: WordpressPost.self)
        { (result) in
            switch result {
            case .value(let post):
                print(post.date, post.date_gmt)
            default: return
            }
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_posts_json() {
        let expectation = self.expectation(description: "request json result")

        Wordpress.get(endpoint: .media).json { result in
            switch result {
            case .value(let object):
                print(object)
                XCTAssert(object is NSArray)
            case .error(let e): XCTFail(e.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
}
