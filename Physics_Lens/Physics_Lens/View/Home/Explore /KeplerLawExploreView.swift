import SwiftUI
import Combine

struct KeplerLawExploreView: View {
    @State private var eccentricity: Double = 0.5   // e
    @State private var orbitSpeed: Double = 0.03    // mean anomaly step
    @State private var showSectors: Bool = true
    
    @State private var meanAnomaly: Double = 0
    @State private var sectors: [OrbitalSector] = []
    
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    // Orbit dimensions
    let semiMajorAxis: Double = 100 // pixels
    var semiMinorAxis: Double {
        semiMajorAxis * sqrt(1.0 - eccentricity * eccentricity)
    }
    var focusOffset: Double {
        semiMajorAxis * eccentricity
    }
    
    // Kepler's equation solver: M = E - e*sin(E)
    func solveKepler(meanAnomaly M: Double, eccentricity e: Double) -> Double {
        var E = M
        for _ in 0..<5 {
            E = E - (E - e * sin(E) - M) / (1.0 - e * cos(E))
        }
        return E
    }
    
    // Planet position relative to ellipse center
    func planetPosition(forE E: Double) -> CGPoint {
        CGPoint(
            x: semiMajorAxis * cos(E),
            y: semiMinorAxis * sin(E)
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Kepler's Second Law")
                    .font(.largeTitle.bold())
                    .padding(.top)
                
                Text("A line segment joining a planet and the Sun sweeps out equal areas during equal intervals of time.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Orbit Canvas
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .background(Color.blue.opacity(0.08))
                        .frame(height: 280)
                    
                    GeometryReader { geo in
                        let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
                        let sunPos = CGPoint(x: center.x + CGFloat(focusOffset), y: center.y)
                        
                        // Draw Elliptical Orbit Path
                        Path { path in
                            for angle in stride(from: 0.0, through: 2.0 * .pi + 0.1, by: 0.05) {
                                let x = center.x + CGFloat(semiMajorAxis * cos(angle))
                                let y = center.y + CGFloat(semiMinorAxis * sin(angle))
                                if angle == 0 {
                                    path.move(to: CGPoint(x: x, y: y))
                                } else {
                                    path.addLine(to: CGPoint(x: x, y: y))
                                }
                            }
                        }
                        .stroke(Color.primary.opacity(0.3), style: StrokeStyle(lineWidth: 1.5, dash: [4]))
                        
                        // Draw Sun (Focus)
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [.yellow, .orange, .red],
                                    center: .center,
                                    startRadius: 2,
                                    endRadius: 15
                                )
                            )
                            .frame(width: 24, height: 24)
                            .position(sunPos)
                            .shadow(color: .orange, radius: 10)
                        
                        // Draw Swept Sectors
                        if showSectors {
                            ForEach(sectors) { sector in
                                Path { path in
                                    path.move(to: sunPos)
                                    // Sweep arc
                                    for E in stride(from: sector.startE, through: sector.endE, by: 0.02) {
                                        let pos = planetPosition(forE: E)
                                        path.addLine(to: CGPoint(x: center.x + pos.x, y: center.y + pos.y))
                                    }
                                    let finalPos = planetPosition(forE: sector.endE)
                                    path.addLine(to: CGPoint(x: center.x + finalPos.x, y: center.y + finalPos.y))
                                    path.closeSubpath()
                                }
                                .fill(Color.blue.opacity(0.25))
                            }
                        }
                        
                        // Current Planet
                        let E = solveKepler(meanAnomaly: meanAnomaly, eccentricity: eccentricity)
                        let currentPos = planetPosition(forE: E)
                        let absolutePlanetPos = CGPoint(x: center.x + currentPos.x, y: center.y + currentPos.y)
                        
                        // Radius Vector (Sun to Planet)
                        Path { path in
                            path.move(to: sunPos)
                            path.addLine(to: absolutePlanetPos)
                        }
                        .stroke(Color.orange, lineWidth: 1.5)
                        
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [.cyan, .blue, .black],
                                    center: .init(x: 0.3, y: 0.3),
                                    startRadius: 1,
                                    endRadius: 10
                                )
                            )
                            .frame(width: 16, height: 16)
                            .position(absolutePlanetPos)
                        
                        // Label annotations
                        Text("Aphelion (Slower)")
                            .font(.caption2.bold())
                            .foregroundColor(.secondary)
                            .position(x: center.x - CGFloat(semiMajorAxis) - 20, y: center.y + 20)
                        
                        Text("Perihelion (Faster)")
                            .font(.caption2.bold())
                            .foregroundColor(.secondary)
                            .position(x: center.x + CGFloat(semiMajorAxis) + 20, y: center.y + 20)
                    }
                }
                .frame(height: 280)
                .padding(.horizontal)
                
                HStack(spacing: 16) {
                    Toggle(isOn: $showSectors) {
                        Text("Show Equal Area Sectors")
                            .font(.headline)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .padding(.horizontal)
                
                VStack(spacing: 16) {
                    ExploreControlSlider(title: "Orbit Eccentricity (e)", value: $eccentricity, range: 0.0...0.8, suffix: "")
                    ExploreControlSlider(title: "Simulation Speed", value: $orbitSpeed, range: 0.01...0.06, suffix: "")
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Physics Formulation")
                        .font(.headline)
                    
                    Text("dA / dt = L / (2 * m) = Constant")
                        .font(.system(.title3, design: .monospaced))
                        .foregroundColor(.blue)
                        .padding(.vertical, 4)
                    
                    Text("Kepler's Equation: M = E - e * sin(E)")
                        .font(.system(.subheadline, design: .monospaced))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Concept Insight")
                        .font(.headline)
                    
                    Text("1. When a planet is near the Sun (Perihelion), the distance r is small, so its orbital velocity must be high to keep area sweep rate constant.")
                    Text("2. When far from the Sun (Aphelion), velocity is at its minimum.")
                    Text("3. This law is a direct consequence of the Conservation of Angular Momentum (since gravity is a central force, torque is zero).")
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
            meanAnomaly += orbitSpeed
            
            // Generate sectors to visualize equal areas
            if showSectors {
                let step: Double = 0.4 // Mean anomaly slice width
                
                var newSectors: [OrbitalSector] = []
                for i in 0..<5 {
                    let startM = Double(i) * (2.0 * .pi / 5.0)
                    let endM = startM + step
                    
                    let startE = solveKepler(meanAnomaly: startM, eccentricity: eccentricity)
                    let endE = solveKepler(meanAnomaly: endM, eccentricity: eccentricity)
                    
                    newSectors.append(OrbitalSector(startE: startE, endE: endE))
                }
                sectors = newSectors
            }
        }
    }
}

struct OrbitalSector: Identifiable {
    let id = UUID()
    let startE: Double
    let endE: Double
}
