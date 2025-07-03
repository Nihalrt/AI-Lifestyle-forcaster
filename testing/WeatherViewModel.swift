import Foundation
import SwiftUI

@MainActor
class WeatherViewModel: ObservableObject {
    
    @Published var weatherResponse: WeatherResponse?
    @Published var uvResponse: OpenUVResponse?
    @Published var aqiResponse: AQIResponse?
    
    var currentUVI: Double? {
        uvResponse?.result.uv
    }
    
    var currentAQI: (value: Int, text: String)? {
        guard let aqiValue = aqiResponse?.data?.aqi else { return nil }
        return (aqiValue, aqiDescription(for: aqiValue))
    }

    // The single, master function to fetch all app data
    func fetchAllData(themeManager: ThemeManager) async {
        // Only fetch if data doesn't already exist.
        guard weatherResponse == nil else { return }
        
        print("🚀 Kicking off all master data fetches...")
        
        let openWeatherKey = KeyManager.getAPIKey(for: "OPENWEATHER_API_KEY")
        let openUVKey = KeyManager.getAPIKey(for: "OPENUV_API_KEY")
        let waqiKey = KeyManager.getAPIKey(for: "WAQI_API_KEY")

        let lat = 48.4284 // Victoria, BC
        let lon = -123.3656
        let city = "Victoria,CA"

        // Use async let to run all network calls in parallel for speed
        async let weatherTask = NetworkManager.shared.fetchWeather(for: city, apiKey: openWeatherKey)
        async let uvTask = NetworkManager.shared.fetchUVIndex(lat: lat, lon: lon, apiKey: openUVKey)
        async let aqiTask = NetworkManager.shared.fetchAQI(for: city, apiKey: waqiKey)
        
        do {
            // Await all results together
            let (weatherData, uvData, aqiData) = try await (weatherTask, uvTask, aqiTask)
            
            // Update all our @Published properties, which will update the entire app UI
            self.weatherResponse = weatherData
            self.uvResponse = uvData
            self.aqiResponse = aqiData
            
            // Update the app's theme based on the primary weather data
            themeManager.updateTheme(from: weatherData)
            
        } catch {
            print("‼️ Failed during master data fetch in ViewModel: \(error)")
        }
    }
    
    private func aqiDescription(for aqi: Int) -> String {
        switch aqi {
        case 0...50: return "Good"
        case 51...100: return "Moderate"
        case 101...150: return "Unhealthy for SG"
        case 151...200: return "Unhealthy"
        case 201...300: return "Very Unhealthy"
        default: return "Hazardous"
        }
    }
}
