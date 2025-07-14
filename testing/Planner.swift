import SwiftUI

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUserMessage: Bool
}

struct Planner: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var weatherViewModel: WeatherViewModel

    @State private var userQuery: String = ""
    @State private var conversation: [ChatMessage] = []
    @State private var isAwaitingResponse: Bool = false
    
    let suggestions = [
        "What's the best day for a hike?",
        "Should I wear a jacket tomorrow?",
        "Will it rain this weekend?",
    ]

    var body: some View {
        ZStack {
            ThemedBackgroundView(theme: themeManager.currentTheme)
            VStack(spacing: 0) {
                Text("Activity Planner").font(.largeTitle.weight(.bold)).foregroundColor(.white).padding()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(suggestions, id: \.self) { suggestion in
                            Button(action: { userQuery = suggestion }) {
                                Text(suggestion).padding(.horizontal, 15).padding(.vertical, 8).background(Color.white.opacity(0.15)).foregroundColor(.white).clipShape(Capsule())
                            }
                        }
                    }.padding(.horizontal)
                }.padding(.bottom)
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(conversation) { message in
                            ChatBubble(message: message)
                        }
                        if isAwaitingResponse {
                            ChatBubble(message: ChatMessage(text: "...", isUserMessage: false))
                        }
                    }.padding(.top, 1)
                }
                .scrollDismissesKeyboard(.interactively)
                Spacer()
                HStack(spacing: 12) {
                    TextField("Ask me anything...", text: $userQuery, axis: .vertical)
                        .foregroundColor(.white).padding(.horizontal)
                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill").font(.largeTitle).tint(.white)
                    }
                    .disabled(userQuery.isEmpty).opacity(userQuery.isEmpty ? 0.5 : 1.0)
                }
                .padding(8).padding(.leading, 8).background(.ultraThinMaterial).clipShape(Capsule()).padding()
            }
        }
    }

    func sendMessage() {
        let userMessage = ChatMessage(text: userQuery, isUserMessage: true)
        withAnimation(.spring()) {
            conversation.append(userMessage)
        }
        
        let queryForAI = userQuery
        
        userQuery = ""
        isAwaitingResponse = true
        
        Task {
            do {
                let aiResponseText = try await AIManager.shared.getAIResponse(for: conversation, with: weatherViewModel.weatherResponse)
                let aiMessage = ChatMessage(text: aiResponseText, isUserMessage: false)
                
                await MainActor.run {
                    withAnimation(.spring()) {
                        isAwaitingResponse = false
                        conversation.append(aiMessage)
                    }
                }
            } catch {
                await MainActor.run {
                    withAnimation(.spring()) {
                        isAwaitingResponse = false
                        let errorMessage = ChatMessage(text: "Sorry, I ran into an error. Please try again.", isUserMessage: false)
                        conversation.append(errorMessage)
                    }
                }
                print("‼️ Error calling AI in PlannerView: \(error)")
            }
        }
    }
}

// --- THIS IS THE MISSING PIECE THAT IS NOW ADDED BACK ---
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


#Preview {
    ZStack {
        ThemedBackgroundView(theme: .cloudy)
        Planner()
            .environmentObject(ThemeManager())
            .environmentObject(WeatherViewModel())
    }
}
