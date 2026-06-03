import SwiftUI
import Combine

struct HookesLawExploreView: View {
    @State private var springConstantK: Double = 30.0 // N/m
    @State private var massM: Double = 3.0           // kg
    @State private var initialDisplacementX: Double = 0.8 // meters (stretched downward)
    
    @State private var displacementX: Double = 0.8
    @State private var velocityV: Double = 0.0
    @State private var isOscillating = false
    
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    // Equilibrium position
    let equilibriumY: CGFloat = 130
    
    var timePeriod: Double {
        2 * .pi * sqrt(massM / springConstantK)
    }
    
    var elasticPE: Double {
        0.5 * springConstantK * displacementX * displacementX
    }
    
    var kineticEnergy: Double {
        0.5 * massM * velocityV * velocityV
    }
    
    var totalEnergy: Double {
        // Total energy at release (where KE is 0 and PE is max)
        0.5 * springConstantK * initialDisplacementX * initialDisplacementX
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Hooke's Law & Oscillation")
                    .font(.largeTitle.bold())
                    .padding(.top)
                
                Text("Hooke's law states that the force needed to extend or compress a spring by some distance x scales linearly with that distance (F = -kx).")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Spring Canvas
                GeometryReader { geo in
                    let centerX = geo.size.width / 2
                    let topY: CGFloat = 20
                    let visualEquilibriumLength: CGFloat = 100
                    let scaleFactor: CGFloat = 40.0 // pixels per meter
                    
                    let currentSpringLength = visualEquilibriumLength + CGFloat(displacementX) * scaleFactor
                    let bottomY = topY + currentSpringLength
                    
                    ZStack {
                        // Background
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.ultraThinMaterial)
                            .background(Color.blue.opacity(0.08))
                        
                        // Pivot Ceiling
                        Rectangle()
                            .fill(Color.primary.opacity(0.7))
                            .frame(width: 100, height: 6)
                            .position(x: centerX, y: topY)
                        
                        // Dynamic Spring coils
                        Path { path in
                            let start = CGPoint(x: centerX, y: topY)
                            path.move(to: start)
                            let loops = 20
                            for i in 0...loops {
                                let progress = CGFloat(i) / CGFloat(loops)
                                let y = topY + progress * currentSpringLength
                                let width: CGFloat = 16
                                let x = centerX + (i % 2 == 0 ? -width : width) * (i == 0 || i == loops ? 0 : 1)
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                        .stroke(Color.primary.opacity(0.85), lineWidth: 3)
                        
                        // Hanging Crate
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.cyan)
                            .frame(width: 44, height: 44)
                            .overlay(
                                Text("\(String(format: "%.1f", massM))k")
                                    .font(.caption2.bold())
                                    .foregroundColor(.white)
                            )
                            .position(x: centerX, y: bottomY + 22)
                        
                        // Force vectors overlay (Restoring force is opposite to displacement)
                        if isOscillating {
                            let restoringForce = -springConstantK * displacementX
                            
                            // Gravity force vector (Always down)
                            HStack(spacing: 0) {
                                Image(systemName: "arrow.down")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.red)
                                Text("Fg")
                                    .font(.caption2.bold())
                                    .foregroundColor(.red)
                            }
                            .position(x: centerX + 50, y: bottomY + 22)
                            
                            // Spring Force vector
                            if abs(restoringForce) > 0.5 {
                                HStack(spacing: 0) {
                                    Image(systemName: restoringForce > 0 ? "arrow.down" : "arrow.up")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.green)
                                    Text("Fs")
                                        .font(.caption2.bold())
                                        .foregroundColor(.green)
                                }
                                .position(x: centerX - 50, y: bottomY + 22)
                            }
                        }
                        
                        // Real-time PE/KE Graph
                        VStack(spacing: 6) {
                            let peRatio = totalEnergy > 0 ? elasticPE / totalEnergy : 0
                            let keRatio = totalEnergy > 0 ? kineticEnergy / totalEnergy : 0
                            
                            HStack {
                                Text("Kinetic Energy (KE)")
                                    .font(.caption2.bold())
                                    .foregroundColor(.green)
                                    .frame(width: 105, alignment: .leading)
                                ProgressView(value: min(keRatio, 1.0))
                                    .tint(.green)
                            }
                            HStack {
                                Text("Elastic PE (U)")
                                    .font(.caption2.bold())
                                    .foregroundColor(.blue)
                                    .frame(width: 105, alignment: .leading)
                                ProgressView(value: min(peRatio, 1.0))
                                    .tint(.blue)
                            }
                        }
                        .padding(10)
                        .background(Color.black.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .frame(width: 250)
                        .position(x: 140, y: geo.size.height - 40)
                    }
                }
                .frame(height: 300)
                .padding(.horizontal)
                
                HStack(spacing: 12) {
                    ExploreResultCard(title: "Time Period (T)", value: String(format: "%.2f s", timePeriod))
                    ExploreResultCard(title: "Elastic PE", value: String(format: "%.2f J", elasticPE))
                    ExploreResultCard(title: "Kinetic Energy", value: String(format: "%.2f J", kineticEnergy))
                }
                .padding(.horizontal)
                
                VStack(spacing: 16) {
                    ExploreControlSlider(title: "Spring Constant (k)", value: $springConstantK, range: 10...70, suffix: " N/m")
                    ExploreControlSlider(title: "Hanging Mass (m)", value: $massM, range: 1...10, suffix: " kg")
                    ExploreControlSlider(title: "Initial Displacement (x)", value: $initialDisplacementX, range: -1.0...1.0, suffix: " m")
                }
                .padding(.horizontal)
                .onChange(of: initialDisplacementX) { _, val in
                    if !isOscillating {
                        displacementX = val
                    }
                }
                
                HStack(spacing: 16) {
                    Button(action: {
                        displacementX = initialDisplacementX
                        velocityV = 0
                        isOscillating = true
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }) {
                        Text("Release Mass")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .font(.headline)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    
                    Button(action: {
                        isOscillating = false
                        displacementX = initialDisplacementX
                        velocityV = 0
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }) {
                        Text("Reset")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.ultraThinMaterial)
                            .foregroundColor(.primary)
                            .font(.headline)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Physics Formulas")
                        .font(.headline)
                    
                    Text("Spring Force: F = -k * x")
                    Text("Potential Energy: U = 0.5 * k * x²")
                    Text("Kinetic Energy: K = 0.5 * m * v²")
                    Text("Time Period: T = 2π * √(m / k)")
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
                    
                    Text("1. When displacement is zero (equilibrium), spring force is zero, velocity is maximum, and energy is 100% kinetic.")
                    Text("2. At peak compression or extension, velocity is zero, and energy is 100% elastic potential energy.")
                    Text("3. Stiffer springs (higher k) pull/push back harder and vibrate at higher frequencies (lower T).")
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
            guard isOscillating else { return }
            
            // F = -kx
            let force = -springConstantK * displacementX
            // a = F / m
            let acc = force / massM
            
            // Standard integration
            let dt = 0.02
            velocityV += acc * dt
            displacementX += velocityV * dt
        }
    }
}
