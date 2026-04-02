enum ProjectileSection: String, CaseIterable {
    case overview = "Overview"
    case why = "Why Study?"
    case cases = "Cases"
    case animation = "Animation"
    case formulas = "Formulas"
}

import SwiftUI

struct ProjectileDetailContent: View {
    @State private var selectedSection: ProjectileSection = .overview
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            
            
            Picker("Section", selection: $selectedSection) {
                ForEach(ProjectileSection.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.segmented)
            
            Group {
                switch selectedSection {
                    
                case .overview:
                    ProjectileOverviewSection()
                    
                case .why:
                    WhyStudySection()
                    
                case .cases:
                    CasesSection()
                    
                case .animation:
                    AnimationSection()
                    
                case .formulas:
                    ProjectileFormulasSection()
                }
            }
            .animation(.easeInOut, value: selectedSection)
        }
    }
}




struct WhyStudySection: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack(spacing: 8) {
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(.purple)
                
                Text("Why Study Projectile Motion?")
                    .font(.headline)
            }
            
            VStack(spacing: 0) {
                
                WhyStudyRow(
                    icon: "square.stack.3d.up.fill",
                    iconColor: .blue,
                    title: "Understand 2D Motion",
                    desc: "Learn how horizontal and vertical motions act independently under gravity."
                )
                
                Divider()
                
                WhyStudyRow(
                    icon: "sportscourt.fill",
                    iconColor: .green,
                    title: "Real-Life Applications",
                    desc: "Sports shots, fireworks, rockets, water jets, and daily throwing motions."
                )
                
                Divider()
                
                WhyStudyRow(
                    icon: "graduationcap.fill",
                    iconColor: .orange,
                    title: "What You’ll Learn",
                    desc: "Predict time of flight, maximum height, range, and velocity components."
                )
                
                Divider()
                
                WhyStudyRow(
                    icon: "building.columns.fill",
                    iconColor: .purple,
                    title: "Foundation for Advanced Topics",
                    desc: "Helps in mechanics, circular motion, engineering physics, and robotics."
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




struct CasesSection: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("Important Cases")
                    .font(.headline)
            }
            
            CaseCard(
                icon: "arrow.right",
                color: .blue,
                title: "Horizontal Projection (θ = 0°)",
                description: """
The object is projected horizontally with zero initial vertical velocity.

• Horizontal velocity remains constant
• Vertical motion is free fall
• Time of flight depends only on height
""",
                example: "Example: Ball rolling off a table"
            )
            
            CaseCard(
                icon: "arrow.up",
                color: .red,
                title: "Vertical Projection (θ = 90°)",
                description: """
The object is projected vertically upward.

• Horizontal velocity = 0
• Velocity decreases while going up
• At highest point, Vy = 0
""",
                example: "Example: Throwing a ball straight up"
            )
            
            CaseCard(
                icon: "angle",
                color: .green,
                title: "Maximum Range at 45°",
                description: """
For a given speed, maximum horizontal range is obtained at 45°.

• sin(2θ) is maximum at 45°
• 30° and 60° give same range
""",
                example: "Very important for exams"
            )
            
            CaseCard(
                icon: "clock.arrow.circlepath",
                color: .purple,
                title: "Time of Flight Depends on Vy",
                description: """
Time of flight depends only on the vertical component of velocity.

• Higher angle → more time in air
• Horizontal speed has no effect
""",
                example: "T = (2u sinθ) / g"
            )
            
            CaseCard(
                icon: "arrow.left.and.right",
                color: .orange,
                title: "Horizontal Velocity Remains Constant",
                description: """
Gravity acts only in the vertical direction.

• No force along horizontal direction
• Horizontal velocity remains unchanged
""",
                example: "Key reason behind parabolic path"
            )
        }
        .padding(.vertical)
    }
}

struct AnimationSection : View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            sectionTitle("🎬 Interactive Animation")
            
            Text("Adjust angle and velocity to see how the projectile path changes.")
                .foregroundStyle(.secondary)
            
            ProjectileMotionSimulator()
        }
        .padding(.vertical)
    }
}



struct ProjectileOverviewSection: View {
    
    var body: some View {
        VStack(spacing: 20) {
            
            //  OVERVIEW CARD
            VStack(alignment: .leading, spacing: 16) {
                
                HStack(spacing: 8) {
                    Image(systemName: "book.fill")
                        .foregroundColor(.blue)
                    Text("Overview")
                        .font(.headline)
                }
                
                Text("""
Projectile motion describes the motion of an object projected into air at an angle and moving only under the influence of gravity.
""")
                .foregroundStyle(.secondary)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        infoChip("Shape: Parabola", color: .blue)
                        Spacer()
                    }
                    HStack {
                        infoChip("g = 9.8 m/s²", color: .orange)
                        Spacer()
                    }
                    HStack {
                        infoChip("Real-life: Sports, Rockets", color: .green)
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
At the highest point of projectile motion, the vertical velocity becomes zero, but the horizontal velocity remains unchanged.
""")
                .foregroundStyle(.secondary)
                
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
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
    
    
struct ProjectileFormulasSection: View {
    
    @State private var selectedFormula: FormulaItem?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack(spacing: 8) {
                Image(systemName: "arrow.up.forward.circle")
                    .foregroundColor(.orange)
                Text("Projectile Motion Formulas")
                    .font(.headline)
            }
            
            Button {
                selectedFormula = FormulaItem(
                    title: "Time of Flight (T)",
                    formula: "T = (2u sinθ) / g",
                    explanation:
"""
Total time the projectile stays in air.

Where:
• u = Initial velocity
• θ = Angle of projection
• g = Acceleration due to gravity

Important:
• Depends on angle and velocity
• Maximum at 90°
"""
                )
            } label: {
                FormulaCard(
                    title: "Time of Flight (T)",
                    formula: "T = (2u sinθ) / g",
                    meaning: "Tap to see full explanation"
                )
            }
            .buttonStyle(.plain)
            
            
            Button {
                selectedFormula = FormulaItem(
                    title: "Maximum Height (H)",
                    formula: "H = (u² sin²θ) / (2g)",
                    explanation:
"""
Maximum vertical height reached.

Important:
• Depends on vertical component of velocity
• More angle → More height
"""
                )
            } label: {
                FormulaCard(
                    title: "Maximum Height (H)",
                    formula: "H = (u² sin²θ) / (2g)",
                    meaning: "Tap to see full explanation"
                )
            }
            .buttonStyle(.plain)
            
            
            Button {
                selectedFormula = FormulaItem(
                    title: "Horizontal Range (R)",
                    formula: "R = (u² sin2θ) / g",
                    explanation:
"""
Total horizontal distance covered.

Important:
• Maximum at 45°
• Same range for θ and (90° - θ)
"""
                )
            } label: {
                FormulaCard(
                    title: "Horizontal Range (R)",
                    formula: "R = (u² sin2θ) / g",
                    meaning: "Tap to see full explanation"
                )
            }
            .buttonStyle(.plain)
            
            
            Button {
                selectedFormula = FormulaItem(
                    title: "Velocity Components",
                    formula: "ux = u cosθ,  uy = u sinθ",
                    explanation:
"""
Initial velocity is divided into two components:

• Horizontal velocity (ux) = u cosθ (constant)
• Vertical velocity (uy) = u sinθ (changes due to gravity)

Important:
• Horizontal velocity remains constant
• Vertical velocity changes with time
"""
                )
            } label: {
                FormulaCard(
                    title: "Velocity Components",
                    formula: "ux = u cosθ,  uy = u sinθ",
                    meaning: "Tap to see full explanation"
                )
            }
            .buttonStyle(.plain)
            
            Button {
                selectedFormula = FormulaItem(
                    title: "Trajectory Equation",
                    formula: "y = x tanθ - (g x²) / (2u² cos²θ)",
                    explanation:
"""
Path followed by projectile (parabolic).

Important:
• Trajectory is always a parabola
• Shows relation between x and y
"""
                )
            } label: {
                FormulaCard(
                    title: "Trajectory Equation",
                    formula: "y = x tanθ - (g x²) / (2u² cos²θ)",
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
