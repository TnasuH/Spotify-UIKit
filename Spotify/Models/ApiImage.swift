//
//  ApiImage.swift
//  Spotify
//
//  Created by Tarık Nasuhoğlu on 18.10.2021.
//

import Foundation

// MARK: - ApiImage
struct ApiImage: Codable {
    let height: Int
    let url: String
    let width: Int
}
