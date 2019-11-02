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
        let expectation = self.expectation(description: #function)
        
        self.wordpress.get(endpoint: .posts).string { result in
            XCTAssertFalse(self.test_result(result: result).isEmpty)
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
            XCTAssertFalse(self.test_result(result: result).isEmpty)
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
            XCTAssertFalse(self.test_result(result: result).isEmpty)
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
            XCTAssertFalse(self.test_result(result: result).title.rendered.isEmpty)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_posts_json() {
        let expectation = self.expectation(description: #function)

        wordpress.get(endpoint: .media).json { result in
            XCTAssert(self.test_result(result: result) is NSArray)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_sequence_request() {
        let expectation = self.expectation(description: #function)
        
        let session = wordpress.get(endpoint: .posts)
        
        session.json(result: { XCTAssert(self.test_result(result: $0) is NSArray) })
            .json(result: { XCTAssert(self.test_result(result: $0) is NSArray) })
            .json(result: { XCTAssert(self.test_result(result: $0) is NSArray) })
        
        sleep(2)
        
        session.decode(type: [WordpressPost].self)
        { (result) in
            XCTAssertFalse(self.test_result(result: result).isEmpty)
        }.data { (result) in
            XCTAssertFalse(self.test_result(result: result).isEmpty)
        }
        
        sleep(1)
        
        session.string { result in
            XCTAssertFalse(self.test_result(result: result).isEmpty)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_result<T>(result: WordpressResult<T>) -> T {
        XCTAssertNotNil(result.value)
        XCTAssertNil(result.error, result.error!.localizedDescription)
        return result.value!
    }
    
}
