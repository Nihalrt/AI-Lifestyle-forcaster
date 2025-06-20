import SwiftUI

struct ContentView: View {
    // We get access to the shared ThemeManager from the environment.
    @EnvironmentObject var themeManager: ThemeManager
    
    // We still need local state for the data this view displays
    @State private var greeting: String = ""
    @State private var iconName: String = ""
    @State private var temperature: String = "--"
    @State private var locationName: String = "Loading..."
    
    var body: some View {
        ZStack {
            // REMOVED: The old LinearGradient background.
            // ADDED: The new, reusable ThemedBackgroundView.
            ThemedBackgroundView(theme: themeManager.currentTheme)

            VStack(alignment: .leading) {
                // The rest of your UI for this screen stays exactly the same!
                Spacer()
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                    Text(locationName)
                }
                .foregroundColor(.white.opacity(0.8))
                .font(.headline)
                .fontWeight(.medium)
                Text(greeting)
                    .font(.system(size: 34, weight: .medium, design: .serif))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 5, y: 3)
                    .padding(.top, 8)
                Spacer()
                Spacer()
                HStack(alignment: .firstTextBaseline) {
                    Text(temperature)
                        .font(.system(size: 96, weight: .bold))
                    Image(systemName: iconName)
                        .renderingMode(.original)
                        .font(.system(size: 60))
                        .offset(x: -5, y: -10)
                }
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 5, y: 3)
            }
            .padding(.horizontal, 30)
        }
        .task {
            await fetchWeatherData()
        }
    }
    
    private func fetchWeatherData() async {
        do {
            let weatherResponse = try await NetworkManager.shared.fetchWeather(for: "Victoria,CA", apiKey: KeyManager.getAPIKey(for: "OPENWEATHER_API_KEY"))
            let aiDescription = try await AIManager.shared.generateDescription(from: weatherResponse)
            
            // This is the only line we need to add to this function.
            // After fetching the data, we tell the themeManager to update.
            themeManager.updateTheme(from: weatherResponse)
            
            await MainActor.run {
                withAnimation {
                    self.temperature = String(format: "%.0f°", weatherResponse.main.temp)
                    self.greeting = aiDescription
                    self.locationName = weatherResponse.name
                    // We get the icon name from the weather data now, not from time of day.
                    if let iconCode = weatherResponse.weather.first?.icon {
                        self.iconName = self.systemIconName(for: iconCode)
                    }
                }
            }
        } catch {
            print("Failed during data fetch or AI generation: \(error)")
        }
    }
    private func systemIconName(for apiIconCode: String) -> String {
            switch apiIconCode {
            case "01d":
                return "sun.max.fill"
            case "01n":
                return "moon.stars.fill"
            case "02d":
                return "cloud.sun.fill"
            case "02n":
                return "cloud.moon.fill"
            case "03d", "03n":
                return "cloud.fill"
            case "04d", "04n":
                return "cloud.fill" // Using the same for broken clouds
            case "09d", "09n":
                return "cloud.drizzle.fill"
            case "10d", "10n":
                return "cloud.rain.fill"
            case "11d", "11n":
                return "cloud.bolt.rain.fill"
            case "13d", "13n":
                return "cloud.snow.fill"
            case "50d", "50n":
                return "cloud.fog.fill"
            default:
                return "questionmark.circle" // A fallback icon
            }
        }
}

#Preview
{
    ContentView();
}
