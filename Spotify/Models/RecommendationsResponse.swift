//
//  RecommendationsResponse.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 18.10.2021.
//

import Foundation

// MARK: - RecommendationsResponse
struct RecommendationsResponse: Codable {
    let tracks: [Track]
    let seeds: [Seed]
}

// MARK: - Seed
struct Seed: Codable {
    let initialPoolSize, afterFilteringSize, afterRelinkingSize: Int
    let id, type: String
    let href: String?
}

// MARK: - Track
struct Track: Codable {
    let album: Album
    let artists: [Artist]
    let discNumber, durationMS: Int
    let explicit: Bool
    let externalIDS: ExternalIDS
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let isLocal: Bool
    let isPlayable: Bool?
    let name: String
    let popularity: Int
    let previewURL: String?
    let trackNumber: Int
    let type: TrackType
    let uri: String

    enum CodingKeys: String, CodingKey {
        case album, artists
        case discNumber = "disc_number"
        case durationMS = "duration_ms"
        case explicit
        case externalIDS = "external_ids"
        case externalUrls = "external_urls"
        case href, id
        case isLocal = "is_local"
        case isPlayable = "is_playable"
        case name, popularity
        case previewURL = "preview_url"
        case trackNumber = "track_number"
        case type, uri
    }
}

// MARK: - Album
struct Album: Codable {
    let albumType: AlbumType
    let artists: [Artist]
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let images: [ApiImage]
    let name, releaseDate: String
    let releaseDatePrecision: ReleaseDatePrecision
    let totalTracks: Int
    let type: AlbumTypeEnum
    let uri: String

    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case externalUrls = "external_urls"
        case href, id, images, name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case totalTracks = "total_tracks"
        case type, uri
    }
}

enum AlbumType: String, Codable {
    case album = "ALBUM"
    case compilation = "COMPILATION"
    case single = "SINGLE"
}

//// MARK: - Artist
//struct Artist: Codable {
//    let externalUrls: ExternalUrls
//    let href: String
//    let id, name: String
//    let type: ArtistType
//    let uri: String
//
//    enum CodingKeys: String, CodingKey {
//        case externalUrls = "external_urls"
//        case href, id, name, type, uri
//    }
//}
//
//// MARK: - ExternalUrls
//struct ExternalUrls: Codable {
//    let spotify: String
//}

enum ArtistType: String, Codable {
    case artist = "artist"
}

//// MARK: - Image
//struct Image: Codable {
//    let height: Int
//    let url: String
//    let width: Int
//}

enum ReleaseDatePrecision: String, Codable {
    case day = "day"
    case year = "year"
}

enum AlbumTypeEnum: String, Codable {
    case album = "album"
}

// MARK: - ExternalIDS
struct ExternalIDS: Codable {
    let isrc: String
}

enum TrackType: String, Codable {
    case track = "track"
}
