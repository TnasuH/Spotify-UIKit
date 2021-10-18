//
//  FeaturedPlaylistResponse.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 18.10.2021.
//

import Foundation

// MARK: - FeaturedPlaylistsResponse
struct FeaturedPlaylistsResponse: Codable {
    let message: String
    let playlists: Playlists
}

// MARK: - Playlists
struct Playlists: Codable {
    let href: String
    let items: [PlayListItem]
    let limit: Int
    let next: String
    let offset: Int
    let previous: JSONNull?
    let total: Int
}

// MARK: - PlayListItem
struct PlayListItem: Codable {
    let collaborative: Bool
    let itemDescription: String
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let images: [ApiImage]
    let name: String
    let owner: Owner
    let itemPublic: JSONNull?
    let snapshotID: String
    let tracks: Tracks
    let type, uri: String

    enum CodingKeys: String, CodingKey {
        case collaborative
        case itemDescription = "description"
        case externalUrls = "external_urls"
        case href, id, images, name, owner
        case itemPublic = "public"
        case snapshotID = "snapshot_id"
        case tracks, type, uri
    }
}

// MARK: - Owner
struct Owner: Codable {
    let externalUrls: ExternalUrls
    let href: String
    let id, type, uri: String

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href, id, type, uri
    }
}

// MARK: - Tracks
struct Tracks: Codable {
    let href: String
    let total: Int
}
