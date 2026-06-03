import SwiftUI
import Combine

struct GasKineticTheoryExploreView: View {
    @State private var temperature: Double = 300.0   // Kelvin
    @State private var containerVolume: Double = 1.0  // Relative units
    
    @State private var gasParticles: [GasParticle] = []
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    // Ideal Gas Law calculations
    // P = nRT/V. Let nR = 0.5.
    var pressure: Double {
        let nR = 0.6
        return (nR * temperature) / containerVolume
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Kinetic Theory of Gases")
                    .font(.largeTitle.bold())
                    .padding(.top)
                
                Text("Gas pressure arises from the constant, random collisions of molecules with the container walls. Pressure is proportional to Temperature and inversely proportional to Volume.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Gas Box Canvas
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .background(Color.blue.opacity(0.08))
                        .frame(height: 250)
                    
                    GeometryReader { geo in
                        let h = geo.size.height
                        
                        // Volume directly affects container width
                        let maxBoxWidth = geo.size.width - 40
                        let currentBoxWidth = 100 + CGFloat(containerVolume) * (maxBoxWidth - 100)
                        
                        // Main Gas Chamber
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.primary.opacity(0.7), lineWidth: 4)
                            .background(Color.black.opacity(0.05))
                            .frame(width: currentBoxWidth, height: 180)
                            .position(x: currentBoxWidth / 2 + 20, y: h / 2)
                        
                        // Piston handle showing compression
                        Rectangle()
                            .fill(Color.secondary.opacity(0.8))
                            .frame(width: 8, height: 120)
                            .position(x: currentBoxWidth + 20, y: h / 2)
                        
                        // Molecules
                        ForEach(gasParticles) { particle in
                            Circle()
                                .fill(particle.color)
                                .frame(width: 8, height: 8)
                                .position(
                                    x: 20 + particle.x * (currentBoxWidth - 16),
                                    y: (h - 180)/2 + 8 + particle.y * 164
                                )
                        }
                    }
                }
                .frame(height: 250)
                .padding(.horizontal)
                
                HStack(spacing: 12) {
                    ExploreResultCard(title: "Temperature (T)", value: String(format: "%.0f K", temperature))
                    ExploreResultCard(title: "Volume (V)", value: String(format: "%.2f L", containerVolume))
                    ExploreResultCard(title: "Pressure (P)", value: String(format: "%.1f kPa", pressure))
                }
                .padding(.horizontal)
                
                VStack(spacing: 16) {
                    ExploreControlSlider(title: "Gas Temperature", value: $temperature, range: 100...600, suffix: " K")
                    ExploreControlSlider(title: "Chamber Volume", value: $containerVolume, range: 0.3...1.0, suffix: "")
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Gas Law Formulas")
                        .font(.headline)
                    
                    Text("Ideal Gas Law: P * V = n * R * T")
                    Text("Pressure: P = nRT / V")
                    Text("RMS Molecular Speed: v_rms = √(3RT / M)")
                    Text("RMS speed scales as √(T). Higher T = faster particles.")
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
                    
                    Text("1. Boyle's Law (Constant T): Decreasing volume crowds the molecules, increasing the frequency of wall collisions, which increases pressure.")
                    Text("2. Charles's Law (Constant P): Increasing temperature causes molecules to move faster and hit walls harder; if volume is free, it must expand to keep pressure constant.")
                    Text("3. Pressure is a macroscopic property representing the average impulse per unit area delivered by millions of microscopic molecular collisions.")
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
        .onAppear {
            generateParticles()
        }
        .onReceive(timer) { _ in
            // RMS speed scales with sqrt(T)
            let speedFactor = sqrt(temperature / 300.0) * 0.015
            
            for i in gasParticles.indices {
                // Update position
                gasParticles[i].x += gasParticles[i].vx * CGFloat(speedFactor)
                gasParticles[i].y += gasParticles[i].vy * CGFloat(speedFactor)
                
                // Bounce x boundaries (0 to 1)
                if gasParticles[i].x < 0 {
                    gasParticles[i].x = 0
                    gasParticles[i].vx *= -1
                } else if gasParticles[i].x > 1 {
                    gasParticles[i].x = 1
                    gasParticles[i].vx *= -1
                }
                
                // Bounce y boundaries (0 to 1)
                if gasParticles[i].y < 0 {
                    gasParticles[i].y = 0
                    gasParticles[i].vy *= -1
                } else if gasParticles[i].y > 1 {
                    gasParticles[i].y = 1
                    gasParticles[i].vy *= -1
                }
            }
        }
    }
    
    func generateParticles() {
        var temp: [GasParticle] = []
        let colors: [Color] = [.red, .orange, .blue, .purple, .green]
        for _ in 0..<24 {
            let angle = Double.random(in: 0...(2.0 * .pi))
            temp.append(GasParticle(
                x: CGFloat.random(in: 0.1...0.9),
                y: CGFloat.random(in: 0.1...0.9),
                vx: CGFloat(cos(angle)),
                vy: CGFloat(sin(angle)),
                color: colors.randomElement() ?? .red
            ))
        }
        gasParticles = temp
    }
}

struct GasParticle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var vx: CGFloat
    var vy: CGFloat
    let color: Color
}
