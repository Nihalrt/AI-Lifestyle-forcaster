// In UVData.swift

import Foundation

struct OpenUVResponse: Codable {
    let result: UVResult
}

struct UVResult: Codable {
    let uv: Double
    let uvMax: Double
    let uvMaxTime: String

    enum CodingKeys: String, CodingKey {
        case uv
        case uvMax = "uv_max"
        case uvMaxTime = "uv_max_time"
    }
}
