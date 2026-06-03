import SwiftUI
import Combine

struct PendulumExploreView: View {
    @State private var length: Double = 1.5      // meters
    @State private var gravity: Double = 9.8     // m/s²
    @State private var maxAngleDegrees: Double = 30.0 // initial amplitude
    
    var timePeriod: Double {
        2 * .pi * sqrt(length / gravity)
    }
    
    var frequency: Double {
        1.0 / timePeriod
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Simple Pendulum")
                    .font(.largeTitle.bold())
                    .padding(.top)
                
                Text("A mass suspended from a pivot that swings freely. It oscillates in simple harmonic motion for small angles.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Swing Canvas
                GeometryReader { geo in
                    TimelineView(.animation) { timeline in
                        let time = timeline.date.timeIntervalSinceReferenceDate
                        let omega = (2 * .pi) / timePeriod
                        let maxAngleRad = maxAngleDegrees * .pi / 180.0
                        
                        let currentAngle = maxAngleRad * sin(time * omega)
                        
                        let centerX = geo.size.width / 2
                        let topY: CGFloat = 30
                        
                        // Scale length visually to fit the box
                        let visualLength = CGFloat(length * 80)
                        let bobX = centerX + sin(currentAngle) * visualLength
                        let bobY = topY + cos(currentAngle) * visualLength
                        
                        // Physics values
                        let currentHeight = length * (1 - cos(currentAngle))
                        let maxHeight = length * (1 - cos(maxAngleRad))
                        let totalEnergy = gravity * maxHeight
                        let potentialEnergy = gravity * currentHeight
                        let kineticEnergy = max(0, totalEnergy - potentialEnergy)
                        
                        let peRatio = totalEnergy > 0 ? potentialEnergy / totalEnergy : 0
                        let keRatio = totalEnergy > 0 ? kineticEnergy / totalEnergy : 0
                        
                        ZStack {
                            // Background
                            RoundedRectangle(cornerRadius: 24)
                                .fill(.ultraThinMaterial)
                                .background(Color.blue.opacity(0.08))
                            
                            // Pivot Point & Stand
                            Rectangle()
                                .fill(.secondary.opacity(0.8))
                                .frame(width: 80, height: 6)
                                .position(x: centerX, y: topY)
                            
                            // Wire
                            Path { path in
                                path.move(to: CGPoint(x: centerX, y: topY))
                                path.addLine(to: CGPoint(x: bobX, y: bobY))
                            }
                            .stroke(Color.primary.opacity(0.8), lineWidth: 2)
                            
                            // Metallic Bob (Circle)
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [.white, .red, .black],
                                        center: .init(x: 0.3, y: 0.3),
                                        startRadius: 2,
                                        endRadius: 20
                                    )
                                )
                                .frame(width: 32, height: 32)
                                .position(x: bobX, y: bobY)
                            
                            // Energy Bar Overlay
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("Kinetic Energy (KE)")
                                        .font(.caption2.bold())
                                        .frame(width: 110, alignment: .leading)
                                    ProgressView(value: keRatio)
                                        .tint(.green)
                                }
                                HStack {
                                    Text("Potential Energy (PE)")
                                        .font(.caption2.bold())
                                        .frame(width: 110, alignment: .leading)
                                    ProgressView(value: peRatio)
                                        .tint(.blue)
                                }
                            }
                            .padding(12)
                            .background(Color.black.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .frame(width: 260)
                            .position(x: 145, y: geo.size.height - 45)
                        }
                    }
                }
                .frame(height: 280)
                .padding(.horizontal)
                
                HStack(spacing: 12) {
                    ExploreResultCard(title: "Time Period (T)", value: String(format: "%.2f s", timePeriod))
                    ExploreResultCard(title: "Frequency (f)", value: String(format: "%.2f Hz", frequency))
                    ExploreResultCard(title: "Max Height (h)", value: String(format: "%.3f m", length * (1 - cos(maxAngleDegrees * .pi / 180.0))))
                }
                .padding(.horizontal)
                
                VStack(spacing: 16) {
                    ExploreControlSlider(title: "Pendulum Length", value: $length, range: 0.5...2.5, suffix: " m")
                    ExploreControlSlider(title: "Gravity Strength", value: $gravity, range: 1.0...25.0, suffix: " m/s²")
                    ExploreControlSlider(title: "Release Angle", value: $maxAngleDegrees, range: 5...60, suffix: "°")
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Physics Formulas")
                        .font(.headline)
                    
                    Text("Time Period: T = 2π * √(L / g)")
                    Text("Frequency: f = 1 / T")
                    Text("Total Energy: E = m * g * h_max")
                }
                .font(.system(.subheadline, design: .monospaced))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Concept Insight")
                        .font(.headline)
                    
                    Text("1. The Time Period is independent of the mass of the bob (Galileo's discovery).")
                    Text("2. For longer strings, the pendulum takes longer to complete one oscillation.")
                    Text("3. As it swings, total mechanical energy (KE + PE) is conserved. Kinetic energy peaks at the equilibrium position (bottom), and potential energy peaks at the amplitudes (ends).")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
    }
}
