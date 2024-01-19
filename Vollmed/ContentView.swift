import SwiftUI

struct ContentView: View {
    
    func buildTabItemLabel(text: String, iconImage: Image) -> Label<Text, Image> {
        return Label(
            title: { Text(text) },
            icon: { iconImage }
        )
    }
    
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                buildTabItemLabel(
                    text: "Home",
                    iconImage: Image(systemName: "house")
                )
            }
            
            NavigationStack {
                MyAppointmentsView()
            }
            .tabItem {
                buildTabItemLabel(
                    text: "Minhas consultas",
                    iconImage: Image(systemName: "calendar")
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
