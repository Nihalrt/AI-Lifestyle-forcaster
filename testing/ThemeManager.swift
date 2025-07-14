import SwiftUI

// The @MainActor attribute ensures that any updates to our published
// properties happen on the main thread, which is required for UI.
@MainActor
class ThemeManager: ObservableObject {
    
    // The @Published property wrapper is the magic. It's a broadcast signal.
    // Whenever this 'currentTheme' value changes, any view watching this object
    // will be automatically told to redraw itself.
    @Published var currentTheme: AppTheme = .generic
    
    // This function contains the logic to decide the theme based on weather data.
    func updateTheme(from weatherData: WeatherResponse) {
        // We use the weather 'icon' code from the API to determine the condition.
        guard let iconCode = weatherData.weather.first?.icon else {
            self.currentTheme = .generic
            return
        }
        
        print("data icon code: \(iconCode)")
        
        switch iconCode {
        case "01d":
            self.currentTheme = .clearDay
        case "01n":
            self.currentTheme = .clearNight
        case "02d", "03d", "04d": //
            self.currentTheme = .cloudy
        case "09n", "10n", "11n":
            self.currentTheme = .rain
        default:
            self.currentTheme = .generic
        }
        
        print(" Theme updated to: \(self.currentTheme)")
    }
}
