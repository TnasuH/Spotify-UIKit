// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let track = try? newJSONDecoder().decode(Track.self, from: jsonData)
//
// To read values from URLs:
//
//   let task = URLSession.shared.trackTask(with: url) { track, response, error in
//     if let track = track {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - Track
public struct Track: Codable {
    public let album: AlbumElement
    public let artists: [Owner]
    public let availableMarkets: [String]
    public let discNumber: Int
    public let durationms: Int
    public let episode: Bool?
    public let explicit: Bool
    public let externalids: TrackExternalids
    public let externalUrls: ExternalUrls
    public let href: String
    public let id: String
    public let isLocal: Bool
    public let name: String
    public let popularity: Int
    public let previewurl: String?
    public let track: Bool?
    public let trackNumber: Int
    public let type: TrackType
    public let uri: String

    enum CodingKeys: String, CodingKey {
        case album = "album"
        case artists = "artists"
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationms = "duration_ms"
        case episode = "episode"
        case explicit = "explicit"
        case externalids = "external_ids"
        case externalUrls = "external_urls"
        case href = "href"
        case id = "id"
        case isLocal = "is_local"
        case name = "name"
        case popularity = "popularity"
        case previewurl = "preview_url"
        case track = "track"
        case trackNumber = "track_number"
        case type = "type"
        case uri = "uri"
    }

    public init(album: AlbumElement, artists: [Owner], availableMarkets: [String], discNumber: Int, durationms: Int, episode: Bool?, explicit: Bool, externalids: TrackExternalids, externalUrls: ExternalUrls, href: String, id: String, isLocal: Bool, name: String, popularity: Int, previewurl: String?, track: Bool?, trackNumber: Int, type: TrackType, uri: String) {
        self.album = album
        self.artists = artists
        self.availableMarkets = availableMarkets
        self.discNumber = discNumber
        self.durationms = durationms
        self.episode = episode
        self.explicit = explicit
        self.externalids = externalids
        self.externalUrls = externalUrls
        self.href = href
        self.id = id
        self.isLocal = isLocal
        self.name = name
        self.popularity = popularity
        self.previewurl = previewurl
        self.track = track
        self.trackNumber = trackNumber
        self.type = type
        self.uri = uri
    }
}
