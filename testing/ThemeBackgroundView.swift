import SwiftUI

// An enum to define all our possible app themes
enum AppTheme {
    case clearDay
    case clearNight
    case cloudy
    case rain
    case generic
}

struct ThemedBackgroundView: View {
    // This view will take a theme as input
    var theme: AppTheme

    var body: some View {
        ZStack {
            // A switch statement to return the correct background for the given theme
            switch theme {
            case .clearDay:
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color("LightBlue")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            case .clearNight:
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.2), .black]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            case .cloudy:
                CloudAnimationView() // Using the view we already created
            case .rain:
                RainAnimationView() // Using the view we already created
            case .generic:
                LinearGradient(
                    gradient: Gradient(colors: [Color.gray, .black]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
        .ignoresSafeArea()
        // Add a subtle animation when the theme changes
        .animation(.easeOut(duration: 1.0), value: theme)
    }
}

// Add Equatable conformance to AppTheme for the animation to work
extension AppTheme: Equatable
{
    
}

#Preview {
    // A preview to see one of our themes
    ThemedBackgroundView(theme: .cloudy)
}
