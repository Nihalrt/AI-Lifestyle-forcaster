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
            
            HealthView().tabItem{
                Label("Health", systemImage: "heart.fill")
            }
            
            
            SettingsView().tabItem{
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
