import Foundation

struct WeatherResponse: Codable {
    let main: MainWeather
    let weather: [WeatherDetail]
    let name: String
}

struct MainWeather: Codable {
    let temp: Double
}

struct WeatherDetail: Codable {
    let main: String
    let description: String
    let icon: String
}
