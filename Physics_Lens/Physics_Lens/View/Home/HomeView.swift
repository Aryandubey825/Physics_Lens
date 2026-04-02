import SwiftUI

struct HomeView: View {
    
    let todayTip = TodayTip(
        title: "Today’s Physics Tip",
        description: "For maximum range in projectile motion, angle should be 45°.",
        icon: "sparkles"
    )
    
    let topics: [Topic] = [
        Topic(
            title: "Projectile Motion",
            image: "projectile",
            points: ["Angle", "Range", "Time"]
        ),
        Topic(
            title: "Pendulum",
            image: "pendulum",
            points: ["Length", "Gravity", "Period"]
        ),
        Topic(
            title: "Free Fall",
            image: "freefall",
            points: ["Velocity", "Height", "Time"]
        ),
        
        Topic(
            title: "Second Law",
            image: "secondlaw",
            points: ["Force", "Mass", "Acceleration"]
        ),
        Topic(
            title: "Friction",
            image: "friction",
            points: ["Force", "Mass", "Acceleration"]
        )
    ]
   
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    
                 
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Hi, Gopalji 👋")
                                .font(.largeTitle.bold())
                            Text("Discover the beauty of physics through immersive and interactive simulations.")
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                       
                    }
                    .padding(.top)
                    
                   
                    Text("Today’s Tip")
                        .font(.title2.bold())
                    
                    TodayTipView(tip: todayTip)
                    
                   
                  
                        Text("Topics")
                            .font(.title2.bold())

                    VStack(spacing: 22) {
                        ForEach(topics) { topic in
                            NavigationLink {
                                TopicDetailView(topic: topic)
                            } label: {
                                TopicHeroCardView(topic: topic)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
        }
    }
}
