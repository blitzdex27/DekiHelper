# Parsing

Use `DekiParser` methods to parse dictionary/array from string or files in json or yaml format.

```swift
let jsonString = #"[{"name":"deki","department":"research"},{"name":"omen","department":"research"}]"#

struct Developer: Decodable {
    var name: String
    var department: String
}

let developers = try? DekiParser.setupModel(
    [Developer].self,
    collection: jsonString
)
```

## Overview

`DekiParser` have various methods that can be used for specific case of parsing.

- `setupModel(_:fileName:type:bundle:)` - parse json or yaml file into model
- `setupModel(_:collection:)` - parse dictionary, array, json string, or yaml string into Model
- `collectionObject(fileName:type:bundle:)` - parse json or yaml file into object (array or dictionary)
- `collectionObject(string:)` - parse json or yaml string into object (array or dictionary)

## Topics

### Parse json or yaml file into model

JSON file - `developers.json`

```json
[
    {
        "name": "deki",
        "department": "research"
    },
    {
        "name": "omen",
        "department": "research"
    }
]
```

Swift file

```swift
// Model
struct Developer: Decodable {
    var name: String
    var department: String
}

// Parse
let developers = try DekiParser.setupModel(
    [Developer].self,
    fileName: fileNameDevelopers,
    type: .json,
    bundle: Bundle.module
)

print(developers[0].name) // deki
print(developers[0].department) // research
print(developers[1].name) // omen
print(developers[1].department) // research
```

> **Note**
> 
> The json file here contains an array of dictionary, so we used [Developer].self, and therefore an array of Developer instances were created. If the json file contains a dictionary, you should use Developer.self instead, and it will create a single Developer instance This similar when you use the swift provided JSONDecoder

### Parse JSON/YAML string into Model

```swift
let jsonStringWithArrayContent = #"[{"name":"deki","department":"research"},{"name":"omen","department":"research"}]"#

let developers = try DekiParser.setupModel(
    [Developer].self,
    collection: jsonStringWithArrayContent
)

print(developers[0].name) // deki
print(developers[0].department) // research
print(developers[1].name) // omen
print(developers[1].department) // research
```

### Parse JSON/YAML file into swift object

```swift
let jsonObject = try DekiParser.collectionObject(
    fileName: fileNameEmployee,
    type: .json,
    bundle: .module
)

guard case let jsonObject as [String: String] = jsonObject else {
    XCTFail("Expecting a dictionary")
    return
}
```

### Parse JSON/YAML string into swift object

```swift
let jsonStringWithDictionaryContent = #"{"name":"deki","department":"Research - Mobile - iOS"}"#

let jsonObject = try DekiParser.collectionObject(string: jsonStringWithDictionaryContent)

guard let jsonObject = jsonObject as? [String: String] else {
    return
} 

print(jsonObject["name"]) // deki
print(jsonObject["department"]) // Research - Mobile - iOS
```

### Public Interface

```swift

public class DekiParser {

    public enum ParseError : Error {
        case notExists(fileName: String)
        case general(message: String)
    }

    public enum FileType {
        case json
        case yaml
    }

    /// Parse json or yaml file into model
    public static func setupModel<T>(_ model: T.Type, fileName: String, type: FileType = .json, bundle: Bundle = Bundle.main) throws -> T where T : Decodable

    /// Parse dictionary, array, json string, or yaml string into Model
    public static func setupModel<T>(_ model: T.Type, collection: Any) throws -> T where T : Decodable

    /// Parse json or yaml file into object (array or dictionary)
    public static func collectionObject(fileName: String, type: FileType = .json, bundle: Bundle = Bundle.main) throws -> Any

    /// Parse json or yaml string into object (array or dictionary)
    public static func collectionObject(string: String) throws -> Any
}

```
