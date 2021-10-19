// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let externalUrls = try? newJSONDecoder().decode(ExternalUrls.self, from: jsonData)

import Foundation

// MARK: - ExternalUrls
public struct ExternalUrls: Codable {
    public let spotify: String

    enum CodingKeys: String, CodingKey {
        case spotify
    }

    public init(spotify: String) {
        self.spotify = spotify
    }
}
