// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let albumElement = try? newJSONDecoder().decode(AlbumElement.self, from: jsonData)

import Foundation

// MARK: - AlbumElement
public struct AlbumElement: Codable {
    public let albumType: AlbumTypeEnum?
    public let artists: [Owner]
    public let availableMarkets: [String]?
    public let externalUrls: ExternalUrls?
    public let href: String
    public let id: String
    public let images: [Image]
    public let name: String
    public let releaseDate: String?
    public let releaseDatePrecision: ReleaseDatePrecision?
    public let totalTracks: Int?
    public let type: AlbumTypeEnum
    public let uri: String

    enum CodingKeys: String, CodingKey {
        case albumType
        case artists
        case availableMarkets
        case externalUrls
        case href
        case id
        case images
        case name
        case releaseDate
        case releaseDatePrecision
        case totalTracks
        case type
        case uri
    }

    public init(albumType: AlbumTypeEnum, artists: [Owner], availableMarkets: [String]?, externalUrls: ExternalUrls, href: String, id: String, images: [Image], name: String, releaseDate: String?, releaseDatePrecision: ReleaseDatePrecision, totalTracks: Int, type: AlbumTypeEnum, uri: String) {
        self.albumType = albumType
        self.artists = artists
        self.availableMarkets = availableMarkets
        self.externalUrls = externalUrls
        self.href = href
        self.id = id
        self.images = images
        self.name = name
        self.releaseDate = releaseDate
        self.releaseDatePrecision = releaseDatePrecision
        self.totalTracks = totalTracks
        self.type = type
        self.uri = uri
    }
}
