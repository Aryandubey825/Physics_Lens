
import SwiftUI
struct FormulaItem: Identifiable {
    let id = UUID()
    let title: String
    let formula: String
    let explanation: String
}

enum PendulumSection: String, CaseIterable {
    case overview = "Overview"
    case why = "Why Study?"
    case cases = "Cases"
    case animation = "Animation"
    case formulas = "Formulas"
}

struct PendulumDetailContent: View {
    
    @State private var selectedSection: PendulumSection = .overview
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            
            Picker("Section", selection: $selectedSection) {
                ForEach(PendulumSection.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.segmented)
            
            Group {
                switch selectedSection {
                    
                case .overview:
                    
                    PendulumOverviewSection()
                    
                case .why:
                    PendulumWhyStudySection()
                    
                case .cases:
                    PendulumCasesSection()
                    
                case .animation:
                    PendulumAnimationSection()
                    
                case .formulas:
                    PendulumFormulasSection()
                }
            }
            .animation(.easeInOut, value: selectedSection)
        }
    }
}


struct PendulumOverviewSection: View {
    
    var body: some View {
        VStack(spacing: 20) {
            
            // 📘 OVERVIEW CARD
            VStack(alignment: .leading, spacing: 16) {
                
                HStack(spacing: 8) {
                    Image(systemName: "circle.dotted")
                        .foregroundColor(.blue)
                    Text("Overview")
                        .font(.headline)
                }
                
                Text("""
A pendulum is a mass (called a bob) attached to a string or rod that swings back and forth under the influence of gravity.
""")
                .foregroundStyle(.secondary)
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    HStack {
                        infoChip("Oscillatory Motion", color: .blue)
                        Spacer()
                    }
                    
                    HStack {
                        infoChip("Time Period (T)", color: .orange)
                        Spacer()
                    }
                    
                    HStack {
                        infoChip("T = 2π√(L/g)", color: .green)
                        Spacer()
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            
            
            VStack(alignment: .leading, spacing: 16) {
                
                HStack(spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                    Text("Did You Know?")
                        .font(.headline)
                }
                
                Text("""
The time period of a simple pendulum depends only on its length and gravity, not on the mass of the bob.
""")
                .foregroundStyle(.secondary)
                
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.vertical)
    }

    
    func infoChip(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.caption.bold())
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
}


struct PendulumWhyStudySection: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack(spacing: 8) {
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(.purple)
                
                Text("Why Study Pendulum?")
                    .font(.headline)
            }
            
            VStack(spacing: 0) {
                
                WhyStudyRow(
                    icon: "waveform.path.ecg",
                    iconColor: .blue,
                    title: "Understand SHM",
                    desc: "Pendulum is the best real-life example of simple harmonic motion."
                )
                
                Divider()
                
                WhyStudyRow(
                    icon: "clock.fill",
                    iconColor: .green,
                    title: "Time Measurement",
                    desc: "Pendulums were historically used in clocks."
                )
                
                Divider()
                
                WhyStudyRow(
                    icon: "graduationcap.fill",
                    iconColor: .orange,
                    title: "Foundation Topic",
                    desc: "Helps in oscillations, waves, and rotational mechanics."
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.systemGray6))
            )
        }
        .padding(.vertical)
    }
}

struct PendulumCasesSection: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("Important Cases")
                    .font(.headline)
            }
            
            CaseCard(
                icon: "angle",
                color: .blue,
                title: "Small Angle Oscillation",
                description: """
When the angle is small (<15°), pendulum behaves like SHM.

• Time period independent of amplitude
• Motion is sinusoidal
""",
                example: "Used in all formulas"
            )
            
            CaseCard(
                icon: "arrow.up.and.down",
                color: .green,
                title: "Effect of Length",
                description: """
Time period increases with length.

• Longer string → slower motion
""",
                example: "T ∝ √L"
            )
            
            CaseCard(
                icon: "xmark.circle",
                color: .red,
                title: "Mass Independence",
                description: """
Mass of the bob does not affect time period.
""",
                example: "Iron or wood → same result"
            )
        }
        .padding(.vertical)
    }
}


struct PendulumAnimationSection: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack(spacing: 8) {
                Image(systemName: "play.circle.fill")
                    .foregroundColor(.blue)
                Text("Interactive Animation")
                    .font(.headline)
            }
            
            Text("Adjust length and gravity to observe oscillation.")
                .foregroundStyle(.secondary)
            
            PendulumAnimationView()
        }
        .padding(.vertical)
    }
}


struct PendulumFormulasSection: View {
    
    @State private var selectedFormula: FormulaItem?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack(spacing: 8) {
                Image(systemName: "function")
                    .foregroundColor(.purple)
                Text("Important Formulas")
                    .font(.headline)
            }
          
            Button {
                selectedFormula = FormulaItem(
                    title: "Time Period (T)",
                    formula: "T = 2π √(L / g)",
                    explanation:
"""
Time taken for one complete oscillation.

Where:
• L = Length of pendulum
• g = Acceleration due to gravity

Important Points:
• Independent of mass
• Valid only for small angles (<15°)
• Larger length → Larger time period
"""
                )
            } label: {
                FormulaCard(
                    title: "Time Period (T)",
                    formula: "T = 2π √(L / g)",
                    meaning: "Tap to see full explanation"
                )
            }
            .buttonStyle(.plain)
            
            
            Button {
                selectedFormula = FormulaItem(
                    title: "Frequency (f)",
                    formula: "f = 1 / T",
                    explanation:
"""
Frequency tells how many oscillations occur in one second.

Unit: Hertz (Hz)

Important:
• Inversely proportional to time period
• Faster oscillation → Higher frequency
"""
                )
            } label: {
                FormulaCard(
                    title: "Frequency (f)",
                    formula: "f = 1 / T",
                    meaning: "Tap to see full explanation"
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical)
        
        .sheet(item: $selectedFormula) { item in
            FormulaDetailSheet(item: item)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}
struct FormulaDetailSheet: View {
    
    let item: FormulaItem
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    Text(item.title)
                        .font(.title.bold())
                    
                    Text(item.formula)
                        .font(.system(size: 24, weight: .semibold, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.blue.opacity(0.08))
                        )
                    
                    Divider()
                    
                    Text(item.explanation)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                .padding(24)
                .frame(maxWidth: 600)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Formula Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
