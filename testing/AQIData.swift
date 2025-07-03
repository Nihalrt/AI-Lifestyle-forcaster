// In AQIData.swift

import Foundation

struct AQIResponse: Codable {
    let status: String
    let data: AQIData? // The data can sometimes be null
}

struct AQIData: Codable {
    let aqi: Int
    let city: AQICity
    
    struct AQICity: Codable {
        let name: String
    }
}
