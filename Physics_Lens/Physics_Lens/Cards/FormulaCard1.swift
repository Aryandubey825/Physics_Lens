import SwiftUI

struct FormulaCard1: View {
    
    var title: String
    var formula: String
    var explanation: String
    
    @State private var expanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            HStack {
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                Button {
                    expanded.toggle()
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                } label: {
                    Image(systemName: expanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .font(.title3)
                }
            }
            
            Text(formula)
                .font(.system(.title2, design: .monospaced))
                .foregroundColor(.blue)
            
            if expanded {
                Text(explanation)
                    .foregroundColor(.secondary)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 8)
        .animation(.easeInOut, value: expanded)
    }
}

