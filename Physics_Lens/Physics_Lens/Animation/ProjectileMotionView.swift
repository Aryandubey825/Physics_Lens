import SwiftUI
import Combine

struct ProjectileMotionSimulator: View {
    
    @State private var angle: Double = 45
    @State private var velocity: Double = 30
    @State private var gravity: Double = 9.8
    @State private var speedFactor: Double = 1.0
    @State private var airResistance: Bool = false
    
    @State private var time: Double = 0
    @State private var isRunning = false
    @State private var trail: [CGPoint] = []
    
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    @State private var containerWidth: CGFloat = 350
    let origin = CGPoint(x: 30, y: 260)
    
    var scale: CGFloat {
        let u = velocity
        let g = gravity
        let theta = angle * .pi / 180
        
        let physicalMaxHeight = pow(u * sin(theta), 2) / (2 * g)
        let physicalRange = pow(u, 2) * sin(2 * theta) / g
        
        let maxWidth = max(containerWidth - 60, 100)
        let maxHeightPixels: CGFloat = 230
        
        let scaleX = physicalRange > 0 ? maxWidth / CGFloat(physicalRange) : 6
        let scaleY = physicalMaxHeight > 0 ? maxHeightPixels / CGFloat(physicalMaxHeight) : 6
        
        return min(min(scaleX, scaleY), 15.0)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text("Projectile Motion")
                .font(.largeTitle.bold())
            
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.blue.opacity(0.08))
                
               
                Path { path in
                    path.move(to: origin)
                    let duration = (2 * velocity * sin(angle * .pi / 180)) / gravity
                    for t in stride(from: 0.0, to: duration, by: 0.05) {
                        let x = xPosition(t)
                        let y = yPosition(t)
                        path.addLine(to: CGPoint(
                            x: origin.x + x * scale,
                            y: origin.y - y * scale
                        ))
                    }
                    // Add the final landing point exactly
                    let finalX = xPosition(duration)
                    let finalY = yPosition(duration)
                    path.addLine(to: CGPoint(
                        x: origin.x + finalX * scale,
                        y: origin.y - finalY * scale
                    ))
                }
                .stroke(Color.gray, style: StrokeStyle(lineWidth: 2, dash: [6]))
                
                Path { path in
                    path.move(to: origin)
                    path.addLine(to: CGPoint(
                        x: origin.x + 50 * cos(angleRad),
                        y: origin.y - 50 * sin(angleRad)
                    ))
                }
                .stroke(Color.orange, lineWidth: 3)
                
                ForEach(trail.indices, id: \.self) { i in
                    Circle()
                        .fill(Color.blue.opacity(0.4))
                        .frame(width: 4, height: 4)
                        .position(
                            x: origin.x + trail[i].x * scale,
                            y: origin.y - trail[i].y * scale
                        )
                }
                
                Circle()
                    .fill(Color.red)
                    .frame(width: 16, height: 16)
                    .position(projectilePosition)
            }
            .frame(height: 300)
            
            HStack {
                ResultCard(title: "Time", value: "\(timeOfFlight)s")
                ResultCard(title: "Max Height", value: "\(maxHeight)m")
                ResultCard(title: "Range", value: "\(range)m")
            }
            
            VStack(spacing: 12) {
                
                ControlSlider(title: "Angle (°)", value: $angle, range: 10...80)
                ControlSlider(title: "Velocity (m/s)", value: $velocity, range: 10...50)
                ControlSlider(title: "Gravity (m/s²)", value: $gravity, range: 5...15)
                
                Toggle("Air Resistance", isOn: $airResistance)
                
                ControlSlider(title: "Simulation Speed", value: $speedFactor, range: 0.2...1.0)
            }
            
            HStack {
                Button("Launch") {
                    reset()
                    isRunning = true
                }
                .buttonStyle(.borderedProminent)
                
                Button("Reset") {
                    reset()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        containerWidth = geo.size.width
                    }
                    .onChange(of: geo.size.width) { newValue in
                        containerWidth = newValue
                    }
            }
        )
        .onReceive(timer) { _ in
            guard isRunning else { return }
            
            time += 0.02 * speedFactor
            
            let x = xPosition(time)
            let y = yPosition(time)
            
            if y >= 0 {
                trail.append(CGPoint(x: x, y: y))
            } else {
                isRunning = false
            }
        }
    }
    
    var angleRad: CGFloat {
        CGFloat(angle * .pi / 180)
    }
    
    func xPosition(_ t: Double) -> CGFloat {
        let u = velocity * cos(angle * .pi / 180)
        return CGFloat(u * t)
    }
    
    func yPosition(_ t: Double) -> CGFloat {
        let u = velocity * sin(angle * .pi / 180)
        let drag = airResistance ? 0.15 * t : 0
        return CGFloat(u * t - 0.5 * gravity * t * t - drag)
    }
    
    var projectilePosition: CGPoint {
        let x = xPosition(time)
        let y = max(yPosition(time), 0)
        return CGPoint(
            x: origin.x + x * scale,
            y: origin.y - y * scale
        )
    }
    
    var timeOfFlight: String {
        let t = (2 * velocity * sin(angle * .pi / 180)) / gravity
        return String(format: "%.2f", t)
    }
    
    var maxHeight: String {
        let h = pow(velocity * sin(angle * .pi / 180), 2) / (2 * gravity)
        return String(format: "%.2f", h)
    }
    
    var range: String {
        let r = pow(velocity, 2) * sin(2 * angle * .pi / 180) / gravity
        return String(format: "%.2f", r)
    }
    
    func reset() {
        time = 0
        trail.removeAll()
        isRunning = false
    }
}


struct ResultCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.headline.bold())
        }
        .padding()
        .frame(width: 110)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}

struct ControlSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(title): \(String(format: "%.1f", value))")
                .font(.caption)
            Slider(value: $value, in: range)
        }
    }
}

#Preview {
    ProjectileMotionSimulator()
}
