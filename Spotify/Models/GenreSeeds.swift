// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let genreSeeds = try? newJSONDecoder().decode(GenreSeeds.self, from: jsonData)

import Foundation

// MARK: - GenreSeeds
public struct GenreSeeds: Codable {
    public let genres: [String]

    enum CodingKeys: String, CodingKey {
        case genres
    }

    public init(genres: [String]) {
        self.genres = genres
    }
}
