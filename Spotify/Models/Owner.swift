// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let owner = try? newJSONDecoder().decode(Owner.self, from: jsonData)

import Foundation

// MARK: - Owner
public struct Owner: Codable {
    public let externalUrls: ExternalUrls?
    public let href: String
    public let id: String
    public let name: String?
    public let type: OwnerType
    public let uri: String
    public let displayName: String?

    enum CodingKeys: String, CodingKey {
        case externalUrls
        case href
        case id
        case name
        case type
        case uri
        case displayName
    }

    public init(externalUrls: ExternalUrls, href: String, id: String, name: String?, type: OwnerType, uri: String, displayName: String?) {
        self.externalUrls = externalUrls
        self.href = href
        self.id = id
        self.name = name
        self.type = type
        self.uri = uri
        self.displayName = displayName
    }
}
