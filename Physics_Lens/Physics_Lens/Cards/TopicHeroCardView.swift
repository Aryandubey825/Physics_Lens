import SwiftUI

struct TopicHeroCardView: View {
    let topic: Topic
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            ZStack(alignment: .bottomLeading) {
                
                Image(topic.image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .background(Color.black.opacity(0.05))
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0.0),
                        Color.black.opacity(0.7)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(topic.title)
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    
                    HStack(spacing: 10) {
                        ForEach(topic.points, id: \.self) { point in
                            Text(point)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                }
                .padding()
            }
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.25), radius: 8, y: 4)
    }
}
