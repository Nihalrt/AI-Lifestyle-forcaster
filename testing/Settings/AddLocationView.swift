import SwiftUI

struct AddLocationView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var locationsViewModel: LocationsViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var searchText: String = ""
    
    @State private var searchResults: [GeoResponse] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                ThemedBackgroundView(theme: themeManager.currentTheme)
                
                VStack {
                    List {
                        Text("Search results will appear here...")
                            .foregroundColor(.white)
                    }
                    .listStyle(.plain)
                    .background(.clear)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Add New Location")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search for a city")
            .onSubmit(of: .search, performSearch)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.white)
                }
            }
        }
    }
    
    func performSearch()
    {
        Task
        {
            do
            {
                let results = try await NetworkManager.shared.searchForCity(named: searchText, apiKey: KeyManager.getAPIKey(for: "OPENWEATHER_API_KEY"))
                self.searchResults = results
            } catch
            {
                print("City search failed: \(error.localizedDescription)")
            }
        }
    }
    
    
}

#Preview {
    AddLocationView()
        .environmentObject(ThemeManager())
        .environmentObject(LocationsViewModel())
}
