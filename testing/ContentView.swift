import SwiftUI

struct ContentView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var locationsViewModel: LocationsViewModel // Now accesses locations
    
    @State private var greeting: String = "Welcome!"
    
    var body: some View {
        ZStack {
            ThemedBackgroundView(theme: themeManager.currentTheme)

            if let weather = weatherViewModel.weatherResponse {
                // UI remains the same...
                VStack(alignment: .leading) {
                    Spacer()
                    HStack { Image(systemName: "mappin.and.ellipse"); Text(weather.name) }
                        .foregroundColor(.white.opacity(0.8)).font(.headline)
                    Text(greeting)
                        .font(.system(size: 34, weight: .medium, design: .serif)).foregroundColor(.white).shadow(color: .black.opacity(0.3), radius: 5, y: 3).padding(.top, 8)
                    Spacer(); Spacer()
                    HStack(alignment: .firstTextBaseline) {
                        Text(String(format: "%.0f°", weather.main.temp)).font(.system(size: 96, weight: .bold))
                        Image(systemName: systemIconName(for: weather.weather.first?.icon ?? "")).renderingMode(.original).font(.system(size: 60)).offset(x: -5, y: -10)
                    }.foregroundColor(.white).shadow(color: .black.opacity(0.3), radius: 5, y: 3)
                }.padding(.horizontal, 30)
            } else {
                ProgressView().tint(.white).scaleEffect(2)
            }
        }
        .task(id: locationsViewModel.primaryLocation) {
            await weatherViewModel.fetchAllData(for: locationsViewModel.primaryLocation, themeManager: themeManager)
            await generateGreeting()
        }
    }
    
    func generateGreeting() async {
        guard let weather = weatherViewModel.weatherResponse else { return }
        do {
            self.greeting = try await AIManager.shared.generateDescription(from: weather)
        } catch { self.greeting = "Hello! A beautiful day awaits." }
    }
    
    private func systemIconName(for apiIconCode: String) -> String {
        // ... (this function remains the same)
        switch apiIconCode {
            case "01d": return "sun.max.fill"; case "01n": return "moon.stars.fill"; case "02d": return "cloud.sun.fill"; case "02n": return "cloud.moon.fill"; case "03d", "03n", "04d", "04n": return "cloud.fill"; case "09d", "09n": return "cloud.drizzle.fill"; case "10d", "10n": return "cloud.rain.fill"; case "11d", "11n": return "cloud.bolt.rain.fill"; case "13d", "13n": return "cloud.snow.fill"; case "50d", "50n": return "cloud.fog.fill"; default: return "questionmark.circle"
        }
    }
}
