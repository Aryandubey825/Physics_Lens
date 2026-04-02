import SwiftUI

struct GuideCardView: View {
    let guide: Guide
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: guide.icon)
                .font(.largeTitle)
            
            Text(guide.title)
                .font(.headline)
            
            Text(guide.subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(width: 220)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
