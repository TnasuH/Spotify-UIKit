// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let seed = try? newJSONDecoder().decode(Seed.self, from: jsonData)

import Foundation

// MARK: - Seed
public struct Seed: Codable {
    public let initialPoolSize: Int
    public let afterFilteringSize: Int
    public let afterRelinkingSize: Int
    public let id: String
    public let type: String
    public let href: String?

    enum CodingKeys: String, CodingKey {
        case initialPoolSize
        case afterFilteringSize
        case afterRelinkingSize
        case id
        case type
        case href
    }

    public init(initialPoolSize: Int, afterFilteringSize: Int, afterRelinkingSize: Int, id: String, type: String, href: String) {
        self.initialPoolSize = initialPoolSize
        self.afterFilteringSize = afterFilteringSize
        self.afterRelinkingSize = afterRelinkingSize
        self.id = id
        self.type = type
        self.href = href
    }
}
