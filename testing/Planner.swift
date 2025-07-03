import SwiftUI

// Blueprint for a single message
struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUserMessage: Bool
}


struct Planner: View {
    // Get access to the shared managers
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var weatherViewModel: WeatherViewModel

    @State private var userQuery: String = ""
    @State private var conversation: [ChatMessage] = []
    @State private var isAwaitingResponse: Bool = false
    
    let suggestions = [
        "What's the best day for a hike?",
        "Should I wear a jacket tomorrow?",
        "Will it rain this weekend?",
        "Good time for outdoor yoga?",
    ]

    var body: some View {
        ZStack {
            ThemedBackgroundView(theme: themeManager.currentTheme)

            VStack {
                Text("Activity Planner")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(suggestions, id: \.self) { suggestion in
                            Button(action: { userQuery = suggestion }) {
                                Text(suggestion)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 8)
                                    .background(Color.white.opacity(0.15))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
                
                // The main conversation view
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(conversation) { message in
                            ChatBubble(message: message)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }

                        if isAwaitingResponse {
                            ChatBubble(message: ChatMessage(text: "...", isUserMessage: false))
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                    .padding(.top, 1)
                }
                .scrollDismissesKeyboard(.interactively)

                Spacer()

                HStack(spacing: 15) {
                    TextField("Ask me anything...", text: $userQuery, axis: .vertical)
                        .foregroundColor(.white)
                        .padding(.leading)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.largeTitle)
                            .tint(.white)
                    }
                    .disabled(userQuery.isEmpty)
                    .opacity(userQuery.isEmpty ? 0.5 : 1.0)
                    .padding(.trailing)
                }
                .padding(.vertical, 10)
                .background(.ultraThinMaterial)
                .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.white.opacity(0.2), lineWidth: 1))
                .cornerRadius(25)
                .padding(.horizontal)
                .padding(.bottom, 5)
            }
        }
    }

    func sendMessage() {
        let userMessage = ChatMessage(text: userQuery, isUserMessage: true)
        withAnimation {
            conversation.append(userMessage)
        }
        
        let queryForAI = userQuery
        userQuery = ""
        isAwaitingResponse = true
        
        Task {
            do {
                var prompt = "You are Nimbus, a friendly weather planning assistant. A user has asked: '\(queryForAI)'."
                
                if let weather = weatherViewModel.weatherResponse {
                    let weatherContext = """
                    
                    For context, here is the current weather in their location (\(weather.name)):
                    - Temperature: \(String(format: "%.0f", weather.main.temp))°C
                    - Condition: \(weather.weather.first?.description ?? "clear")
                    """
                    prompt += weatherContext
                }
                prompt += "\n\nBriefly answer their question in a conversational and helpful way."
                
                let aiResponseText = try await AIManager.shared.getAIResponse(for: conversation)
                let aiMessage = ChatMessage(text: aiResponseText, isUserMessage: false)
                
                await MainActor.run {
                    withAnimation {
                        isAwaitingResponse = false
                        conversation.append(aiMessage)
                    }
                }
            } catch {
                await MainActor.run {
                    withAnimation {
                        isAwaitingResponse = false
                        let errorMessage = ChatMessage(text: "Sorry, I had trouble connecting. Please try again.", isUserMessage: false)
                        conversation.append(errorMessage)
                    }
                }
                print("Error calling AI in PlannerView: \(error)")
            }
        }
    }
}

// --- THIS IS THE MISSING PIECE ---
// The "blueprint" for a single chat bubble view.
struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isUserMessage {
                Spacer(minLength: 50)
            }
            
            Text(message.text)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(message.isUserMessage ? .blue : .white.opacity(0.2))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
            if !message.isUserMessage {
                Spacer(minLength: 50)
            }
        }
        .padding(.horizontal)
    }
}


// --- THIS IS THE CORRECTED PREVIEW BLOCK ---
#Preview {
    ZStack {
        ThemedBackgroundView(theme: .cloudy)
        Planner()
            .environmentObject(ThemeManager())
            // The preview also needs access to the WeatherViewModel
            .environmentObject(WeatherViewModel())
    }
}
