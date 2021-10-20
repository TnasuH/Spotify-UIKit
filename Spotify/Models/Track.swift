// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let track = try? newJSONDecoder().decode(Track.self, from: jsonData)

import Foundation

// MARK: - Track
public struct Track: Codable {
    public let artists: [Artist]
    public let availableMarkets: [String]?
    public let discNumber: Int?
    public let durationms: Int?
    public let explicit: Bool
    public let externalUrls: ExternalUrls?
    public let href: String
    public let id: String
    public let isLocal: Bool?
    public let name: String
    public let previewurl: String?
    public let trackNumber: Int?
    public let type: TrackType
    public let uri: String
    public let album: AlbumElement?
    public let externalids: TrackExternalids?
    public let popularity: Int?

    enum CodingKeys: String, CodingKey {
        case artists
        case availableMarkets
        case discNumber
        case durationms
        case explicit
        case externalUrls
        case href
        case id
        case isLocal
        case name
        case previewurl
        case trackNumber
        case type
        case uri
        case album
        case externalids
        case popularity
    }

    public init(artists: [Artist], availableMarkets: [String], discNumber: Int, durationms: Int, explicit: Bool, externalUrls: ExternalUrls, href: String, id: String, isLocal: Bool, name: String, previewurl: String?, trackNumber: Int, type: TrackType, uri: String, album: AlbumElement?, externalids: TrackExternalids?, popularity: Int?) {
        self.artists = artists
        self.availableMarkets = availableMarkets
        self.discNumber = discNumber
        self.durationms = durationms
        self.explicit = explicit
        self.externalUrls = externalUrls
        self.href = href
        self.id = id
        self.isLocal = isLocal
        self.name = name
        self.previewurl = previewurl
        self.trackNumber = trackNumber
        self.type = type
        self.uri = uri
        self.album = album
        self.externalids = externalids
        self.popularity = popularity
    }
}
