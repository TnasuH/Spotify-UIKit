// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let playlistsItem = try? newJSONDecoder().decode(PlaylistsItem.self, from: jsonData)

import Foundation

// MARK: - PlaylistsItem
public struct PlaylistsItem: Codable {
    public let collaborative: Bool
    public let itemDescription: String?
    public let externalUrls: ExternalUrls?
    public let href: String
    public let id: String
    public let images: [Image]
    public let name: String
    public let owner: Owner
    public let primaryColor: JSONNull?
    public let itemPublic: JSONNull?
    public let snapshotid: String?
    public let tracks: Followers
    public let type: String
    public let uri: String

    enum CodingKeys: String, CodingKey {
        case collaborative
        case itemDescription
        case externalUrls
        case href
        case id
        case images
        case name
        case owner
        case primaryColor
        case itemPublic
        case snapshotid
        case tracks
        case type
        case uri
    }

    public init(collaborative: Bool, itemDescription: String, externalUrls: ExternalUrls, href: String, id: String, images: [Image], name: String, owner: Owner, primaryColor: JSONNull?, itemPublic: JSONNull?, snapshotid: String?, tracks: Followers, type: String, uri: String) {
        self.collaborative = collaborative
        self.itemDescription = itemDescription
        self.externalUrls = externalUrls
        self.href = href
        self.id = id
        self.images = images
        self.name = name
        self.owner = owner
        self.primaryColor = primaryColor
        self.itemPublic = itemPublic
        self.snapshotid = snapshotid
        self.tracks = tracks
        self.type = type
        self.uri = uri
    }
}
