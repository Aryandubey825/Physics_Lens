import SwiftUI

@available(iOS 26.0, *)
struct MainTabView: View {
    
    var body: some View {
        TabView {
            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            GamesView()
                .tabItem {
                    Label("Games", systemImage: "gamecontroller.fill")
                }
            
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "globe")
                }
            
            
        }
    }
}

