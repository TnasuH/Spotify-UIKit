// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let recommendations = try? newJSONDecoder().decode(Recommendations.self, from: jsonData)

import Foundation

// MARK: - Recommendations
public struct Recommendations: Codable {
    public let tracks: [Track]
    public let seeds: [Seed]

    enum CodingKeys: String, CodingKey {
        case tracks
        case seeds
    }

    public init(tracks: [Track], seeds: [Seed]) {
        self.tracks = tracks
        self.seeds = seeds
    }
}
