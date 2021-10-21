// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let artist = try? newJSONDecoder().decode(Artist.self, from: jsonData)

import Foundation

// MARK: - Artist
public struct Artist: Codable {
    public let displayName: DisplayName?
    public let externalUrls: ExternalUrls?
    public let href: String
    public let id: String
    public let type: ArtistType
    public let uri: String
    public let name: String?

    enum CodingKeys: String, CodingKey {
        case displayName
        case externalUrls
        case href
        case id
        case type
        case uri
        case name
    }

    public init(displayName: DisplayName?, externalUrls: ExternalUrls, href: String, id: String, type: ArtistType, uri: String, name: String?) {
        self.displayName = displayName
        self.externalUrls = externalUrls
        self.href = href
        self.id = id
        self.type = type
        self.uri = uri
        self.name = name
    }
}
