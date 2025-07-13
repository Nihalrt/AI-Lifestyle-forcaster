import Foundation
import SwiftUI

struct SavedLocation: Identifiable
{
    let id = UUID()
    let city : String
    let country : String
    
    var displayName: String
    {
        "\(city),\(country)"
    }
    
}


@MainActor
class LocationsViewModel: ObservableObject {
    @Published var savedLocations: [SavedLocation] = [
        SavedLocation(city: "Victoria", country: "CA")
        
    ]
    
    func delete (at offsets: IndexSet)
    {
        savedLocations.remove(atOffsets: offsets)
        print("Location deleted. Net list: \(savedLocations)")
        
    }
    
    func move(from source: IndexSet, to destination: Int)
    {
        savedLocations.move(fromOffsets: source, toOffset: destination)
        print("Location moved. Net list: \(savedLocations)")
    }
    
    func add(location: SavedLocation)
    {
        if !savedLocations.contains(where: { $0.displayName == location.displayName })
        {
            savedLocations.append(location)
            print("New location added. List: \(savedLocations)")
        }
        
    }
    
}
