import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
    case noData
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    // Function for Current Weather
    func fetchWeather(for city: String, apiKey: String) async throws -> WeatherResponse {
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")
        components?.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        guard let url = components?.url else { throw NetworkError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.requestFailed
        }
        
        do {
            // We no longer need the keyDecodingStrategy here, as our model handles it.
            return try JSONDecoder().decode(WeatherResponse.self, from: data)
        } catch {
            print("‼️ Current weather decoding failed: \(error)")
            throw NetworkError.decodingFailed
        }
    }

    // Function for OpenUV API
    func fetchUVIndex(lat: Double, lon: Double, apiKey: String) async throws -> OpenUVResponse {
        guard let url = URL(string: "https://api.openuv.io/api/v1/uv?lat=\(lat)&lng=\(lon)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "x-access-token")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.requestFailed
        }

        return try JSONDecoder().decode(OpenUVResponse.self, from: data)
    }

    // Function for WAQI API
    func fetchAQI(for city: String, apiKey: String) async throws -> AQIResponse {
        let formattedCity = city.split(separator: ",").first?.lowercased().replacingOccurrences(of: " ", with: "-") ?? ""
        guard let url = URL(string: "https://api.waqi.info/feed/\(formattedCity)/?token=\(apiKey)") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.requestFailed
        }

        return try JSONDecoder().decode(AQIResponse.self, from: data)
    }
}
