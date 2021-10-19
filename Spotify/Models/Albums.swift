// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let albums = try? newJSONDecoder().decode(Albums.self, from: jsonData)

import Foundation

// MARK: - Albums
public struct Albums: Codable {
    public let href: String
    public let items: [AlbumElement]
    public let limit: Int
    public let next: String
    public let offset: Int
    public let previous: JSONNull?
    public let total: Int

    enum CodingKeys: String, CodingKey {
        case href
        case items
        case limit
        case next
        case offset
        case previous
        case total
    }

    public init(href: String, items: [AlbumElement], limit: Int, next: String, offset: Int, previous: JSONNull?, total: Int) {
        self.href = href
        self.items = items
        self.limit = limit
        self.next = next
        self.offset = offset
        self.previous = previous
        self.total = total
    }
}