import SwiftUI

struct AddLocationView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var locationsViewModel: LocationsViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var searchText: String = ""
    
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
}

#Preview {
    AddLocationView()
        .environmentObject(ThemeManager())
        .environmentObject(LocationsViewModel())
}
