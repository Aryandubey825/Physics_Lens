enum NewtonSecondLawSection: String, CaseIterable {
    case overview = "Overview"
    case why = "Why Study?"
    case cases = "Cases"
    case animation = "Animation"
    case formulas = "Formulas"
}

import SwiftUI

struct NewtonSecondLawDetailContent: View {
    
    @State private var selectedSection: NewtonSecondLawSection = .overview
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            Picker("Section", selection: $selectedSection) {
                ForEach(NewtonSecondLawSection.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.segmented)
            
            Group {
                switch selectedSection {
                    
                case .overview:
                    SecondLawOverviewSection()
                    
                case .why:
                    NewtonWhyStudySection()
                    
                case .cases:
                    NewtonCasesSection()
                    
                case .animation:
                    NewtonAnimationSection()
                    
                case .formulas:
                    SecondLawFormulasSection()
                }
            }
            .animation(.easeInOut, value: selectedSection)
        }
    }
}

struct SecondLawOverviewSection: View {
    
    var body: some View {
        VStack(spacing: 20) {
            
            VStack(alignment: .leading, spacing: 16) {
                
                HStack(spacing: 8) {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.blue)
                    Text("Overview")
                        .font(.headline)
                }
                
                Text("""
Newton’s Second Law of Motion states that the acceleration of an object is directly proportional to the net force applied and inversely proportional to its mass.
""")
                .foregroundStyle(.secondary)
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    HStack {
                        infoChip("F = m × a", color: .blue)
                        Spacer()
                    }
                    
                    HStack {
                        infoChip("Acceleration ∝ Force", color: .orange)
                        Spacer()
                    }
                    
                    HStack {
                        infoChip("Acceleration ∝ 1/Mass", color: .green)
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
If you apply the same force to two objects of different masses, the lighter object will accelerate more.
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

struct NewtonWhyStudySection: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack(spacing: 8) {
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(.purple)
                
                Text("Why Study Newton’s Second Law?")
                    .font(.headline)
            }
            
            VStack(spacing: 0) {
                
                WhyStudyRow(
                    icon: "car.fill",
                    iconColor: .blue,
                    title: "Understand Acceleration",
                    desc: "Explains how force affects motion and acceleration (F = ma)."
                )
                
                Divider()
                
                WhyStudyRow(
                    icon: "rocket.fill",
                    iconColor: .orange,
                    title: "Rocket & Space Science",
                    desc: "Used to calculate thrust, lift-off force, and space motion."
                )
                
                Divider()
                
                WhyStudyRow(
                    icon: "hammer.fill",
                    iconColor: .red,
                    title: "Engineering Applications",
                    desc: "Essential in machine design, robotics, and structural mechanics."
                )
                
                Divider()
                
                WhyStudyRow(
                    icon: "cpu.fill",
                    iconColor: .purple,
                    title: "Game Physics",
                    desc: "Game engines simulate realistic movement using F = ma."
                )
                
                Divider()
                
                WhyStudyRow(
                    icon: "chart.bar.fill",
                    iconColor: .green,
                    title: "Force Analysis",
                    desc: "Helps calculate net force, mass effects, and motion prediction."
                )
                
                Divider()
                
                WhyStudyRow(
                    icon: "graduationcap.fill",
                    iconColor: .blue,
                    title: "Foundation of Mechanics",
                    desc: "Core concept for momentum, energy, and advanced physics topics."
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

struct NewtonCasesSection: View {
    
    var body: some View {
        VStack(spacing: 16) {
            
            CaseCard(
                icon: "arrow.right",
                color: .blue,
                title: "Constant Force",
                description: """
If force is constant → acceleration is constant.
Object moves with uniformly accelerated motion.
""",
                example: "Pushing a trolley with constant force"
            )
            
            CaseCard(
                icon: "scalemass.fill",
                color: .red,
                title: "Increasing Mass",
                description: """
If mass increases and force is same → acceleration decreases.
""",
                example: "Truck vs Bike acceleration"
            )
            
            CaseCard(
                icon: "arrow.up.circle.fill",
                color: .green,
                title: "Zero Net Force",
                description: """
If net force = 0 → acceleration = 0.
Velocity remains constant.
""",
                example: "Balanced forces"
            )
        }
    }
}
struct NewtonFormulasSection: View {
    
    var body: some View {
        VStack(spacing: 16) {
            
            FormulaCard(
                title: "Newton’s Second Law",
                formula: "F = ma",
                meaning: "Force equals mass times acceleration."
            )
            
            FormulaCard(
                title: "Acceleration",
                formula: "a = F / m",
                meaning: "Acceleration depends on force and mass."
            )
            
            FormulaCard(
                title: "Unit of Force",
                formula: "1 N = 1 kg·m/s²",
                meaning: "Derived SI unit."
            )
        }
    }
}


struct NewtonAnimationSection: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack(spacing: 8) {
                Image(systemName: "bolt.fill")
                    .foregroundColor(.blue)
                
                Text("Interactive Animation")
                    .font(.headline)
            }
            
            Text("Adjust force and mass to observe how acceleration changes.")
                .foregroundStyle(.secondary)
            
            NewtonSecondLawSimulator()
        }
        .padding(.vertical)
    }
}
#Preview {
    NewtonSecondLawDetailContent()
}

import SwiftUI

struct SecondLawFormulasSection: View {
    
    @State private var selectedFormula: FormulaItem?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack(spacing: 8) {
                Image(systemName: "bolt.fill")
                    .foregroundColor(.red)
                Text("Second Law of Motion")
                    .font(.headline)
            }
            
            Button {
                selectedFormula = FormulaItem(
                    title: "Force (F)",
                    formula: "F = m × a",
                    explanation:
"""
Force is equal to mass multiplied by acceleration.

Where:
• m = Mass (kg)
• a = Acceleration (m/s²)

Unit:
• Newton (N)

Important:
• More mass → More force needed
• More acceleration → More force
"""
                )
            } label: {
                FormulaCard(
                    title: "Force (F)",
                    formula: "F = m × a",
                    meaning: "Tap to see full explanation"
                )
            }
            .buttonStyle(.plain)
            
            
            Button {
                selectedFormula = FormulaItem(
                    title: "Acceleration (a)",
                    formula: "a = F / m",
                    explanation:
"""
Acceleration produced by a force.

Important:
• Inversely proportional to mass
• Light objects accelerate more
"""
                )
            } label: {
                FormulaCard(
                    title: "Acceleration (a)",
                    formula: "a = F / m",
                    meaning: "Tap to see full explanation"
                )
            }
            .buttonStyle(.plain)
            
            
            Button {
                selectedFormula = FormulaItem(
                    title: "Mass (m)",
                    formula: "m = F / a",
                    explanation:
"""
Mass of an object.

Important:
• Measure of inertia
• Higher mass → harder to accelerate
"""
                )
            } label: {
                FormulaCard(
                    title: "Mass (m)",
                    formula: "m = F / a",
                    meaning: "Tap to see full explanation"
                )
            }
            .buttonStyle(.plain)
            
            
            Button {
                selectedFormula = FormulaItem(
                    title: "Force (Momentum Form)",
                    formula: "F = Δp / Δt",
                    explanation:
"""
Force is the rate of change of momentum.

Where:
• p = momentum (m × v)
• Δp = change in momentum
• Δt = time

Important:
• Used in collisions
• Shows dynamic nature of force
"""
                )
            } label: {
                FormulaCard(
                    title: "Momentum Form",
                    formula: "F = Δp / Δt",
                    meaning: "Tap to see full explanation"
                )
            }
            .buttonStyle(.plain)
            
            
            Button {
                selectedFormula = FormulaItem(
                    title: "Momentum (p)",
                    formula: "p = m × v",
                    explanation:
"""
Momentum is the quantity of motion.

Where:
• m = mass
• v = velocity

Important:
• Vector quantity
• Important in collisions
"""
                )
            } label: {
                FormulaCard(
                    title: "Momentum (p)",
                    formula: "p = m × v",
                    meaning: "Tap to see full explanation"
                )
            }
            .buttonStyle(.plain)
            
            
            Button {
                selectedFormula = FormulaItem(
                    title: "Impulse (J)",
                    formula: "J = F × t = Δp",
                    explanation:
"""
Impulse is change in momentum.

Important:
• Used in impact problems
• Increasing time reduces force (safety airbags)
"""
                )
            } label: {
                FormulaCard(
                    title: "Impulse (J)",
                    formula: "J = F × t",
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
