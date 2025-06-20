import SwiftUI

struct CloudAnimationView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), .gray]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            // We can add real cloud animations here later
            Text("☁️") // Simple cloud emoji for now as a placeholder
                .font(.system(size: 100))
                .opacity(0.3)
        }
    }
}

#Preview {
    CloudAnimationView()
}
