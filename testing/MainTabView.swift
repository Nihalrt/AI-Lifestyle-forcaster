import SwiftUI

struct MainTabView: View {
    var body: some View {
        
        TabView
        {
            ContentView().tabItem{
                Label("Now", systemImage: "clock.fill")
            }
            
            Planner().tabItem{
                Label("Planner", systemImage: "list.star")
                
            }
            
            Text("Health Screen - coming soon").tabItem{
                Label("Health", systemImage: "heart.fill")
            }
            
            
            Text("Settings Screen - Coming soon").tabItem{
                Label("Settings", systemImage: "gearshape.fill")
            }
            
        }.tint(.white)
        
        
        
        
        
        
    }
}

#Preview {
    ZStack{
        
        LinearGradient(
            gradient: Gradient(colors:[.gray, .black]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        
        MainTabView()
        
        
    }
    
    
    
}
