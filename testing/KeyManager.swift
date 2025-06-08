import Foundation

struct KeyManager {
    
    // 1. Get the main dictionary from the Secrets.plist file
    private static var secrets: [String: Any]? {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path) else {
            fatalError("Secrets.plist not found. Please add it to the project.")
        }
        
        return try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil) as? [String: Any]
    }
    
    // 2. A function to retrieve a specific key
    static func getAPIKey(for key: String) -> String {
        guard let secrets = secrets, let value = secrets[key] as? String else {
            fatalError("Could not find key '\(key)' in Secrets.plist.")
        }
        return value
    }
}
