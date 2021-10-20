// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getPlaylistsTracks = try? newJSONDecoder().decode(GetPlaylistsTracks.self, from: jsonData)
//
// To read values from URLs:
//
//   let task = URLSession.shared.getPlaylistsTracksTask(with: url) { getPlaylistsTracks, response, error in
//     if let getPlaylistsTracks = getPlaylistsTracks {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - GetPlaylistsTracks
public struct GetPlaylistsTracks: Codable {
    public let href: String
    public let items: [PurpleItem]
    public let limit: Int
    public let next: JSONNull?
    public let offset: Int
    public let previous: JSONNull?
    public let total: Int

    enum CodingKeys: String, CodingKey {
        case href = "href"
        case items = "items"
        case limit = "limit"
        case next = "next"
        case offset = "offset"
        case previous = "previous"
        case total = "total"
    }

    public init(href: String, items: [PurpleItem], limit: Int, next: JSONNull?, offset: Int, previous: JSONNull?, total: Int) {
        self.href = href
        self.items = items
        self.limit = limit
        self.next = next
        self.offset = offset
        self.previous = previous
        self.total = total
    }
}
