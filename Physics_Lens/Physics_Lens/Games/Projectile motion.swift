import SwiftUI
import AVFoundation

@available(iOS 26.0, *)
struct projectileGame: View {
    @StateObject private var voiceManager = VoiceAssistantManager()
    
    @State private var showBoard = false
    
    @State private var angle: Double = 45
    @State private var speed: Double = 40
    @State private var rotation: Double = 0
    
    @State private var time: Double = 0
    @State private var xPosition: Double = 0
    @State private var yPosition: Double = 0
    
    @State private var trajectoryPoints: [CGPoint] = []
    @State private var timer: Timer?
    @State private var isLaunched = false
    
    @State private var selectedGravity = 9.8
    
    @State private var score: Int = 0
    @State private var targetDistance: Double = Double.random(in: 60...140)
    
    @State private var showPopup = false
    @State private var hitSuccess = false
    
    @State private var showHint = false
    
    @State private var lockAngle = false
    @State private var lockSpeed = false
    
    let visualScale: Double = 3
    
    var body: some View {
        ZStack {
            // Unified Immersive Background
            LinearGradient(
                colors: [Color(red: 0.90, green: 0.93, blue: 0.97), Color(red: 0.96, green: 0.97, blue: 0.98)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            PhysicsDoodleWallpaper()
                .opacity(0.06)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Projectile Motion")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(.top, 15)
                    .padding(.bottom, 10)
                
                GeometryReader { geometry in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 18) {
                            ZStack {
                                LinearGradient(
                                    colors: [.black, .blue.opacity(0.8)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .ignoresSafeArea()
                                
                                ForEach(0..<60, id: \.self) { _ in
                                    Circle()
                                        .fill(Color.white.opacity(Double.random(in: 0.4...0.9)))
                                        .frame(width: CGFloat.random(in: 2...3))
                                        .position(
                                            x: CGFloat.random(in: 0...800),
                                            y: CGFloat.random(in: 0...250)
                                        )
                                }
                                
                                let targetScreenX = 50 + targetDistance * visualScale
                                
                                if !isLaunched {
                                    Path { path in
                                        let points = predictedPoints()
                                        guard points.count > 1 else { return }
                                        path.move(to: points[0])
                                        for p in points { path.addLine(to: p) }
                                    }
                                    .stroke(Color.white.opacity(0.5),
                                            style: StrokeStyle(lineWidth: 2, dash: [6,6]))
                                }
                                
                                Path { path in
                                    guard trajectoryPoints.count > 1 else { return }
                                    path.move(to: trajectoryPoints[0])
                                    for p in trajectoryPoints { path.addLine(to: p) }
                                }
                                .stroke(Color.white, lineWidth: 2)
                                
                                Image("target")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .position(x: targetScreenX, y: 335)
                                
                                Image("moon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .shadow(color: .white.opacity(0.6), radius: 20)
                                    .position(x: 400, y: 100)
                                
                                Image("tree")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 180)
                                    .position(x: 550, y: 315)
                                
                                Image("ball")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .rotationEffect(.degrees(rotation))
                                    .position(x: 50 + xPosition,
                                              y: 350 - yPosition)
                                
                                VStack {
                                    HStack {
                                        Text("Score: \(score)")
                                            .foregroundColor(.primary)
                                            .padding(.leading)
                                        
                                        Spacer()
                                        
                                        Button {
                                            voiceManager.speakProjectileQuestion(
                                                angle: angle,
                                                range: targetDistance,
                                                gravity: selectedGravity,
                                                lockAngle: lockAngle,
                                                lockSpeed: lockSpeed
                                            )
                                        } label: {
                                            Image(systemName: "speaker.wave.2.fill")
                                                .font(.title3)
                                                .padding(10)
                                                .background(.ultraThinMaterial)
                                                .clipShape(Circle())
                                        }
                                        .padding(.trailing)
                                    }
                                    .padding(.top, 20)
                                    
                                    Spacer()
                                }
                                
                                VStack {
                                    Spacer()
                                    Rectangle()
                                        .fill(Color.green)
                                        .frame(height: 80)
                                }
                            }
                            .frame(height: 450)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                            .padding(.horizontal)
                            
                            VStack(spacing: 15) {
                                Text("Target Range: \(String(format: "%.1f", targetDistance)) m")
                                
                                VStack {
                                    if lockAngle {
                                        Text("Angle Locked 🔒 at \(Int(angle))°")
                                            .foregroundColor(.red)
                                            .bold()
                                    } else {
                                        Text("Angle: \(Int(angle))°")
                                    }
                                    
                                    Slider(value: $angle, in: 0...90)
                                        .disabled(lockAngle)
                                }
                                
                                VStack {
                                    if lockSpeed {
                                        Text("Speed Locked 🔒 at \(Int(speed)) m/s")
                                            .foregroundColor(.red)
                                            .bold()
                                    } else {
                                        Text("Speed: \(Int(speed)) m/s")
                                    }
                                    
                                    Slider(value: $speed, in: 0...100)
                                        .disabled(lockSpeed)
                                }
                                
                                Picker("Gravity", selection: $selectedGravity) {
                                    Text("Earth").tag(9.8)
                                    Text("Moon").tag(1.6)
                                    Text("Mars").tag(3.7)
                                }
                                .pickerStyle(.segmented)
                                
                                Button(action: { launch() }) {
                                    Text("Launch")
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                }
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                
                                Button(action: {
                                    showHint.toggle()
                                }) {
                                    Text("💡 Hint & Gravity Info")
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                }
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                            .padding(.horizontal)
                            
                            RoughBoardButtonCard {
                                showBoard = true
                            }
                            .padding(.horizontal)
                        }
                        .frame(minHeight: geometry.size.height)
                    }
                }
            }
        }
        .sheet(isPresented: $showBoard) {
            RoughBoardView()
        }
        .overlay(
            ZStack {
                popupOverlay
                hintOverlay
            }
        )
        .onAppear {
            nextRound()
        }
    }
    
    var hintOverlay: some View {
        Group {
            if showHint {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showHint = false
                    }
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 10) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.yellow)
                            .font(.title3)
                        Text("Solver Hint & Gravity Info")
                            .font(.title3.bold())
                            .foregroundColor(.primary)
                        Spacer()
                        Button {
                            showHint = false
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                                .font(.title3)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    Divider()
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("🌌 Planetary Gravity Reference (g):")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("• 🌍 Earth Gravity: 9.8 m/s²")
                                    Text("• 🌙 Moon Gravity: 1.6 m/s²")
                                    Text("• 🔴 Mars Gravity: 3.7 m/s²")
                                }
                                .font(.body)
                                .foregroundColor(.primary)
                            }
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("🎯 Solve Guide:")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                
                                Text("Target Distance: \(String(format: "%.1f", targetDistance)) m")
                                    .font(.body)
                                Text("Current Gravity (g): \(selectedGravity) m/s²")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .padding(.bottom, 4)
                                
                                if lockAngle {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Angle (θ) is locked at \(Int(angle))°.")
                                            .font(.body.bold())
                                            .foregroundColor(.red)
                                        Text("Find launch speed (u) using:")
                                            .font(.subheadline)
                                        Text("u = √((Target Distance × g) / sin(2θ))")
                                            .font(.system(.body, design: .monospaced))
                                            .bold()
                                            .padding(12)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.blue.opacity(0.08))
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.blue.opacity(0.15), lineWidth: 1)
                                            )
                                    }
                                } else if lockSpeed {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Speed (u) is locked at \(Int(speed)) m/s.")
                                            .font(.body.bold())
                                            .foregroundColor(.red)
                                        Text("Find launch angle (θ) using:")
                                            .font(.subheadline)
                                        Text("sin(2θ) = (Target Distance × g) / u²")
                                            .font(.system(.body, design: .monospaced))
                                            .bold()
                                            .padding(12)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.blue.opacity(0.08))
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.blue.opacity(0.15), lineWidth: 1)
                                            )
                                    }
                                } else {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Angle and Speed are both adjustable.")
                                            .font(.body)
                                        Text("Tip: Use 45° angle for maximum range!")
                                            .font(.body.bold())
                                            .foregroundColor(.green)
                                        Text("u = √(Target Distance × g)")
                                            .font(.system(.body, design: .monospaced))
                                            .bold()
                                            .padding(12)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.blue.opacity(0.08))
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.blue.opacity(0.15), lineWidth: 1)
                                            )
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 380)
                    
                    Divider()
                    
                    Button {
                        showHint = false
                    } label: {
                        Text("Got it!")
                            .font(.headline.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }
                    .buttonStyle(.plain)
                }
                .padding(24)
                .frame(maxWidth: 420)
                .background(Color(.systemBackground))
                .cornerRadius(24)
                .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 24)
            }
        }
    }
    
    var popupOverlay: some View {
        ZStack {
            if showPopup {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                VStack(spacing: 20) {
                    // Status Badge Icon
                    let statusColor: Color = hitSuccess ? .green : .red
                    let statusIcon: String = hitSuccess ? "checkmark.seal.fill" : "xmark.seal.fill"
                    let statusTitle = hitSuccess ? "Perfect Hit!" : "Target Missed"
                    
                    VStack(spacing: 8) {
                        Image(systemName: statusIcon)
                            .font(.system(size: 48))
                            .foregroundColor(statusColor)
                            .shadow(color: statusColor.opacity(0.3), radius: 8, x: 0, y: 4)
                        
                        Text(statusTitle)
                            .font(.system(.title2, design: .rounded).bold())
                            .foregroundColor(.primary)
                    }
                    .padding(.top, 8)
                    
                    // Stats Inset Box
                    VStack(spacing: 12) {
                        statRow(title: "Range", value: "\(String(format: "%.2f", calculatedRange())) m")
                        statRow(title: "Max Height", value: "\(String(format: "%.2f", maxHeight())) m")
                        statRow(title: "Flight Time", value: "\(String(format: "%.2f", flightTime())) s")
                    }
                    .padding(14)
                    .background(Color.primary.opacity(0.04))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.primary.opacity(0.06), lineWidth: 1)
                    )
                    
                    // Actions Stack
                    VStack(spacing: 10) {
                        Button {
                            nextRound()
                        } label: {
                            Text("Next Round")
                                .font(.headline.bold())
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.primary.opacity(0.06))
                                .cornerRadius(14)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(24)
                .frame(maxWidth: 340)
                .background(.ultraThinMaterial)
                .cornerRadius(28)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.55), .white.opacity(0.15)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .shadow(color: .black.opacity(0.25), radius: 25, x: 0, y: 15)
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    
    func launch() {
        isLaunched = true
        showPopup = false
        time = 0
        trajectoryPoints.removeAll()
        rotation += 10
        
        let angleRad = angle * .pi / 180
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            time += 0.01
            
            let vx = speed * cos(angleRad)
            let vy = speed * sin(angleRad)
            
            xPosition = vx * time * visualScale
            yPosition = (vy * time - 0.5 * selectedGravity * time * time) * visualScale
            
            let finalScreenX = 50 + xPosition
            let targetScreenX = 50 + targetDistance * visualScale
            
            trajectoryPoints.append(CGPoint(x: finalScreenX,
                                            y: 350 - yPosition))
            
            if yPosition <= 0 {
                timer?.invalidate()
                isLaunched = false
                
                if abs(finalScreenX - targetScreenX) < 40 {
                    score += 1
                    hitSuccess = true
                } else {
                    hitSuccess = false
                }
                
                showPopup = true
            }
        }
    }
    
    func nextRound() {
        targetDistance = Double.random(in: 60...140)
        xPosition = 0
        yPosition = 0
        trajectoryPoints.removeAll()
        showPopup = false
        
        if Bool.random() {
            lockAngle = true
            lockSpeed = false
            angle = Double.random(in: 20...70)
        } else {
            lockAngle = false
            lockSpeed = true
            speed = Double.random(in: 30...80)
        }
    }
    
    func predictedPoints() -> [CGPoint] {
        var points: [CGPoint] = []
        let angleRad = angle * .pi / 180
        var t: Double = 0
        
        while t <= flightTime() / 3 {
            let vx = speed * cos(angleRad)
            let vy = speed * sin(angleRad)
            let x = vx * t * visualScale
            let y = (vy * t - 0.5 * selectedGravity * t * t) * visualScale
            
            if y >= 0 {
                points.append(CGPoint(x: 50 + x,
                                      y: 350 - y))
            }
            t += 0.1
        }
        return points
    }
    
    func calculatedRange() -> Double {
        let angleRad = angle * .pi / 180
        return (pow(speed, 2) * sin(2 * angleRad)) / selectedGravity
    }
    
    func maxHeight() -> Double {
        let angleRad = angle * .pi / 180
        return (pow(speed, 2) * pow(sin(angleRad), 2)) / (2 * selectedGravity)
    }
    
    func flightTime() -> Double {
        let angleRad = angle * .pi / 180
        return (2 * speed * sin(angleRad)) / selectedGravity
    }
    func statRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
   
}


