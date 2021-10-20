// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getAlbumsExternalids = try? newJSONDecoder().decode(GetAlbumsExternalids.self, from: jsonData)

import Foundation

// MARK: - GetAlbumsExternalids
public struct GetAlbumsExternalids: Codable {
    public let upc: String

    enum CodingKeys: String, CodingKey {
        case upc
    }

    public init(upc: String) {
        self.upc = upc
    }
}
