//
//  RecommendationsResponse.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 19.10.2021.
//

import Foundation

struct RecommendationsResponse: Codable {
    let tracks: [Track]
    let seeds: [Seed?]?
}
