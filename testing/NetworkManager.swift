import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
}

class NetworkManager{
    
    static let shared  =  NetworkManager()
    private init(){}
    
    func fetchWeather(for city: String, apiKey: String) async throws -> WeatherResponse {
        
        let endpoint = "https://api.openweathermap.org/data/2.5/weather"
        guard var urlComponents = URLComponents(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        print("NetworkManager: Attempting to fetch URL: \(url.absoluteString)")

        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.requestFailed    
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(WeatherResponse.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
        
    }
        
    
    
}
