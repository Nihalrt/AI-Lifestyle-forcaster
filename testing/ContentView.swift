import SwiftUI

struct ContentView: View {
    @State private var greeting: String = ""
    @State private var iconName: String = ""
    @State private var backgroundColors: [Color] = [.gray, .black]
    @State private var temperature: String = "--"
    private let apiKey = KeyManager.getAPIKey(for: "OPENWEATHER_API_KEY")
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: backgroundColors), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: iconName)
                    .renderingMode(.original)
                    .font(.system(size:100))
                    .padding(.bottom, 10)
                
                Text(greeting)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .transition(.opacity)
                Text(temperature)
                    .font(.system(size: 70, weight: .bold))
                    .foregroundColor(.white)
            }.padding()
            
        }
        .task{
            toggleBackground()
            await fetchWeatherData()
        }
        
    
    }
    
    private func toggleBackground(){
        let hour = Calendar.current.component(.hour, from: Date())
        
        withAnimation{
            switch hour {
                case 5..<11:
                greeting = "Good Morning"
                iconName = "sun.max.fill"
                backgroundColors = [.blue, Color("LightBlue")]
                case 12..<17:
                greeting = "Good Afternoon"
                iconName = "sun.max.fill"
                backgroundColors = [.blue, .orange]
                case 18..<23:
                greeting = "Good Evening"
                iconName = "moon.stars.fill"
                backgroundColors = [.blue, .black]
            default:
                greeting = "Good Night"
                iconName = "moon.stars.fill"
                backgroundColors = [.gray, .black]
            }
        }
    }
    
    private func fetchWeatherData() async {
        do{
            let weatherResponse = try await NetworkManager.shared.fetchWeather(for: "Oak Bay", apiKey: apiKey)
            DispatchQueue.main.async{
                withAnimation {
                    self.temperature = String(format: "%.0f", weatherResponse.main.temp)
                }
            }
        } catch {
            print("Failed to fetch weather: \(error)")
        }
    }
}

#Preview{
    ContentView()
}





