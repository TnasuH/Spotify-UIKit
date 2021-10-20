// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getArtist = try? newJSONDecoder().decode(GetArtist.self, from: jsonData)

import Foundation

// MARK: - GetArtist
public struct GetArtist: Codable {
    public let externalUrls: ExternalUrls
    public let followers: Followers
    public let genres: [String]
    public let href: String
    public let id: String
    public let images: [Image]
    public let name: String
    public let popularity: Int
    public let type: ArtistType
    public let uri: String

    enum CodingKeys: String, CodingKey {
        case externalUrls
        case followers
        case genres
        case href
        case id
        case images
        case name
        case popularity
        case type
        case uri
    }

    public init(externalUrls: ExternalUrls, followers: Followers, genres: [String], href: String, id: String, images: [Image], name: String, popularity: Int, type: ArtistType, uri: String) {
        self.externalUrls = externalUrls
        self.followers = followers
        self.genres = genres
        self.href = href
        self.id = id
        self.images = images
        self.name = name
        self.popularity = popularity
        self.type = type
        self.uri = uri
    }
}
