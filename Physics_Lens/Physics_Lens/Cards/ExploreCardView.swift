import SwiftUI

struct ExploreCard: View {
    var title: String
    var subtitle: String
    var color: Color
    
    var body: some View {
        
        ZStack(alignment: .bottomLeading) {
            
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            color.opacity(0.95),
                            color.opacity(0.75)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Circle()
                .fill(.white.opacity(0.04))
                .frame(width: 220)
                .offset(x: 160, y: -90)
            
            VStack(alignment: .leading, spacing: 8) {
                
                HStack {
                    Image(systemName: "sparkles")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.85))
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.75))
                }
                
                Spacer()
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(18)
        }
        .frame(height: 160)  
        .shadow(color: .black.opacity(0.10), radius: 14, x: 0, y: 10)
    }
}
