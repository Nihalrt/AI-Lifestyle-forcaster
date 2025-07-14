import SwiftUI

struct HealthView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var locationsViewModel: LocationsViewModel // Now accesses locations
    
    @State private var uvInsight: String?
    @State private var aqiInsight: String?

    let columns: [GridItem] = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]

    var body: some View {
        ZStack {
            ThemedBackgroundView(theme: themeManager.currentTheme)
            ScrollView {
                VStack(spacing: 16) {
                    Text("Health Hub").font(.largeTitle.weight(.bold)).foregroundColor(.white).padding(.bottom)
                    
                    if let uvi = weatherViewModel.currentUVI {
                        HealthCardView(iconName: "sun.max.fill", iconColor: .yellow, title: "UV Index", value: String(format: "%.0f", uvi), level: uviLevelText(for: uvi), insight: uvInsight ?? "Loading insight...")
                            .task { await generateUVInsight(uvi: uvi) }
                    }
                    
                    if let aqi = weatherViewModel.currentAQI {
                        HealthCardView(iconName: "wind", iconColor: .green, title: "Air Quality", value: "\(aqi.value)", level: aqi.text, insight: aqiInsight ?? "Loading insight...")
                            .task { await generateAQIInsight(aqi: aqi) }
                    }

                    if let weather = weatherViewModel.weatherResponse {
                        LazyVGrid(columns: columns, spacing: 16) {
                            MiniHealthCardView(iconName: "thermometer.medium", title: "Feels Like", value: "\(String(format: "%.0f", weather.main.feelsLike))°")
                            MiniHealthCardView(iconName: "humidity.fill", title: "Humidity", value: "\(weather.main.humidity)%")
                        }
                    } else if weatherViewModel.uvResponse == nil && weatherViewModel.aqiResponse == nil {
                        ProgressView().tint(.white).padding(.top, 50)
                    }
                }
                .padding()
            }
        }
        .task(id: locationsViewModel.primaryLocation) {
            // --- THIS IS THE CORRECTED CALL ---
            await weatherViewModel.fetchAllData(for: locationsViewModel.primaryLocation, themeManager: themeManager)
        }
    }
    // AI insight and helper functions remain the same...
    func generateUVInsight(uvi: Double) async {
        let prompt = "The current UV Index is \(String(format: "%.1f", uvi)), which is rated as '\(uviLevelText(for: uvi))'. Write a short, friendly, and actionable health tip based on this."
        do {
            let tempConversation = [ChatMessage(text: prompt, isUserMessage: true)]
            let insight = try await AIManager.shared.getAIResponse(for: tempConversation, with: weatherViewModel.weatherResponse)
            self.uvInsight = insight
        } catch {
            self.uvInsight = "Could not get AI insight."
        }
    }
    
    func generateAQIInsight(aqi: (value: Int, text: String)) async {
        let prompt = "The Air Quality Index (AQI) is \(aqi.value), rated as '\(aqi.text)'. Write a short, friendly, and actionable health tip based on this."
        do {
            let tempConversation = [ChatMessage(text: prompt, isUserMessage: true)]
            let insight = try await AIManager.shared.getAIResponse(for: tempConversation, with: weatherViewModel.weatherResponse)
            self.aqiInsight = insight
        } catch {
            self.aqiInsight = "Could not get AI insight."
        }
    }
    
    private func uviLevelText(for uvi: Double) -> String {
        switch uvi {
        case 0..<3: return "Low"
        case 3..<6: return "Moderate"
        case 6..<8: return "High"
        case 8..<11: return "Very High"
        default: return "Extreme"
        }
    }
}
