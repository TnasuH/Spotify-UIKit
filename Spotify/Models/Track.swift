// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let track = try? newJSONDecoder().decode(Track.self, from: jsonData)

import Foundation

// MARK: - Track
public struct Track: Codable {
    public let album: AlbumElement?
    public let artists: [Owner]
    public let discNumber: Int?
    public let durationms: Int?
    public let explicit: Bool?
    public let externalids: Externalids?
    public let externalUrls: ExternalUrls?
    public let href: String?
    public let id: String?
    public let isLocal: Bool?
    public let isPlayable: Bool?
    public let name: String?
    public let popularity: Int?
    public let previewurl: String?
    public let trackNumber: Int?
    public let type: TrackType?
    public let uri: String?

    enum CodingKeys: String, CodingKey {
        case album
        case artists
        case discNumber
        case durationms
        case explicit
        case externalids
        case externalUrls
        case href
        case id
        case isLocal
        case isPlayable
        case name
        case popularity
        case previewurl
        case trackNumber
        case type
        case uri
    }

    public init(album: AlbumElement, artists: [Owner], discNumber: Int, durationms: Int, explicit: Bool, externalids: Externalids, externalUrls: ExternalUrls, href: String, id: String, isLocal: Bool, isPlayable: Bool, name: String, popularity: Int, previewurl: String?, trackNumber: Int, type: TrackType, uri: String) {
        self.album = album
        self.artists = artists
        self.discNumber = discNumber
        self.durationms = durationms
        self.explicit = explicit
        self.externalids = externalids
        self.externalUrls = externalUrls
        self.href = href
        self.id = id
        self.isLocal = isLocal
        self.isPlayable = isPlayable
        self.name = name
        self.popularity = popularity
        self.previewurl = previewurl
        self.trackNumber = trackNumber
        self.type = type
        self.uri = uri
    }
}
