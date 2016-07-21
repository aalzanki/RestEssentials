//
//  RestEssentialsTests.swift
//  RestEssentialsTests
//
//  Created by Sean Kosanovich on 7/30/15.
//  Copyright © 2015 Sean Kosanovich. All rights reserved.
//

import XCTest
@testable import RestEssentials

class RestControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGET() {
        let expectation = expectationWithDescription("GET JSON network call")

        guard let rest = RestController.createFromURLString("http://httpbin.org/get") else {
            XCTFail("Bad URL")
            return
        }

        try! rest.get { result, httpResponse in
            do {
                let json = try result.value()
                print(json)
                XCTAssert(json["url"]?.stringValue == "http://httpbin.org/get")

                expectation.fulfill()
            } catch {
                XCTFail("Error performing GET: \(error)")
            }
        }
        
        waitForExpectationsWithTimeout(5) { (error) -> Void in
            if let _ = error {
                XCTFail("Test timeout reached")
            }
        }
    }
    
    func testPOST() {
        let expectation = expectationWithDescription("POST JSON network call")

        guard let rest = RestController.createFromURLString("http://httpbin.org") else {
            XCTFail("Bad URL")
            return
        }

        try! rest.post("post", withJSON: JSON(dict: ["key1": "value1", "key2": 2, "key3": 4.5, "key4": true])) { result, httpResponse in
            do {
                let json = try result.value()
                print(json)
                XCTAssert(json["url"]?.stringValue == "http://httpbin.org/post")
                XCTAssert(json["json"]?["key1"]?.stringValue == "value1")
                XCTAssert(json["json"]?["key2"]?.integerValue == 2)
                XCTAssert(json["json"]?["key3"]?.doubleValue == 4.5)
                XCTAssert(json["json"]?["key4"]?.boolValue == true)

                expectation.fulfill()
            } catch {
                XCTFail("Error performing POST: \(error)")
            }
        }

        waitForExpectationsWithTimeout(5) { (error) -> Void in
            if let _ = error {
                XCTFail("Test timeout reached")
            }
        }
    }

    func testPUT() {
        let expectation = expectationWithDescription("PUT JSON network call")

        guard let rest = RestController.createFromURLString("http://httpbin.org") else {
            XCTFail("Bad URL")
            return
        }

        try! rest.put("put", withJSON: JSON(dict: ["key1": "value1", "key2": 2, "key3": 4.5, "key4": true])) { result, httpResponse in
            do {
                let json = try result.value()
                print(json)
                XCTAssert(json["url"]?.stringValue == "http://httpbin.org/put")

                expectation.fulfill()
            } catch {
                XCTFail("Error performing PUT: \(error)")
            }
        }

        waitForExpectationsWithTimeout(5) { (error) -> Void in
            if let _ = error {
                XCTFail("Test timeout reached")
            }
        }
    }

    func testGetImage() {
        let expectation = expectationWithDescription("GET Image network call")

        guard let rest = RestController.createFromURLString("https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png") else {
            XCTFail("Bad URL")
            return
        }

        try! rest.get(withResponseHandler: ImageResponseHandler()) { result, httpResponse in
            do {
                let img = try result.value()
                XCTAssert(img.isKindOfClass(UIImage.self))

                expectation.fulfill()
            } catch {
                XCTFail("Error performing GET: \(error)")
            }
        }

        waitForExpectationsWithTimeout(5) { (error) -> Void in
            if let _ = error {
                XCTFail("Test timeout reached")
            }
        }
    }

    func testVoidResponse() {
        let expectation = expectationWithDescription("GET Void network call")

        guard let rest = RestController.createFromURLString("https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png") else {
            XCTFail("Bad URL")
            return
        }

        try! rest.get(withResponseHandler: VoidResponseHandler()) { _, httpResponse in
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(5) { (error) -> Void in
            if let _ = error {
                XCTFail("Test timeout reached")
            }
        }
    }

    func testDataResponse() {
        let expectation = expectationWithDescription("GET Data network call")

        guard let rest = RestController.createFromURLString("https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png") else {
            XCTFail("Bad URL")
            return
        }

        try! rest.get(withResponseHandler: DataesponseHandler()) { result, httpResponse in
            do {
                let data = try result.value()
                XCTAssert(data.isKindOfClass(NSData.self))

                expectation.fulfill()
            } catch {
                XCTFail("Error performing GET: \(error)")
            }
        }

        waitForExpectationsWithTimeout(5) { (error) -> Void in
            if let _ = error {
                XCTFail("Test timeout reached")
            }
        }
    }

}
