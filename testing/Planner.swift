import SwiftUI

// Using the data model you defined
struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUserMessage: Bool
}

// Renamed struct to PlannerView to match its usage
struct Planner: View {
    // We get access to the SAME shared ThemeManager.
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var isAwaitingResponse: Bool = false
    // Removed unused errorMessage state for now to keep it clean
    
    @State private var userQuery: String = ""
    @State private var conversation: [ChatMessage] = []
    
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
                }
                .scrollDismissesKeyboard(.interactively)
                
                // NOTE: The duplicate ScrollView and extra padding.bottom have been removed here.
                
                Spacer()
                
                HStack(spacing: 15) {
                    TextField("Ask me anything...", text: $userQuery, axis: .vertical)
                        .foregroundColor(.white)
                        .padding(.leading)
                    
                    // FIXED: Button now calls the sendMessage function
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
        
        print("---")
        print("1. sendMessage: Kicking off AI Task.")
        
        Task {
            print("2. Task: Started background task.")
            do {
                print("3. Task: About to call AIManager...")
                
                let aiResponseText = try await AIManager.shared.getAIResponse(for: conversation)
                
                print("4. Task: Successfully received response from AI!")
                
                let aiMessage = ChatMessage(text: aiResponseText, isUserMessage: false)
                
                await MainActor.run {
                    print("5. Task: Updating UI on main thread.")
                    withAnimation {
                        isAwaitingResponse = false
                        conversation.append(aiMessage)
                    }
                }
            } catch {
                await MainActor.run {
                    withAnimation {
                        isAwaitingResponse = false
                        let errorMessage = ChatMessage(text: "Sorry, I ran into an error. Please try again.", isUserMessage: false)
                        conversation.append(errorMessage)
                    }
                }
            }
        }
    }
}

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
        // FIXED: Preview now correctly calls PlannerView
        Planner()
            .environmentObject(ThemeManager())
    }
}
