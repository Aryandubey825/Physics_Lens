import SwiftUI
import Combine

struct BernoulliExploreView: View {
    @State private var inletVelocity: Double = 3.0    // m/s
    @State private var constrictionRatio: Double = 0.5 // narrowing factor
    
    @State private var particles: [FluidParticle] = []
    @State private var canvasWidth: CGFloat = 400.0
    
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    // Constants
    let referencePressureP1: Double = 120.0 // kPa
    let densityRho: Double = 1000.0        // kg/m³ (water)
    
    var outletVelocityV2: Double {
        inletVelocity / (1.0 - constrictionRatio)
    }
    
    var pressureP2: Double {
        // P2 = P1 - 0.5 * rho * (v2^2 - v1^2) / 1000 (to kPa)
        let diff = 0.5 * densityRho * (outletVelocityV2 * outletVelocityV2 - inletVelocity * inletVelocity) / 1000.0
        return max(5.0, referencePressureP1 - diff)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Bernoulli's Principle")
                    .font(.largeTitle.bold())
                    .padding(.top)
                
                Text("As the speed of a moving fluid increases, the pressure within that fluid decreases (Venturi Effect).")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Fluid Venturi Tube Canvas
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .background(Color.blue.opacity(0.08))
                        .frame(height: 260)
                    
                    GeometryReader { geo in
                        let w = geo.size.width
                        let h = geo.size.height
                        let centerY = h / 2
                        
                        // Draw Pipe Borders
                        Path { path in
                            // Top boundary
                            path.move(to: CGPoint(x: 10, y: centerY - 60))
                            path.addCurve(
                                to: CGPoint(x: w / 2, y: centerY - 60 * CGFloat(1.0 - constrictionRatio)),
                                control1: CGPoint(x: w * 0.3, y: centerY - 60),
                                control2: CGPoint(x: w * 0.4, y: centerY - 60 * CGFloat(1.0 - constrictionRatio))
                            )
                            path.addCurve(
                                to: CGPoint(x: w - 10, y: centerY - 60),
                                control1: CGPoint(x: w * 0.6, y: centerY - 60 * CGFloat(1.0 - constrictionRatio)),
                                control2: CGPoint(x: w * 0.7, y: centerY - 60)
                            )
                            
                            // Right opening
                            path.addLine(to: CGPoint(x: w - 10, y: centerY + 60))
                            
                            // Bottom boundary
                            path.addCurve(
                                to: CGPoint(x: w / 2, y: centerY + 60 * CGFloat(1.0 - constrictionRatio)),
                                control1: CGPoint(x: w * 0.7, y: centerY + 60),
                                control2: CGPoint(x: w * 0.6, y: centerY + 60 * CGFloat(1.0 - constrictionRatio))
                            )
                            path.addCurve(
                                to: CGPoint(x: 10, y: centerY + 60),
                                control1: CGPoint(x: w * 0.4, y: centerY + 60 * CGFloat(1.0 - constrictionRatio)),
                                control2: CGPoint(x: w * 0.3, y: centerY + 60)
                            )
                            path.closeSubpath()
                        }
                        .fill(Color.blue.opacity(0.12))
                        .overlay(
                            Path { path in
                                // Just draw top and bottom borders as lines
                                path.move(to: CGPoint(x: 10, y: centerY - 60))
                                path.addCurve(
                                    to: CGPoint(x: w / 2, y: centerY - 60 * CGFloat(1.0 - constrictionRatio)),
                                    control1: CGPoint(x: w * 0.3, y: centerY - 60),
                                    control2: CGPoint(x: w * 0.4, y: centerY - 60 * CGFloat(1.0 - constrictionRatio))
                                )
                                path.addCurve(
                                    to: CGPoint(x: w - 10, y: centerY - 60),
                                    control1: CGPoint(x: w * 0.6, y: centerY - 60 * CGFloat(1.0 - constrictionRatio)),
                                    control2: CGPoint(x: w * 0.7, y: centerY - 60)
                                )
                                
                                path.move(to: CGPoint(x: 10, y: centerY + 60))
                                path.addCurve(
                                    to: CGPoint(x: w / 2, y: centerY + 60 * CGFloat(1.0 - constrictionRatio)),
                                    control1: CGPoint(x: w * 0.3, y: centerY + 60),
                                    control2: CGPoint(x: w * 0.4, y: centerY + 60 * CGFloat(1.0 - constrictionRatio))
                                )
                                path.addCurve(
                                    to: CGPoint(x: w - 10, y: centerY + 60),
                                    control1: CGPoint(x: w * 0.6, y: centerY + 60 * CGFloat(1.0 - constrictionRatio)),
                                    control2: CGPoint(x: w * 0.7, y: centerY + 60)
                                )
                            }
                            .stroke(Color.blue.opacity(0.4), lineWidth: 2)
                        )
                        
                        // Draw vertical pressure indicators (Manometer Tubes)
                        // Column 1 (Left Wide Section)
                        let colH1 = CGFloat(referencePressureP1 / 150.0) * 45
                        Rectangle()
                            .fill(Color.blue.opacity(0.45))
                            .frame(width: 14, height: colH1)
                            .position(x: w * 0.25, y: centerY - 60 - colH1 / 2)
                        Rectangle()
                            .stroke(Color.primary.opacity(0.4), lineWidth: 1.5)
                            .frame(width: 14, height: 50)
                            .position(x: w * 0.25, y: centerY - 60 - 25)
                        
                        // Column 1 Graduation Ticks
                        Path { path in
                            for step in stride(from: 10, through: 40, by: 10) {
                                let yPos = centerY - 60 - CGFloat(step)
                                path.move(to: CGPoint(x: w * 0.25 - 4, y: yPos))
                                path.addLine(to: CGPoint(x: w * 0.25 + 4, y: yPos))
                            }
                        }
                        .stroke(Color.primary.opacity(0.45), lineWidth: 1)
                        
                        // Column 1 Label
                        VStack(spacing: 2) {
                            Text("Wide Section")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(.secondary)
                            Text("P1: \(String(format: "%.1f", referencePressureP1)) kPa")
                                .font(.system(size: 9, weight: .black, design: .monospaced))
                                .foregroundColor(.blue)
                        }
                        .padding(4)
                        .background(Color(.systemBackground).opacity(0.85))
                        .cornerRadius(4)
                        .position(x: w * 0.25, y: centerY - 60 - 62)
                        
                        // Column 2 (Narrow Middle Section)
                        let colH2 = CGFloat(pressureP2 / 150.0) * 45
                        let narrowPipeTopY = centerY - 60 * CGFloat(1.0 - constrictionRatio)
                        Rectangle()
                            .fill(Color.blue.opacity(0.45))
                            .frame(width: 14, height: colH2)
                            .position(x: w / 2, y: narrowPipeTopY - colH2 / 2)
                        Rectangle()
                            .stroke(Color.primary.opacity(0.4), lineWidth: 1.5)
                            .frame(width: 14, height: 50)
                            .position(x: w / 2, y: narrowPipeTopY - 25)
                        
                        // Column 2 Graduation Ticks
                        Path { path in
                            for step in stride(from: 10, through: 40, by: 10) {
                                let yPos = narrowPipeTopY - CGFloat(step)
                                path.move(to: CGPoint(x: w / 2 - 4, y: yPos))
                                path.addLine(to: CGPoint(x: w / 2 + 4, y: yPos))
                            }
                        }
                        .stroke(Color.primary.opacity(0.45), lineWidth: 1)
                        
                        // Column 2 Label
                        VStack(spacing: 2) {
                            Text("Narrow Section")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(.secondary)
                            Text("P2: \(String(format: "%.1f", pressureP2)) kPa")
                                .font(.system(size: 9, weight: .black, design: .monospaced))
                                .foregroundColor(pressureP2 < 60 ? .red : .orange)
                        }
                        .padding(4)
                        .background(Color(.systemBackground).opacity(0.85))
                        .cornerRadius(4)
                        .position(x: w / 2, y: narrowPipeTopY - 62)
                        
                        // Draw Particles (Guaranteed inside the boundary)
                        ForEach(particles) { particle in
                            let localConstriction = constrictionRatio * constrictionEffect(atX: particle.x, totalW: w)
                            let localHalfHeight = 60.0 * (1.0 - localConstriction)
                            let particleY = centerY + particle.verticalFraction * CGFloat(localHalfHeight)
                            
                            Circle()
                                .fill(Color.blue.opacity(0.75))
                                .frame(width: 6, height: 6)
                                .position(x: particle.x, y: particleY)
                        }
                        
                        Color.clear
                            .onAppear {
                                canvasWidth = w
                                generateParticles(width: w)
                            }
                            .onChange(of: w) { _, newW in
                                canvasWidth = newW
                            }
                    }
                }
                .frame(height: 260)
                .padding(.horizontal)
                
                HStack(spacing: 12) {
                    ExploreResultCard(title: "Inlet Speed (v1)", value: String(format: "%.1f m/s", inletVelocity))
                    ExploreResultCard(title: "Mid Speed (v2)", value: String(format: "%.1f m/s", outletVelocityV2))
                }
                .padding(.horizontal)
                
                HStack(spacing: 12) {
                    ExploreResultCard(title: "Inlet Pressure (P1)", value: String(format: "%.1f kPa", referencePressureP1))
                    ExploreResultCard(title: "Mid Pressure (P2)", value: String(format: "%.1f kPa", pressureP2))
                }
                .padding(.horizontal)
                
                VStack(spacing: 16) {
                    ExploreControlSlider(title: "Fluid Inlet Velocity", value: $inletVelocity, range: 1.0...5.0, suffix: " m/s")
                    ExploreControlSlider(title: "Constriction Narrowing", value: $constrictionRatio, range: 0.1...0.7, suffix: "")
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Physics Equations")
                        .font(.headline)
                    
                    Text("Equation of Continuity: A1 * v1 = A2 * v2")
                    Text("Bernoulli's Equation:")
                    Text("P1 + ½ ρ v1² = P2 + ½ ρ v2²")
                    Text("where ρ (density of water) = 1000 kg/m³")
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
                    
                    Text("1. When fluid flows from a wider channel to a narrower channel, the mass flow rate must stay constant. Consequently, the fluid velocity increases (Continuity Equation).")
                    Text("2. The increased velocity represents higher kinetic energy. To conserve energy, this requires a drop in pressure potential energy (Bernoulli's Principle).")
                    Text("3. This pressure differential is why carburetor nozzles, airplanes (wing lift), and Venturi tubes work.")
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
        .onReceive(timer) { _ in
            let w = canvasWidth
            
            for i in particles.indices {
                let x = particles[i].x
                let effect = constrictionEffect(atX: x, totalW: w)
                let widthRatio = 1.0 - constrictionRatio * effect
                let speedMultiplier = 1.0 / widthRatio
                
                particles[i].x += CGFloat(inletVelocity * speedMultiplier * 1.2)
                
                // Recycle particles when they exit the canvas boundary
                if particles[i].x > w + 10 {
                    particles[i].x = -10
                    particles[i].verticalFraction = CGFloat.random(in: -0.8...0.8)
                }
            }
        }
    }
    
    func constrictionEffect(atX x: CGFloat, totalW w: CGFloat) -> Double {
        // Gaussian bell curve centered at w/2
        let mu = w / 2
        let sigma = w * 0.15
        let diff = x - mu
        return exp(-Double(diff * diff) / Double(2.0 * sigma * sigma))
    }
    
    func generateParticles(width: CGFloat) {
        var temp: [FluidParticle] = []
        for _ in 0..<45 {
            temp.append(FluidParticle(
                x: CGFloat.random(in: 0...width),
                verticalFraction: CGFloat.random(in: -0.8...0.8)
            ))
        }
        particles = temp
    }
}

struct FluidParticle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var verticalFraction: CGFloat
}
