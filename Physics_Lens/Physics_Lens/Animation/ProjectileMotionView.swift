import SwiftUI


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
    
    let scale: CGFloat = 6
    let origin = CGPoint(x: 30, y: 260)
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text("Projectile Motion")
                .font(.largeTitle.bold())
            
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.blue.opacity(0.08))
                
               
                Path { path in
                    path.move(to: origin)
                    for t in stride(from: 0.0, to: 5.0, by: 0.05) {
                        let x = xPosition(t)
                        let y = yPosition(t)
                        if y >= 0 {
                            path.addLine(to: CGPoint(
                                x: origin.x + x * scale,
                                y: origin.y - y * scale
                            ))
                        }
                    }
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
                        .position(trail[i])
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
        .onReceive(timer) { _ in
            guard isRunning else { return }
            
            time += 0.02 * speedFactor
            
            let x = origin.x + xPosition(time) * scale
            let y = origin.y - yPosition(time) * scale
            
            if y <= origin.y {
                trail.append(CGPoint(x: x, y: y))
            }
            
            if y > origin.y {
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
        let x = origin.x + xPosition(time) * scale
        let y = origin.y - yPosition(time) * scale
        return CGPoint(x: x, y: y)
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
