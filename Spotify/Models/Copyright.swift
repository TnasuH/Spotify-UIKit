// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let copyright = try? newJSONDecoder().decode(Copyright.self, from: jsonData)

import Foundation

// MARK: - Copyright
public struct Copyright: Codable {
    public let text: String
    public let type: String

    enum CodingKeys: String, CodingKey {
        case text
        case type
    }

    public init(text: String, type: String) {
        self.text = text
        self.type = type
    }
}
