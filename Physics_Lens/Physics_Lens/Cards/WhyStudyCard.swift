import SwiftUI

struct WhyStudyCard: View {
    
    let icon: String
    let iconColor: Color
    let title: String
    let desc: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(iconColor)
                .frame(width: 36)
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text(title)
                    .font(.headline)
                
                Text(desc)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

struct WhyStudyRow: View {
    
    var icon: String
    var iconColor: Color
    var title: String
    var desc: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            
            Image(systemName: icon)
                .foregroundColor(.white)
                .padding(10)
                .background(iconColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(desc)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
    }
}
