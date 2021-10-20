// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getCurrentProfile = try? newJSONDecoder().decode(GetCurrentProfile.self, from: jsonData)

import Foundation

// MARK: - GetCurrentProfile
public struct GetCurrentProfile: Codable {
    public let country: String
    public let displayName: String
    public let email: String
    public let explicitContent: ExplicitContent
    public let externalUrls: ExternalUrls
    public let followers: Followers
    public let href: String
    public let id: String
    public let images: [Image]
    public let product: String
    public let type: ArtistType
    public let uri: String

    enum CodingKeys: String, CodingKey {
        case country
        case displayName
        case email
        case explicitContent
        case externalUrls
        case followers
        case href
        case id
        case images
        case product
        case type
        case uri
    }

    public init(country: String, displayName: String, email: String, explicitContent: ExplicitContent, externalUrls: ExternalUrls, followers: Followers, href: String, id: String, images: [Image], product: String, type: ArtistType, uri: String) {
        self.country = country
        self.displayName = displayName
        self.email = email
        self.explicitContent = explicitContent
        self.externalUrls = externalUrls
        self.followers = followers
        self.href = href
        self.id = id
        self.images = images
        self.product = product
        self.type = type
        self.uri = uri
    }
}
