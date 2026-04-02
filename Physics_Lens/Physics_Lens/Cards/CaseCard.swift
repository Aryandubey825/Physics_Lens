import SwiftUI

struct CaseCard: View {
    
    let icon: String
    let color: Color
    let title: String
    let description: String
    let example: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title3)
                
                Text(title)
                    .font(.headline)
            }
            
            Divider()
            
            Text(description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Label(example, systemImage: "lightbulb.fill")
                .font(.caption)
                .foregroundColor(color)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
