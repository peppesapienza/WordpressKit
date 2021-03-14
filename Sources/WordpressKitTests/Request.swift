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
        wordpress = Wordpress(route: "https://www.ilfattoquotidiano.it/wp-json", namespace: .wp(v: .v2))
    }
    
    func test_posts_string() {
        let expectation = self.expectation(description: #function)
        
        self.wordpress.get(endpoint: .posts).string { result in
            self.test_result(result: result)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_posts_decode() {
        let expectation = self.expectation(description: #function)
        
        wordpress
            .get(endpoint: .posts)
            .embed()
            .decode(type: [WordpressPost].self)
        { (result) in
            self.test_result(result: result)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    
    func test_posts_query_decode() {
        let expectation = self.expectation(description: #function)
        
        wordpress
            .get(endpoint: .posts)
            .query(key: .page, value: "1")
            .query(key: .search, value: "casa")
            .decode(type: [WordpressPost].self)
        { (result) in
            self.test_result(result: result)
            expectation.fulfill()
        }
                
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_single_post_decode() {
        let expectation = self.expectation(description: #function)
        
        wordpress
            .get(endpoint: .post(id: "5508442"))
            .embed()
            .decode(type: WordpressPost.self)
        { (result) in
            self.test_result(result: result)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_posts_json() {
        let expectation = self.expectation(description: #function)

        wordpress.get(endpoint: .media).json { result in
            self.test_result(result: result)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_sequence_pages_request() {
        let expectation = self.expectation(description: #function)
        
        let session = wordpress.get(endpoint: .posts)
        
        session.decode(type: [WordpressPost].self)
        { (result) in
            self.test_result(result: result)
        }
        
        sleep(1)
        
        session
            .query(key: .page, value: "2")
            .decode(type: [WordpressPost].self)
        { (result) in
            self.test_result(result: result)
        }
        
        sleep(1)
        
        session
            .query(key: .page, value: "3")
            .decode(type: [WordpressPost].self)
        { (result) in
            self.test_result(result: result)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_session_invalidateAndCancel() {
        let expectation = self.expectation(description: #function)
        
        wordpress
            .get(endpoint: .posts)
            .decode(type: [WordpressPost].self)
        { (result) in
            XCTAssertNotNil(result.error)
            expectation.fulfill()
        }
        .invalidateAndCancel()
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_result<T>(result: WordpressResult<T>) {
        XCTAssertNotNil(result.value)
        XCTAssertNil(result.error, result.error!.localizedDescription)
    }
    
}
