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

    // This is the master function to fetch all data.
    // It now correctly takes the location as a parameter.
    func fetchAllData(for location: SavedLocation, themeManager: ThemeManager) async {
        // Clear old data to show loading spinners while new data is fetched.
        // We only clear if the location has actually changed.
        if self.weatherResponse?.name != location.city {
            self.weatherResponse = nil
            self.uvResponse = nil
            self.aqiResponse = nil
        } else {
            // If the location is the same, no need to re-fetch.
            return
        }
        
        print("🚀 Kicking off all master data fetches for \(location.displayName)...")
        
        let openWeatherKey = KeyManager.getAPIKey(for: "OPENWEATHER_API_KEY")
        let openUVKey = KeyManager.getAPIKey(for: "OPENUV_API_KEY")
        let waqiKey = KeyManager.getAPIKey(for: "WAQI_API_KEY")

        // We need to get the coordinates for the new city.
        guard let geoData = try? await NetworkManager.shared.searchForCity(named: location.displayName, apiKey: openWeatherKey).first else {
            print("‼️ Could not find coordinates for \(location.displayName)")
            return
        }

        // Use async let to run all network calls in parallel for speed
        async let weatherTask = NetworkManager.shared.fetchWeather(for: location.displayName, apiKey: openWeatherKey)
        async let uvTask = NetworkManager.shared.fetchUVIndex(lat: geoData.lat, lon: geoData.lon, apiKey: openUVKey)
        async let aqiTask = NetworkManager.shared.fetchAQI(for: location.displayName, apiKey: waqiKey)
        
        do {
            let (weatherData, uvData, aqiData) = try await (weatherTask, uvTask, aqiTask)
            
            // Update all our @Published properties, which will update the entire app UI
            self.weatherResponse = weatherData
            self.uvResponse = uvData
            self.aqiResponse = aqiData
            
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
