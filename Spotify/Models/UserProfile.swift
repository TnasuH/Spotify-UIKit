//
//  UserProfile.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 18.10.2021.
//

import Foundation


// MARK: - UserProfile
struct UserProfile: Codable {
    let country, displayName, email: String
    let externalUrls: UserProfileExternalUrls
    let followers: UserProfileFollowers
    let href: String
    let id: String
    let images: [UserProfileImage]
    let product, type, uri: String

    enum CodingKeys: String, CodingKey {
        case country
        case displayName = "display_name"
        case email
        case externalUrls = "external_urls"
        case followers, href, id, images, product, type, uri
    }
}

// MARK: - ExternalUrls
struct UserProfileExternalUrls: Codable {
    let spotify: String
}

// MARK: - Followers
struct UserProfileFollowers: Codable {
    let href: JSONNull?
    let total: Int
}

// MARK: - Image
struct UserProfileImage: Codable {
    let height: JSONNull?
    let url: String
    let width: JSONNull?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
