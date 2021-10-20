// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let image = try? newJSONDecoder().decode(Image.self, from: jsonData)

import Foundation

// MARK: - Image
public struct Image: Codable {
    public let height: Int?
    public let url: String
    public let width: Int?

    enum CodingKeys: String, CodingKey {
        case height
        case url
        case width
    }

    public init(height: Int?, url: String, width: Int?) {
        self.height = height
        self.url = url
        self.width = width
    }
}
