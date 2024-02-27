//
//  File.swift
//  
//
//  Created by Dexter Ramos on 8/31/23.
//

import Foundation
import Yams

// TODO: Separate package

public class DekiParser {
    
    public enum ParseError: Error {
        case notExists(fileName: String)
        case general(message: String)
    }
    
    public enum FileType {
        case json
        case yaml
    }
    
    /// Parse json or yaml file into model
    public static func setupModel<T>(_ model: T.Type, fileName: String, type: FileType = .json, bundle: Bundle = Bundle.main) throws -> T where T: Decodable {
        
        let data: Data
        
        switch type {
        case .json:
            data = try dataFrom(json: fileName, bundle: bundle)
            return try JSONDecoder().decode(T.self, from: data)
        case .yaml:
            data = try dataFrom(yaml: fileName, bundle: bundle)
            return try YAMLDecoder().decode(T.self, from: data)
        }
    }
    
    /// Parse dictionary, array, json string, or yaml string into Model
    public static func setupModel<T>(_ model: T.Type, collection: Any) throws -> T where T: Decodable {
        
        let data: Data
        
        if let _ = collection as? Dictionary<AnyHashable, Any> {
            data = try JSONSerialization.data(withJSONObject: collection, options: .fragmentsAllowed)
        } else if let _ = collection as? Array<Any> {
            data = try JSONSerialization.data(withJSONObject: collection, options: .fragmentsAllowed)
        } else if let string = collection as? String {
            if let stringData = string.data(using: .utf8, allowLossyConversion: false) {
                data = stringData
            } else {
                throw ParseError.general(message: "Unable to encode string using UTF8: \(string)")
            }
        } else {
            throw ParseError.general(message: "Is not a collection: \(collection)")
        }
        
        
        do {
            let createdModel = try JSONDecoder().decode(T.self, from: data)
            return createdModel
        } catch let jsonError {
            do {
                let createdModel = try YAMLDecoder().decode(T.self, from: data)
                return createdModel
            } catch let yamlError {
                let message = """
                Given collection cannot be parsed as JSON nor YAML.
                    -> JSONError: \(jsonError.localizedDescription)
                    -> YAMLError: \(yamlError.localizedDescription)
                """
                throw ParseError.general(message: message)
            }
            
        }
        
    }
    
    /// Parse json or yaml file into object (array or dictionary)
    public static func collectionObject(fileName: String, type: FileType = .json, bundle: Bundle = Bundle.main) throws -> Any {
        
        switch type {
        case .json:
            return try collectionFrom(json: fileName, bundle: bundle)
        case .yaml:
            return try collectionFrom(yaml: fileName, bundle: bundle)
        }
    }
    
    /// Parse json or yaml string into object (array or dictionary)
    public static func collectionObject(string: String) throws -> Any {
        guard let data = string.data(using: .utf8) else {
            throw ParseError.general(message: "String cannot be encoded using UTF8")
        }
        
        do {
            let collection = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            return collection
        } catch let jsonError {
            do {
                guard let collection = try Yams.load(yaml: string) else {
                    throw ParseError.general(message: "Unexpected error while parsing as YAML")
                }
                return collection
                
            } catch let yamlError {
                let message = """
                Given collection cannot be parsed as JSON nor YAML.
                    -> JSONError: \(jsonError.localizedDescription)
                    -> YAMLError: \(yamlError.localizedDescription)
                """
                throw ParseError.general(message: message)
            }
        }
        
    }
}


// MARK: - Utilities

private extension DekiParser {
    static func collectionFrom(json: String, bundle: Bundle) throws -> Any {
        
        guard let url = bundle.url(forResource: json, withExtension: "json") else {
            throw ParseError.notExists(fileName: json)
        }
        
        let data = try Data(contentsOf: url)
        
        let collection = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
        
        return collection
    }
    
    static func collectionFrom(yaml: String, bundle: Bundle) throws -> Any {
        
        var url = bundle.url(forResource: yaml, withExtension: "yaml")
        if url == nil {
            url = bundle.url(forResource: yaml, withExtension: "yml")
            guard url != nil else {
                throw ParseError.notExists(fileName: yaml)
            }
        }
        
        let data = try Data(contentsOf: url!)
        
        guard let yamlString = String(data: data, encoding: .utf8) else {
            throw ParseError.general(message: "Unable to decode yaml")
        }
        
        guard let collection = try Yams.load(yaml: yamlString) else {
            throw ParseError.general(message: "Unable to load yaml")
        }
        
        return collection
    }
    
    static func dataFrom(json: String, bundle: Bundle) throws -> Data {
        
        guard let url = bundle.url(forResource: json, withExtension: "json") else {
            throw ParseError.notExists(fileName: json)
        }
        
        return try Data(contentsOf: url)
    }
    
    static func dataFrom(yaml: String, bundle: Bundle) throws -> Data {
        
        var url = bundle.url(forResource: yaml, withExtension: "yaml")
        if url == nil {
            url = bundle.url(forResource: yaml, withExtension: "yml")
            guard url != nil else {
                throw ParseError.notExists(fileName: yaml)
            }
        }
        
        return try Data(contentsOf: url!)
    }
}
