// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getAlbums = try? newJSONDecoder().decode(GetAlbums.self, from: jsonData)

import Foundation

// MARK: - GetAlbums
public struct GetAlbums: Codable {
    public let albumType: AlbumTypeEnum?
    public let artists: [Artist]
    public let availableMarkets: [String]?
    public let copyrights: [Copyright]
    public let externalids: GetAlbumsExternalids?
    public let externalUrls: ExternalUrls?
    public let genres: [JSONAny]
    public let href: String
    public let id: String
    public let images: [Image]
    public let label: String
    public let name: String
    public let popularity: Int
    public let releaseDate: String?
    public let releaseDatePrecision: ReleaseDatePrecision?
    public let totalTracks: Int?
    public let tracks: Tracks
    public let type: AlbumTypeEnum
    public let uri: String

    enum CodingKeys: String, CodingKey {
        case albumType
        case artists
        case availableMarkets
        case copyrights
        case externalids
        case externalUrls
        case genres
        case href
        case id
        case images
        case label
        case name
        case popularity
        case releaseDate
        case releaseDatePrecision
        case totalTracks
        case tracks
        case type
        case uri
    }

    public init(albumType: AlbumTypeEnum, artists: [Artist], availableMarkets: [String], copyrights: [Copyright], externalids: GetAlbumsExternalids, externalUrls: ExternalUrls, genres: [JSONAny], href: String, id: String, images: [Image], label: String, name: String, popularity: Int, releaseDate: String, releaseDatePrecision: ReleaseDatePrecision, totalTracks: Int, tracks: Tracks, type: AlbumTypeEnum, uri: String) {
        self.albumType = albumType
        self.artists = artists
        self.availableMarkets = availableMarkets
        self.copyrights = copyrights
        self.externalids = externalids
        self.externalUrls = externalUrls
        self.genres = genres
        self.href = href
        self.id = id
        self.images = images
        self.label = label
        self.name = name
        self.popularity = popularity
        self.releaseDate = releaseDate
        self.releaseDatePrecision = releaseDatePrecision
        self.totalTracks = totalTracks
        self.tracks = tracks
        self.type = type
        self.uri = uri
    }
}
