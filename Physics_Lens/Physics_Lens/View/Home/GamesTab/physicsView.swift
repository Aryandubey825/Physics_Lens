import SwiftUI

@available(iOS 26.0, *)
struct GamesView: View {
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
   
    @available(iOS 26.0, *)
    var body: some View {
        NavigationStack {
            
            ScrollView {
                
                LazyVGrid(columns: columns, spacing: 20) {
                    
                    NavigationLink {
                        projectileGame()
                    } label: {
                        PremiumGameCard(
                            title: "Projectile Motion",
                            subtitle: "Angle & Range Challenge",
                            imageName: "projectileGame"
                        )
                    }
                    .buttonStyle(.plain)
                    
                    
                    NavigationLink {
                        PendulumGame()
                    } label: {
                        PremiumGameCard(
                            title: "Pendulum Motion",
                            subtitle: "Oscillation Timing Game",
                            imageName: "pendulumGame"
                        )
                    }
                    .buttonStyle(.plain)
                    
                    
                    NavigationLink {
                        FreeFallGame()
                    } label: {
                        PremiumGameCard(
                            title: "Free Fall",
                            subtitle: "Gravity Speed Test",
                            imageName: "freefallGame"
                        )
                    }
                    .buttonStyle(.plain)
                    
                    
                    NavigationLink {
                        FrictionGame()
                    } label: {
                        PremiumGameCard(
                            title: "Friction",
                            subtitle: "Force vs Resistance",
                            imageName: "frictionGame"
                        )
                    }
                    .buttonStyle(.plain)
                    
                    
                    NavigationLink {
                        PhysicsRacePro()
                    } label: {
                        PremiumGameCard(
                            title: "Newton's Second Law",
                            subtitle: "Force & Acceleration Challenge",
                            imageName: "second'sLawGame"
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding()
            }
            .navigationTitle("Physics Games")
        }
    }
}
