import Foundation

// MARK: - Gemini API Data Structures

struct GeminiRequest: Codable {
    let contents: [Content]
    
    let systemInstruction: Content?
    
    init(prompt: String){
        self.contents = [Content(parts: [Part(text: prompt)])]
        self.systemInstruction = nil
    }
    
    init (conversation: [ChatMessage]){
        let systemPrompt = """
        You are Nimbus, a friendly, encouraging, and slightly witty AI weather assistant.
        Your purpose is to help users plan their activities around the weather.
        
        Rules:
        - Keep your answers concise and conversational.
        - Always be positive and encouraging.
        - If the user asks about something unrelated to weather, activities, or planning, gently and creatively steer the conversation back to one of those topics.
        - Do not invent weather data. You will be provided with it when necessary.
        """
        self.systemInstruction = Content(parts: [Part(text: systemPrompt)])
        
        // Convert our ChatMessage array into the format Gemini needs
        self.contents = conversation.map { message in
            let role = message.isUserMessage ? "user" : "model"
            return Content(parts: [Part(text: message.text)], role: role)
        }
    }
}

struct Content: Codable {
    let parts: [Part]
    var role: String?
}

struct Part: Codable {
    let text: String
}

struct GeminiResponse: Codable {
    let candidates: [Candidate]
    
    var generatedText: String? {
        return candidates.first?.content.parts.first?.text
    }
}

struct Candidate: Codable {
    let content: Content
}


// MARK: - AI Manager Class

class AIManager {
    
    static let shared = AIManager()
    private let apiKey = KeyManager.getAPIKey(for: "GEMINI_API_KEY")
    private let urlSession = URLSession.shared
    
    private var url: URL?
    {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "generativelanguage.googleapis.com"
        components.path = "/v1beta/models/gemini-1.5-flash-latest:generateContent"
        components.queryItems = [URLQueryItem(name: "key", value: apiKey)]
        return components.url
    }
    
    func getAIResponse(for conversation: [ChatMessage]) async throws -> String {
        guard let url = url else {
            throw NetworkError.invalidURL
        }
        
        // Create the request body from the entire conversation
        let requestBody = GeminiRequest(conversation: conversation)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(requestBody)

        let (data, _) = try await urlSession.data(for: request)
        let response = try JSONDecoder().decode(GeminiResponse.self, from: data)
        
        guard let generatedText = response.generatedText else {
            throw NetworkError.decodingFailed
        }
        
        return generatedText
    }
    
    func generateDescription(from weatherData: WeatherResponse) async throws -> String
    {
        guard let url = url else {
            throw NetworkError.invalidURL
        }
        
        // 1. Create the prompt
        let prompt = """
        You are a friendly and encouraging lifestyle assistant. Based on this weather data:
        - Location: \(weatherData.name)
        - Temperature: \(String(format: "%.0f", weatherData.main.temp))°C
        - Condition: \(weatherData.weather.first?.description ?? "clear")
        
        Write a short, creative, one-sentence summary (less than 15 words) about what the day feels like and suggest one simple, related activity. Be cheerful and encouraging.
        """
        
        let requestBody = GeminiRequest(prompt: prompt)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(requestBody)

        if let bodyData = request.httpBody, let bodyString = String(data: bodyData, encoding: .utf8) {
            print("▶️ AIManager: Sending this JSON Body:\n\(bodyString)")
        }
        
        let (data, _) = try await urlSession.data(for: request)
        
        let response = try JSONDecoder().decode(GeminiResponse.self, from: data)
        
        guard let generatedText = response.generatedText else {
            throw NetworkError.decodingFailed
        }
        
        return generatedText
    }
}
