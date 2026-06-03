import SwiftUI

struct FormulaItem: Identifiable {
    let id = UUID()
    let title: String
    let formula: String
    let explanation: String
}

struct FormulaDetailView: View {
    let unitTitle: String
    let formulas: [FormulaItem]
    var themeColor: Color = .blue
    var iconName: String = "sparkles"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Header Card
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [themeColor, themeColor.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 70, height: 70)
                            .shadow(color: themeColor.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        Image(systemName: iconName)
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 12)
                    
                    VStack(spacing: 6) {
                        Text(unitTitle)
                            .font(.title2.bold())
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                        
                        Text("Class 11 Physics Formula Cheat Sheet")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                            .tracking(1.5)
                    }
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(24)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                
                // Formula List
                VStack(spacing: 18) {
                    ForEach(formulas) { item in
                        FormulaCard1(
                            title: item.title,
                            formula: item.formula,
                            explanation: item.explanation,
                            themeColor: themeColor
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity) // Dynamic outer alignment
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
    }
}
