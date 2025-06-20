import SwiftUI

struct RainAnimationView: View{
    var body: some View{
        ZStack
        {
            LinearGradient(gradient: Gradient(colors: [Color.indigo.opacity(0.7), .black]), startPoint: .top, endPoint: .bottom)
                            .ignoresSafeArea()
                        
             Text("🌧️")
                .font(.system(size: 100))
                .opacity(0.2)
            
        }
        
        
    }
}

#Preview {
    RainAnimationView()
}
