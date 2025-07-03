import SwiftUI
import Foundation

struct HealthCardView: View {
    // These properties allow us to create the card with different data each time.
    let iconName: String
    let iconColor: Color
    let title: String
    let value: String
    let level: String
    let insight: String

    var body: some View {
        // A vertical stack to arrange the content of the card.
        // `alignment: .leading` makes all text left-aligned.
        VStack(alignment: .leading, spacing: 12) {
            // Card Header (Icon and Title)
            HStack {
                Image(systemName: iconName) // Displays the icon (e.g., "sun.max.fill")
                Text(title) // Displays the title (e.g., "UV Index")
                Spacer() // Pushes the header content to the left
            }

            // Main Data Display (e.g., "8" and "Very High")
            HStack(alignment: .firstTextBaseline) {
                Text(value).font(.system(size: 60, weight: .bold)) // The big number
                Text(level).font(.title3.weight(.medium)) // The smaller text label
            }
            
            // The AI-generated insight text
            Text(insight)
        }
        .padding() // Adds space inside the card's border
        .background(.ultraThinMaterial) // Creates the "frosted glass" effect
        .cornerRadius(20) // Rounds the corners
        .overlay( // The .overlay modifier places a view on top of another
            // We place a rounded rectangle with only a border (.stroke)
            // to create the subtle outline effect.
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}
