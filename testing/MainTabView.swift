import SwiftUI

struct MainTabView: View {
    // We now get access to our shared ViewModels here
    @EnvironmentObject var locationsViewModel: LocationsViewModel
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        TabView {
            ContentView()
                .tabItem { Label("Now", systemImage: "clock.fill") }
            
            Planner()
                .tabItem { Label("Planner", systemImage: "list.star") }
            
            HealthView()
                .tabItem { Label("Health", systemImage: "heart.fill") }
            
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
        .tint(.white)
        // --- ADD THIS MODIFIER ---
        // This watches for any change to the primary location
        .onChange(of: locationsViewModel.primaryLocation) { oldLocation, newLocation in
            Task {
                // When the primary location changes, clear the old data
                // and fetch new data for the new location.
                weatherViewModel.weatherResponse = nil
                weatherViewModel.uvResponse = nil
                weatherViewModel.aqiResponse = nil
                await weatherViewModel.fetchAllData(for: newLocation, themeManager: themeManager)
            }
        }
    }
}

// We need to add our new locationsViewModel to the preview
#Preview {
    MainTabView()
        .environmentObject(ThemeManager())
        .environmentObject(WeatherViewModel())
        .environmentObject(LocationsViewModel())
}

// Add Equatable conformance to SavedLocation so onChange can detect changes
extension SavedLocation: Equatable {
    static func == (lhs: SavedLocation, rhs: SavedLocation) -> Bool {
        lhs.id == rhs.id
    }
}
