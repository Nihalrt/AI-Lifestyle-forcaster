import SwiftUI
import Foundation

struct MiniHealthCardView: View {
    let iconName: String
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: iconName) // Icon for the metric
                Text(title) // Text label (e.g., "Feels Like")
            }
            .foregroundColor(.white.opacity(0.7)) // Make the header less prominent

            Text(value) // The main data point (e.g., "17°")
                .font(.title.weight(.bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading) // Ensures the card fills the grid column
        .padding()
        // It uses the same frosted glass styling as the large cards for consistency.
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}
