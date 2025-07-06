import SwiftUI

struct SettingsView: View
{
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var locationsViewModel: LocationsViewModel
    
    @State private var isAddingLocation = false
    
    var body: some View
    {
        NavigationStack
        {
            ZStack
            {
                ThemedBackgroundView(theme: themeManager.currentTheme)
                
                Form
                {
                    Section
                    {
                        ForEach(locationsViewModel.savedLocations){location in HStack
                            {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.accentColor)
                                Text(location.displayName)
                            }
                        }
                        .onDelete(perform: locationsViewModel.delete)
                        .onMove(perform: locationsViewModel.move)
                        .listRowBackground(Color.white.opacity(0.1))
                        
                    } header: {
                        Text("Saved Locations")
                        
                    } footer: {
                        Text("The location at the top of the list will be used as the default location")
                    }
                }
                .scrollContentBackground(.hidden)
                .background(.clear)
                .navigationTitle("Settings")
                
                .toolbar
                {
                    ToolbarItem(placement: .navigationBarTrailing)
                    {
                        Button(action: {
                            isAddingLocation = true
                        })
                        {
                            Image(systemName: "plus.circle.fill")
                        }
                        .tint(.white)
                    }
                    ToolbarItem(placement: .navigationBarTrailing)
                    {
                        EditButton()
                            .tint(.white)
                    }
                }
                .sheet(isPresented: $isAddingLocation)
                {
                    AddLocationView()
                }
            }
        }
    }
}

#Preview {
    // This preview block allows us to design the view in isolation.
    // We create dummy managers to provide the necessary data.
    ZStack {
        ThemedBackgroundView(theme: .cloudy)
        SettingsView()
            .environmentObject(ThemeManager())
            .environmentObject(LocationsViewModel())
    }
}

