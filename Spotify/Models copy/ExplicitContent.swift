// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let explicitContent = try? newJSONDecoder().decode(ExplicitContent.self, from: jsonData)

import Foundation

// MARK: - ExplicitContent
public struct ExplicitContent: Codable {
    public let filterEnabled: Bool
    public let filterLocked: Bool

    enum CodingKeys: String, CodingKey {
        case filterEnabled
        case filterLocked
    }

    public init(filterEnabled: Bool, filterLocked: Bool) {
        self.filterEnabled = filterEnabled
        self.filterLocked = filterLocked
    }
}
