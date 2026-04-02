import SwiftUI

enum FrictionSection: String, CaseIterable {
    case overview = "Overview"
    case why = "Why Study?"
    case cases = "Cases"
    case animation = "Animation"
    case formulas = "Formulas"
}

struct FrictionDetailContent: View {
    
    @State private var selectedSection: FrictionSection = .overview
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            Picker("Section", selection: $selectedSection) {
                ForEach(FrictionSection.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.segmented)
            
            Group {
                switch selectedSection {
                case .overview:
                    FrictionOverviewSection()
                case .why:
                    FrictionWhyStudySection()
                case .cases:
                    FrictionCasesSection()
                case .animation:
                    FrictionAnimationSection()
                case .formulas:
                    FrictionFormulasSection()
                }
            }
            .animation(.easeInOut, value: selectedSection)
        }
        .padding()
    }
}


struct FrictionOverviewSection: View {
    
    var body: some View {
        VStack(spacing: 20) {
            
            VStack(alignment: .leading, spacing: 16) {
                
                HStack(spacing: 8) {
                    Image(systemName: "hand.draw.fill")
                        .foregroundColor(.blue)
                    Text("Overview")
                        .font(.headline)
                }
                
                Text("""
Friction is the force that opposes the relative motion between two surfaces in contact. It always acts opposite to the direction of motion.
""")
                .foregroundStyle(.secondary)
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    HStack {
                        infoChip("Opposes Motion", color: .blue)
                        Spacer()
                    }
                    
                    HStack {
                        infoChip("Depends on Surface Type", color: .orange)
                        Spacer()
                    }
                    
                    HStack {
                        infoChip("μ = Coefficient of Friction", color: .green)
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
Static friction is usually greater than kinetic friction. That’s why it is harder to start moving an object than to keep it moving.
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
    


struct FrictionWhyStudySection: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack(spacing: 8) {
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(.purple)
                
                Text("Why Study Friction?")
                    .font(.headline)
            }
            
            VStack(spacing: 0) {
                
                WhyStudyRow(
                    icon: "figure.walk",
                    iconColor: .blue,
                    title: "Walking & Driving",
                    desc: "Without friction, we cannot walk, run, or drive vehicles safely."
                )
                
                Divider()
                
                WhyStudyRow(
                    icon: "flame.fill",
                    iconColor: .red,
                    title: "Heat Production",
                    desc: "Friction converts motion energy into heat energy."
                )
                
                Divider()
                
                WhyStudyRow(
                    icon: "car.fill",
                    iconColor: .green,
                    title: "Braking Systems",
                    desc: "Car and bike brakes work because of friction between surfaces."
                )
                
                Divider()
                
                WhyStudyRow(
                    icon: "gearshape.fill",
                    iconColor: .purple,
                    title: "Engineering Applications",
                    desc: "Essential in machine design, tires, bearings, and surface materials."
                )
                
                Divider()
                
                WhyStudyRow(
                    icon: "hammer.fill",
                    iconColor: .orange,
                    title: "Grip & Stability",
                    desc: "Helps objects stay in place and prevents slipping."
                )
                
                Divider()
                
                WhyStudyRow(
                    icon: "book.fill",
                    iconColor: .blue,
                    title: "Foundation Concept",
                    desc: "Important for understanding force, motion, and Newton’s laws."
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.systemGray6))
            )
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
        .padding(.vertical)
    }
}

struct FrictionCasesSection: View {
    
    var body: some View {
        VStack(spacing: 16) {
            
            CaseCard(
                icon: "hand.raised.fill",
                color: .orange,
                title: "Static Friction",
                description: """
Prevents motion when object is at rest.
Acts before motion starts.
""",
                example: "Pushing a heavy box"
            )
            
            CaseCard(
                icon: "arrow.right.circle.fill",
                color: .blue,
                title: "Kinetic Friction",
                description: """
Acts when object is moving.
Usually smaller than static friction.
""",
                example: "Sliding book on table"
            )
            
            CaseCard(
                icon: "circle.grid.cross.fill",
                color: .green,
                title: "Rolling Friction",
                description: """
Occurs when object rolls.
Very small compared to others.
""",
                example: "Car wheels"
            )
        }
    }
}

struct FrictionAnimationSection: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack(spacing: 8) {
                Image(systemName: "play.circle.fill")
                    .foregroundColor(.blue)
                Text("Interactive Animation")
                    .font(.headline)
            }
            
            Text("Adjust force and friction to observe motion.")
                .foregroundStyle(.secondary)
            
            FrictionAnimationView()
        }
    }
}


struct FrictionFormulasSection: View {
    
    @State private var selectedFormula: FormulaItem?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack(spacing: 8) {
                Image(systemName: "hand.draw.fill")
                    .foregroundColor(.brown)
                Text("Friction Formulas")
                    .font(.headline)
            }
            
            Button {
                selectedFormula = FormulaItem(
                    title: "Friction Force (f)",
                    formula: "f = μN",
                    explanation:
"""
Friction force opposes motion.

Where:
• μ = Coefficient of friction
• N = Normal reaction force

Important:
• Depends on surface type
• Independent of area of contact
"""
                )
            } label: {
                FormulaCard(
                    title: "Friction Force (f)",
                    formula: "f = μN",
                    meaning: "Tap to see full explanation"
                )
            }
            .buttonStyle(.plain)
            
            
            // 🔹 Static Friction
            Button {
                selectedFormula = FormulaItem(
                    title: "Maximum Static Friction",
                    formula: "fₛ(max) = μₛ N",
                    explanation:
"""
Maximum friction before motion starts.

Where:
• μₛ = Coefficient of static friction

Important:
• Acts when object is at rest
• Prevents motion
"""
                )
            } label: {
                FormulaCard(
                    title: "Static Friction",
                    formula: "fₛ(max) = μₛ N",
                    meaning: "Tap to see full explanation"
                )
            }
            .buttonStyle(.plain)
            
            
            // 🔹 Kinetic Friction
            Button {
                selectedFormula = FormulaItem(
                    title: "Kinetic Friction",
                    formula: "fₖ = μₖ N",
                    explanation:
"""
Friction when object is moving.

Where:
• μₖ = Coefficient of kinetic friction

Important:
• Always less than static friction
• Opposes motion
"""
                )
            } label: {
                FormulaCard(
                    title: "Kinetic Friction",
                    formula: "fₖ = μₖ N",
                    meaning: "Tap to see full explanation"
                )
            }
            .buttonStyle(.plain)
            
            
            Button {
                selectedFormula = FormulaItem(
                    title: "Normal Force (Flat Surface)",
                    formula: "N = mg",
                    explanation:
"""
Normal reaction on flat surface.

Where:
• m = Mass
• g = Gravity

Important:
• Acts perpendicular to surface
"""
                )
            } label: {
                FormulaCard(
                    title: "Normal Force",
                    formula: "N = mg",
                    meaning: "Tap to see full explanation"
                )
            }
            .buttonStyle(.plain)
            
            
            Button {
                selectedFormula = FormulaItem(
                    title: "Inclined Plane",
                    formula: "N = mg cosθ,  f = μN",
                    explanation:
"""
For objects on an inclined plane:

• Normal force = mg cosθ
• Friction = μN

Important:
• As angle increases → normal force decreases
• Friction also decreases
"""
                )
            } label: {
                FormulaCard(
                    title: "Inclined Plane",
                    formula: "N = mg cosθ",
                    meaning: "Tap to see full explanation"
                )
            }
            .buttonStyle(.plain)
            
            
            Button {
                selectedFormula = FormulaItem(
                    title: "Limiting Condition",
                    formula: "f ≤ μₛ N",
                    explanation:
"""
Condition before motion starts.

Important:
• Object moves only when applied force exceeds maximum static friction
• f = μₛ N at limiting point
"""
                )
            } label: {
                FormulaCard(
                    title: "Limiting Condition",
                    formula: "f ≤ μₛ N",
                    meaning: "Tap to see full explanation"
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical)
        
        .sheet(item: $selectedFormula) { item in
            FormulaDetailSheet(item: item)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}
