import Foundation

// --- CURRENT WEATHER MODELS ---

struct WeatherResponse: Codable {
    let main: MainWeather
    let weather: [WeatherDetail]
    let name: String
}

// THIS STRUCT IS NOW CORRECTED WITH CODINGKEYS
struct MainWeather: Codable {
    let temp: Double
    let feelsLike: Double
    let humidity: Int
    
    // This enum acts as a specific "translator" for the decoder.
    enum CodingKeys: String, CodingKey {
        case temp
        // It says: "When you see 'feels_like' in the JSON,
        // put its value into my 'feelsLike' property."
        case feelsLike = "feels_like"
        case humidity
    }
}

struct WeatherDetail: Codable {
    let main: String
    let description: String
    let icon: String
}


// --- FORECAST MODELS ---
struct ForecastResponse: Codable {
    let daily: [DailyForecast]
}
struct DailyForecast: Codable, Identifiable {
    let id = UUID()
    let dt: TimeInterval
    let summary: String
    let temp: DailyTemp
    let weather: [WeatherDetail]
    let uvi: Double
    private enum CodingKeys: String, CodingKey {
        case dt, summary, temp, weather, uvi
    }
}
struct DailyTemp: Codable {
    let day: Double
    let min: Double
    let max: Double
}


// --- AIR POLLUTION MODELS ---
struct AirPollutionResponse: Codable {
    let list: [AirPollutionData]
}
struct AirPollutionData: Codable {
    let main: AirQualityIndex
}
struct AirQualityIndex: Codable {
    let aqi: Int
}
