//
//  FeaturedPlayListResponse.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 19.10.2021.
//

import Foundation

struct FeaturedPlaylistResponse: Codable {
    let playlists: Playlists?
    let message: String?
}
