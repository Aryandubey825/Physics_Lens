import SwiftUI

struct TopicDetailView: View {
    let topic: Topic
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                
                Text(topic.title)
                    .font(.largeTitle.bold())
                
               
                if topic.title == "Projectile Motion" {
                    ProjectileGraphView()
                    
                    ProjectileDetailContent() 
                    
                    
                }
                
                if topic.title == "Pendulum" {
                    PendulumGraphWithValues()
                    PendulumDetailContent()
                }
                if topic.title == "Free Fall" {
                    FreeFallVelocityTimeGraph()
                    FreeFallDetailContent()
                }
                 if topic.title == "Second Law" {
                     NewtonSecondLawVisual()
                    NewtonSecondLawDetailContent()
                }
                if topic.title == "Friction" {
                    Frictiongraph()
                    FrictionDetailContent()
                }
                
            
            
            }
            .padding()
        }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

func sectionTitle(_ text: String) -> some View {
    Text(text)
        .font(.title2.bold())
}

func bullet(_ text: String) -> some View {
    HStack(alignment: .top) {
        Text("•")
        Text(text)
    }
}

