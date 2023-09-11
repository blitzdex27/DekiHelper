# DekiHelper

- Parsing - `DekiHelper.Parser.<methods>`
- Floating view - `DekiFloatingView`

## Samples

Model struct

```swift
struct Developer: Decodable {
    var name: String
    var department: String
}
```

### Parse JSON/YAML file into Model

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

// Code
let developers = try DekiHelper.Parser.setupModel(
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
> The json file here contains an array of dictionary, so we used `[Developer].self`, and therefore an array of `Developer` instances were created.
> If the json file contains a dictionary, you should use `Developer.self` instead, and it will create a single `Developer` instance
> This similar when you use the swift provided `JSONDecoder`

See more [parsing samples](./README/parsing-samples.md)
