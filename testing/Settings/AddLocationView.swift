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
                    // We now display the search results in our list
                    List(searchResults) { location in
                        Button(action: {
                            // When a result is tapped, add it to the view model
                            // and dismiss the screen.
                            let newLocation = SavedLocation(city: location.name, country: location.country)
                            locationsViewModel.add(location: newLocation)
                            dismiss()
                        }) {
                            VStack(alignment: .leading) {
                                Text(location.name)
                                    .font(.headline)
                                
                                // Display the state/province if it exists
                                if let state = location.state {
                                    Text("\(state), \(location.country)")
                                        .font(.subheadline)
                                } else {
                                    Text(location.country)
                                        .font(.subheadline)
                                }
                            }
                            .foregroundColor(.white)
                        }
                        .listRowBackground(Color.white.opacity(0.1))
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
