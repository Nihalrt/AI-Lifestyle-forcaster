import Foundation

// MARK: - Gemini API Data Structures
struct GeminiRequest: Codable {
    let contents: [Content]
    let systemInstruction: Content?
}
struct Content: Codable {
    let parts: [Part]
    var role: String? = nil
}
struct Part: Codable { let text: String }
struct GeminiResponse: Codable {
    let candidates: [Candidate]
    var generatedText: String? { return candidates.first?.content.parts.first?.text }
}
struct Candidate: Codable { let content: Content }


// MARK: - AI Manager Class
class AIManager {
    
    static let shared = AIManager()
    private let apiKey = KeyManager.getAPIKey(for: "GEMINI_API_KEY")
    private let urlSession = URLSession.shared
    
    private var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "generativelanguage.googleapis.com"
        components.path = "/v1beta/models/gemini-1.5-flash-latest:generateContent"
        components.queryItems = [URLQueryItem(name: "key", value: apiKey)]
        return components.url
    }
    
    // --- THIS IS THE CORRECT, UNIFIED FUNCTION ---
    // It now correctly accepts both a conversation AND optional weather context.
    func getAIResponse(for conversation: [ChatMessage], with context: WeatherResponse?) async throws -> String {
        guard let url = url else { throw NetworkError.invalidURL }
        
        var systemPrompt = """
        You are Nimbus, a friendly, encouraging, and slightly witty AI weather assistant.
        Your purpose is to help users plan their activities and understand how the weather affects their well-being.
        Rules:
        - Keep your answers concise and conversational.
        - If asked a generic question (like 'Hello'), respond kindly.
        - If asked about something unrelated to weather, activities, or planning, gently and creatively steer the conversation back to one of those topics.
        """
        
        // We now add the weather context to the system prompt if it was provided.
        if let weather = context {
            let weatherContext = """
            \n\nCURRENT WEATHER CONTEXT for user's location (\(weather.name)):
            - Temperature: \(String(format: "%.0f", weather.main.temp))°C
            - Condition: \(weather.weather.first?.description ?? "clear")
            """
            systemPrompt += weatherContext
        }

        let systemInstruction = Content(parts: [Part(text: systemPrompt)])
        
        let contents = conversation.map { message -> Content in
            let role = message.isUserMessage ? "user" : "model"
            return Content(parts: [Part(text: message.text)], role: role)
        }
        
        let requestBody = GeminiRequest(contents: contents, systemInstruction: systemInstruction)
        
        return try await performAIGeneration(with: requestBody, url: url)
    }
    
    // This is a private helper function to avoid repeating network code.
    private func performAIGeneration(with requestBody: GeminiRequest, url: URL) async throws -> String {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(requestBody)

        let (data, _) = try await urlSession.data(for: request)
        let response = try JSONDecoder().decode(GeminiResponse.self, from: data)
        
        guard let generatedText = response.generatedText else { throw NetworkError.decodingFailed }
        return generatedText
    }
    
    // This function is still used by ContentView. We'll update it to call our main function.
    func generateDescription(from weatherData: WeatherResponse) async throws -> String {
        let prompt = "Write a short, creative, one-sentence summary (less than 15 words) about what the day feels like and suggest one simple, related activity."
        
        // We create a temporary conversation and pass BOTH the prompt and the context.
        let tempConversation = [ChatMessage(text: prompt, isUserMessage: true)]
        return try await getAIResponse(for: tempConversation, with: weatherData)
    }
}
