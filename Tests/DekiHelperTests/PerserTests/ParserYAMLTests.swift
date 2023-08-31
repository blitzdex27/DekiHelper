//
//  ParserYAMLTests.swift
//  
//
//  Created by Dexter Ramos on 8/31/23.
//

import XCTest
import DekiHelper

class ParserYAMLTests: XCTestCase {

    let fileNameDevelopers = "developers"
    
    let fileNameEmployee = "employee"

    let yamlStringWithArrayContent = #"""
    - name: deki
      department: research
    - name: omen
      department: research
    """#
    
    /// reference: https://onlineyamltools.com/minify-yaml
    let yamlStringWithArrayContent2 = #"[{name: deki, department: research}, {name: omen, department: research}]"#
    
    let yamlStringWithDictionaryContent = #"""
    name: deki
    department: Research - Mobile - iOS
    """#
    
    let yamlStringWithDictionaryContent2 = #"{name: deki, department: Research - Mobile - iOS}"#
    
    // MARK: - File To model -- Array content
    
    func testYAMLToModelWithArrayContent() throws {
        let developers = try DekiHelper.Parser.setupModel([Developer].self, fileName: fileNameDevelopers, type: .yaml, bundle: .module)
        
        XCTAssertTrue(developers[0].name == "deki")
        XCTAssertTrue(developers[0].department == "research")
        XCTAssertTrue(developers[1].name == "omen")
        XCTAssertTrue(developers[1].department == "research")
    }
    
    
    // MARK: - File To model -- Dictionary content

    func testYAMLToModelWithDictionaryContent() throws {
        let employee = try DekiHelper.Parser.setupModel(Employee.self, fileName: fileNameEmployee, type: .yaml, bundle: .module)
        
        XCTAssertTrue(employee.name == "deki")
        XCTAssertTrue(employee.department == "Research - Mobile - iOS")
    }
    
    
    // MARK: - File to collection object -- Array content
    
    func testYAMLWithArrayContent() throws {
        let yaml = try DekiHelper.Parser.collectionObject(fileName: fileNameDevelopers, type: .yaml, bundle: .module)
        
        guard case _ as [Any] = yaml else {
            XCTFail("Expecting array content")
            return
        }
    }
    
    
    // MARK: - File to collection object -- Dictionary content

    func testYAMLToObjectWithDictionaryContent() throws {
        let yamlObject = try DekiHelper.Parser.collectionObject(fileName: fileNameEmployee, type: .yaml, bundle: .module)
        
        guard case let yamlObject as [String: String] = yamlObject else {
            XCTFail("Expecting a dictionary")
            return
        }
        
        XCTAssertTrue(yamlObject["name"] == "deki")
        XCTAssertTrue(yamlObject["department"] == "Research - Mobile - iOS")
    }
    
    
    // MARK: - String To model -- Array content
    
    func testStringToModelWithArrayContent() throws {
        
        let developers = try DekiHelper.Parser.setupModel([Developer].self, collection: yamlStringWithArrayContent)
        
        XCTAssertTrue(developers[0].name == "deki")
        XCTAssertTrue(developers[0].department == "research")
        XCTAssertTrue(developers[1].name == "omen")
        XCTAssertTrue(developers[1].department == "research")
        
        let developers2 = try DekiHelper.Parser.setupModel([Developer].self, collection: yamlStringWithArrayContent2)
        
        XCTAssertTrue(developers2[0].name == "deki")
        XCTAssertTrue(developers2[0].department == "research")
        XCTAssertTrue(developers2[1].name == "omen")
        XCTAssertTrue(developers2[1].department == "research")
    }
    
    
    // MARK: - String To model -- Dictionary content
    
    func testStringToModelWithDictionaryContent() throws {
        
        let employee = try DekiHelper.Parser.setupModel(Employee.self, collection: yamlStringWithDictionaryContent)
        
        XCTAssertTrue(employee.name == "deki")
        XCTAssertTrue(employee.department == "Research - Mobile - iOS")
        
        let employee2 = try DekiHelper.Parser.setupModel(Employee.self, collection: yamlStringWithDictionaryContent2)
        
        XCTAssertTrue(employee2.name == "deki")
        XCTAssertTrue(employee2.department == "Research - Mobile - iOS")
    }
    
    
    // MARK: - String to collection object -- Array content
    
    func testStringToObjectWithArrayContent() throws {
        
        let yamlObject = try DekiHelper.Parser.collectionObject(string: yamlStringWithArrayContent)
        
        guard case let yamlObject as [[String: String]] = yamlObject else {
            XCTFail("Expecting an array")
            return
        }
        
        XCTAssertTrue(yamlObject[0]["name"] == "deki")
        XCTAssertTrue(yamlObject[0]["department"] == "research")
        XCTAssertTrue(yamlObject[1]["name"] == "omen")
        XCTAssertTrue(yamlObject[1]["department"] == "research")
        
        let yamlObject2 = try DekiHelper.Parser.collectionObject(string: yamlStringWithArrayContent2)
        
        guard case let yamlObject2 as [[String: String]] = yamlObject2 else {
            XCTFail("Expecting an array")
            return
        }
        
        XCTAssertTrue(yamlObject2[0]["name"] == "deki")
        XCTAssertTrue(yamlObject2[0]["department"] == "research")
        XCTAssertTrue(yamlObject2[1]["name"] == "omen")
        XCTAssertTrue(yamlObject2[1]["department"] == "research")
        
    }
    
    
    // MARK: - String to collection object -- Dictionary content

    func testStringToObjectWithDictionaryContent() throws {
        
        let yamlObject = try DekiHelper.Parser.collectionObject(string: yamlStringWithDictionaryContent)
        
        guard case let yamlObject as [String: String] = yamlObject else {
            XCTFail("Expecting a dictionary")
            return
        }
        
        XCTAssertTrue(yamlObject["name"] == "deki")
        XCTAssertTrue(yamlObject["department"] == "Research - Mobile - iOS")
        
        let yamlObject2 = try DekiHelper.Parser.collectionObject(string: yamlStringWithDictionaryContent2)
        
        guard case let yamlObject2 as [String: String] = yamlObject2 else {
            XCTFail("Expecting a dictionary")
            return
        }
        
        XCTAssertTrue(yamlObject2["name"] == "deki")
        XCTAssertTrue(yamlObject2["department"] == "Research - Mobile - iOS")
    }

}
