import SwiftUI

struct FormulaCard1: View {
    
    var title: String
    var formula: String
    var explanation: String
    var themeColor: Color = .blue
    
    @State private var expanded = false
    
    var body: some View {
        HStack(spacing: 0) {
            // Left color stripe
            RoundedRectangle(cornerRadius: 3)
                .fill(themeColor)
                .frame(width: 5)
                .padding(.vertical, 8)
                
            VStack(alignment: .leading, spacing: 14) {
                
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            expanded.toggle()
                        }
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    } label: {
                        Image(systemName: expanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                            .font(.title3)
                            .foregroundColor(themeColor)
                    }
                }
                
                // Formula Equation Container
                Text(formula)
                    .font(.system(.title3, design: .monospaced))
                    .bold()
                    .foregroundColor(themeColor)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(themeColor.opacity(0.08))
                    )
                
                if expanded {
                    VStack(alignment: .leading, spacing: 8) {
                        Divider()
                            .padding(.top, 4)
                        
                        Text(explanation)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                            .padding(.top, 4)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(.leading, 14)
            .padding(.vertical, 14)
            .padding(.trailing, 14)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 5)
    }
}

