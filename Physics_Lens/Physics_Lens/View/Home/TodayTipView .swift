import SwiftUI

struct TodayTipView: View {
    let tip: TodayTip
    
    var body: some View {
        HStack(spacing: 16) {
            
            Image(systemName: tip.icon)
                .font(.largeTitle)
                .foregroundStyle(.yellow)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(tip.title)
                    .font(.headline)
                
                Text(tip.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
