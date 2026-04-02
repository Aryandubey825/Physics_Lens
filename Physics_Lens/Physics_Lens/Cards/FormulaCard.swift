import SwiftUI

struct FormulaCard: View {
    
    let title: String
    let formula: String
    let meaning: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text(title)
                    .font(.headline)
                
                Text(formula)
                    .font(.system(size: 18, weight: .semibold, design: .monospaced))
                    .foregroundStyle(.primary)
                    .padding(.vertical, 4)
                
                Text(meaning)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 5)
    }
}
