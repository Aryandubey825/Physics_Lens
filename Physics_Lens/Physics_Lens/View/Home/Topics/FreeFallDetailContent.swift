import SwiftUI

enum FreeFallSection: String, CaseIterable {
    case overview = "Overview"
    case why = "Why Study?"
    case cases = "Cases"
    case animation = "Animation"
    case formulas = "Formulas"
}

struct FreeFallDetailContent: View {
    
    @State private var selectedSection: FreeFallSection = .overview
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            Picker("Section", selection: $selectedSection) {
                ForEach(FreeFallSection.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.segmented)
            
            Group {
                switch selectedSection {
                case .overview:
                    FreeFallOverviewSection()
                case .why:
                    FreeFallWhyStudySection()
                case .cases:
                    FreeFallCasesSection()
                case .animation:
                    FreeFallAnimationSection()
                case .formulas:
                    FreeFallFormulasSection()
                }
            }
            .animation(.easeInOut, value: selectedSection)
        }
    }
}


struct FreeFallOverviewSection: View {
    
    var body: some View {
        VStack(spacing: 20) {
            
            VStack(alignment: .leading, spacing: 16) {
                
                HStack(spacing: 8) {
                    Image(systemName: "arrow.down.circle.fill")
                        .foregroundColor(.blue)
                    Text("Overview")
                        .font(.headline)
                }
                
                Text("""
Free fall is the motion of an object when gravity is the only force acting upon it. Air resistance is neglected in ideal free fall.
""")
                .foregroundStyle(.secondary)
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    HStack {
                        infoChip("Only Gravity Acts", color: .blue)
                        Spacer()
                    }
                    
                    HStack {
                        infoChip("g = 9.8 m/s²", color: .orange)
                        Spacer()
                    }
                    
                    HStack {
                        infoChip("a = g (Downward)", color: .green)
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
In vacuum, all objects fall with the same acceleration regardless of their mass.
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


struct FreeFallWhyStudySection: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack(spacing: 8) {
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(.purple)
                
                Text("Why Study Free Fall?")
                    .font(.headline)
            }
            
            VStack(spacing: 0) {
                
                WhyStudyRow(
                    icon: "arrow.down.circle.fill",
                    iconColor: .blue,
                    title: "Understand Gravity",
                    desc: "Learn how gravity affects motion in the vertical direction."
                )
                
                Divider()
                
                WhyStudyRow(
                    icon: "clock.fill",
                    iconColor: .green,
                    title: "Motion Prediction",
                    desc: "Calculate time, velocity, and distance of falling objects."
                )
                
                Divider()
                
                WhyStudyRow(
                    icon: "graduationcap.fill",
                    iconColor: .orange,
                    title: "Exam Foundation",
                    desc: "Base concept for projectile motion and kinematics."
                )
                
                Divider()
                
                WhyStudyRow(
                    icon: "gearshape.fill",
                    iconColor: .purple,
                    title: "Real Applications",
                    desc: "Used in engineering, space science, and physics experiments."
                )
                
                Divider()
                
                WhyStudyRow(
                    icon: "apple.logo",
                    iconColor: .red,
                    title: "Gravity in Action",
                    desc: "Explains why objects fall downward due to gravity alone."
                )
                
                Divider()
                
                WhyStudyRow(
                    icon: "moon.stars.fill",
                    iconColor: .blue,
                    title: "Earth vs Moon",
                    desc: "Helps compare motion under different gravitational conditions."
                )
                
                Divider()
                
                WhyStudyRow(
                    icon: "building.2.fill",
                    iconColor: .green,
                    title: "Engineering Applications",
                    desc: "Used to calculate fall time and safety in structures and designs."
                )
                
                Divider()
                
                WhyStudyRow(
                    icon: "graduationcap.fill",
                    iconColor: .orange,
                    title: "Foundation of Kinematics",
                    desc: "Forms the base for projectile motion and advanced physics topics."
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


struct FreeFallCasesSection: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("Important Cases")
                    .font(.headline)
            }
            
            CaseCard(
                icon: "arrow.down",
                color: .blue,
                title: "Object Dropped from Rest",
                description: """
Initial velocity u = 0

• Accelerates downward due to gravity
• Velocity increases linearly with time
""",
                example: "Example: Stone dropped from a building"
            )
            
            CaseCard(
                icon: "arrow.up",
                color: .red,
                title: "Object Thrown Upward",
                description: """
Initial velocity u ≠ 0

• Velocity decreases while going up
• At highest point, v = 0
""",
                example: "Example: Ball thrown vertically upward"
            )
            
            CaseCard(
                icon: "speedometer",
                color: .green,
                title: "Acceleration Remains Constant",
                description: """
Acceleration due to gravity remains constant.

• a = g = 9.8 m/s²
• Independent of mass
""",
                example: "Same acceleration for all objects"
            )
        }
        .padding(.vertical)
    }
}


struct FreeFallAnimationSection: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🎬 Free Fall Visualization")
                .font(.headline)
            
            Text("Graph / animation can be shown here.")
                .foregroundStyle(.secondary)
            FreeFallAnimationView()
        }
        .padding(.vertical)
    }
}




struct FreeFallFormulasSection: View {
    
    @State private var selectedFormula: FormulaItem?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack(spacing: 8) {
                Image(systemName: "arrow.down.circle")
                    .foregroundColor(.blue)
                Text("Free Fall Formulas")
                    .font(.headline)
            }
            
            
            Button {
                selectedFormula = FormulaItem(
                    title: "Final Velocity (v)",
                    formula: "v = u + gt",
                    explanation:
"""
Velocity of an object after time t.

Where:
• u = Initial velocity
• g = Acceleration due to gravity (9.8 m/s²)
• t = Time

Important:
• If dropped from rest → u = 0 → v = gt
"""
                )
            } label: {
                FormulaCard(
                    title: "Final Velocity (v)",
                    formula: "v = u + gt",
                    meaning: "Tap to see full explanation"
                )
            }
            .buttonStyle(.plain)
            
            
            Button {
                selectedFormula = FormulaItem(
                    title: "Displacement (s)",
                    formula: "s = ut + ½gt²",
                    explanation:
"""
Distance covered during free fall.

Important:
• If dropped from rest → u = 0 → s = ½gt²
• Distance increases with time squared
"""
                )
            } label: {
                FormulaCard(
                    title: "Displacement (s)",
                    formula: "s = ut + ½gt²",
                    meaning: "Tap to see full explanation"
                )
            }
            .buttonStyle(.plain)
            
            Button {
                selectedFormula = FormulaItem(
                    title: "Velocity Square",
                    formula: "v² = u² + 2gs",
                    explanation:
"""
Useful when time is not given.

Important:
• Direct relation between velocity and displacement
• Used in height-based problems
"""
                )
            } label: {
                FormulaCard(
                    title: "Velocity Square",
                    formula: "v² = u² + 2gs",
                    meaning: "Tap to see full explanation"
                )
            }
            .buttonStyle(.plain)
            
            
            Button {
                selectedFormula = FormulaItem(
                    title: "Time of Fall (t)",
                    formula: "t = √(2h / g)",
                    explanation:
"""
Time taken to fall from height h.

Important:
• Derived from s = ½gt²
• Only valid when u = 0
"""
                )
            } label: {
                FormulaCard(
                    title: "Time of Fall (t)",
                    formula: "t = √(2h / g)",
                    meaning: "Tap to see full explanation"
                )
            }
            .buttonStyle(.plain)
            
            Button {
                selectedFormula = FormulaItem(
                    title: "Velocity from Height",
                    formula: "v = √(2gh)",
                    explanation:
"""
Velocity when object reaches ground.

Important:
• Independent of mass
• Depends only on height
"""
                )
            } label: {
                FormulaCard(
                    title: "Velocity from Height",
                    formula: "v = √(2gh)",
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
