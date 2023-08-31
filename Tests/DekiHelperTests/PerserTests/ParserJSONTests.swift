//
//  ParserTests.swift
//  
//
//  Created by Ss on 8/31/23.
//

import XCTest
import DekiHelper

class ParserTests: XCTestCase {
    
    let fileNameDevelopers = "developers"
    
    let fileNameEmployee = "employee"
    
    let jsonStringWithArrayContent = #"""
    [
        {
            "name": "deki",
            "department": "research"
        },
        {
            "name": "omen",
            "department": "research"
        },
        {
            "name": "eman",
            "department": "research"
        },
        {
            "name": "simon",
            "department": "research"
        },
    ]
    """#
    let jsonStringWithArrayContent2 = #"[{"name":"deki","department":"research"},{"name":"omen","department":"research"}]"#
    
    let jsonStringWithDictionaryContent = #"""
    {
        "name": "deki",
        "department": "Research - Mobile - iOS"
    }
    """#
    
    let jsonStringWithDictionaryContent2 = #"{"name":"deki","department":"Research - Mobile - iOS"}"#
    
    // MARK: - File To model -- Array content
    
    func testJSONToModelWithArrayContent() throws {
        let developers = try DekiHelper.Parser.setupModel([Developer].self, fileName: fileNameDevelopers, type: .json, bundle: Bundle.module)

        XCTAssertTrue(developers[0].name == "deki")
        XCTAssertTrue(developers[0].department == "research")
        XCTAssertTrue(developers[1].name == "omen")
        XCTAssertTrue(developers[1].department == "research")
        XCTAssertTrue(developers[2].name == "eman")
        XCTAssertTrue(developers[2].department == "research")
        XCTAssertTrue(developers[3].name == "simon")
        XCTAssertTrue(developers[3].department == "research")
    }
    
    // MARK: - File To model -- Dictionary content
    
    func testJSONToModelWithDictionaryContent() throws {
        let employee = try DekiHelper.Parser.setupModel(Employee.self, fileName: fileNameEmployee, type: .json, bundle: .module)
        
        XCTAssertTrue(employee.name == "deki")
        XCTAssertTrue(employee.department == "Research - Mobile - iOS")
    }
    
    
    // MARK: - File to collection object -- Array content

    func testJSONToObjectWithArrayContent() throws {
        let jsonObject = try DekiHelper.Parser.collectionObject(fileName: fileNameDevelopers, type: .json, bundle: .module)
        
        guard case let jsonObject as [[String: String]] = jsonObject else {
            XCTFail("Expecting array content")
            return
        }
        
        XCTAssertTrue(jsonObject[0]["name"] == "deki")
        XCTAssertTrue(jsonObject[0]["department"] == "research")
        XCTAssertTrue(jsonObject[1]["name"] == "omen")
        XCTAssertTrue(jsonObject[1]["department"] == "research")
    }
    
    
    // MARK: - File to collection object -- Dictionary content
    
    func testJSONToObjectWithDictionaryContent() throws {
        let jsonObject = try DekiHelper.Parser.collectionObject(fileName: fileNameEmployee, type: .json, bundle: .module)
        
        guard case let jsonObject as [String: String] = jsonObject else {
            XCTFail("Expecting a dictionary")
            return
        }
        
        XCTAssertTrue(jsonObject["name"] == "deki")
        XCTAssertTrue(jsonObject["department"] == "Research - Mobile - iOS")
    }
    
    
    // MARK: - String To model -- Array content
    
    func testStringToModelWithArrayContent() throws {
        
        let developers = try DekiHelper.Parser.setupModel([Developer].self, collection: jsonStringWithArrayContent)
        
        XCTAssertTrue(developers[0].name == "deki")
        XCTAssertTrue(developers[0].department == "research")
        XCTAssertTrue(developers[1].name == "omen")
        XCTAssertTrue(developers[1].department == "research")
        
        let developers2 = try DekiHelper.Parser.setupModel([Developer].self, collection: jsonStringWithArrayContent2)
        
        XCTAssertTrue(developers2[0].name == "deki")
        XCTAssertTrue(developers2[0].department == "research")
        XCTAssertTrue(developers2[1].name == "omen")
        XCTAssertTrue(developers2[1].department == "research")
    }
    
    
    // MARK: - String To model -- Dictionary content
    
    func testStringToModelWithDictionaryContent() throws {
        
        let employee = try DekiHelper.Parser.setupModel(Employee.self, collection: jsonStringWithDictionaryContent)
        
        XCTAssertTrue(employee.name == "deki")
        XCTAssertTrue(employee.department == "Research - Mobile - iOS")
        
        let employee2 = try DekiHelper.Parser.setupModel(Employee.self, collection: jsonStringWithDictionaryContent2)
        
        XCTAssertTrue(employee2.name == "deki")
        XCTAssertTrue(employee2.department == "Research - Mobile - iOS")
    }
    
    
    // MARK: - String to collection object -- Array content
    
    func testStringToObjectWithArrayContent() throws {
        
        let jsonObject = try DekiHelper.Parser.collectionObject(string: jsonStringWithArrayContent)
        
        guard case let jsonObject as [[String: String]] = jsonObject else {
            XCTFail("Expecting an array")
            return
        }
        
        XCTAssertTrue(jsonObject[0]["name"] == "deki")
        XCTAssertTrue(jsonObject[0]["department"] == "research")
        XCTAssertTrue(jsonObject[1]["name"] == "omen")
        XCTAssertTrue(jsonObject[1]["department"] == "research")
        
        let jsonObject2 = try DekiHelper.Parser.collectionObject(string: jsonStringWithArrayContent2)
        
        guard case let jsonObject2 as [[String: String]] = jsonObject2 else {
            XCTFail("Expecting an array")
            return
        }
        
        XCTAssertTrue(jsonObject2[0]["name"] == "deki")
        XCTAssertTrue(jsonObject2[0]["department"] == "research")
        XCTAssertTrue(jsonObject2[1]["name"] == "omen")
        XCTAssertTrue(jsonObject2[1]["department"] == "research")
        
    }
    
    // MARK: - String to collection object -- Dictionary content

    func testStringToObjectWithDictionaryContent() throws {
        
        let jsonObject = try DekiHelper.Parser.collectionObject(string: jsonStringWithDictionaryContent)
        
        guard case let jsonObject as [String: String] = jsonObject else {
            XCTFail("Expecting a dictionary")
            return
        }
        
        XCTAssertTrue(jsonObject["name"] == "deki")
        XCTAssertTrue(jsonObject["department"] == "Research - Mobile - iOS")
        
        let jsonObject2 = try DekiHelper.Parser.collectionObject(string: jsonStringWithDictionaryContent2)
        
        guard case let jsonObject2 as [String: String] = jsonObject2 else {
            XCTFail("Expecting a dictionary")
            return
        }
        
        XCTAssertTrue(jsonObject2["name"] == "deki")
        XCTAssertTrue(jsonObject2["department"] == "Research - Mobile - iOS")
    }
    
}
