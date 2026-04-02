import SwiftUI

struct PremiumGameCard: View {
    
    var title: String
    var subtitle: String
    var imageName: String
    
    var body: some View {
        
        ZStack(alignment: .bottomLeading) {
            
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .clipped()
            
            LinearGradient(
                colors: [.clear, .black.opacity(0.85)],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding()
        }
        .aspectRatio(1.6, contentMode: .fit) 
        .cornerRadius(18)
        .shadow(radius: 6)
    }
}
