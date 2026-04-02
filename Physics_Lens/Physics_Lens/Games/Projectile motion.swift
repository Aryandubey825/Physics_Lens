import SwiftUI
import FoundationModels
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
    
    @StateObject private var aiManager = AIFeedbackManager()
    @State private var showAISheet = false
    
    let visualScale: Double = 3
    
    var body: some View {
        VStack(spacing: 0) {
            
            Text("Projectile Motion")
                .font(.system(size: 32, weight: .bold))
            
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
                            .foregroundColor(.white)
                            .padding(.leading)
                        
                        Spacer()
                        
                        Button {
                            showBoard = true
                        } label: {
                            HStack {
                                Image(systemName: "pencil.and.outline")
                                Text("Rough Work")
                            }
                        }
                        .buttonStyle(.bordered)
                        .sheet(isPresented: $showBoard) {
                            RoughBoardView()
                        }
                        
                        
                        
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
                    Text("Formula")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
            }
            .padding()
            .background(Color(.systemGray6))
        }
        .overlay(
            ZStack {
                popupOverlay
                formulaOverlay
            }
        )
    }
    
    
    var formulaOverlay: some View {
        Group {
            if showHint {
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("📘 Projectile Motion Formulas")
                        .font(.headline)
                    
                    Text("Range:")
                    Text("R = (u² sin(2θ)) / g")
                    
                    Text("Time of Flight:")
                    Text("T = (2u sinθ) / g")
                    
                    Text("Maximum Height:")
                    Text("H = (u² sin²θ) / 2g")
                    
                    Text("Horizontal Velocity:")
                    Text("vx = u cosθ")
                    
                    Text("Vertical Velocity:")
                    Text("vy = u sinθ")
                    
                    Button("Close") {
                        showHint = false
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top)
                    
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(18)
                .padding()
            }
        }
    }
    
    
    var popupOverlay: some View {
        ZStack {
            if showPopup {
                
                // Background Dim Layer
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                VStack(spacing: 20) {
                    
                    // Result Title
                    Text(hitSuccess ? "🎯 Perfect Hit!" : "💥 Target Missed")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(
                            hitSuccess ?
                            LinearGradient(colors: [.green, .mint],
                                           startPoint: .leading,
                                           endPoint: .trailing)
                            :
                            LinearGradient(colors: [.red, .orange],
                                           startPoint: .leading,
                                           endPoint: .trailing)
                        )
                    
                    Divider()
                    
                    // Stats Section
                    VStack(spacing: 12) {
                        statRow(title: "Range",
                                value: "\(String(format: "%.2f", calculatedRange())) m")
                        
                        statRow(title: "Max Height",
                                value: "\(String(format: "%.2f", maxHeight())) m")
                        
                        statRow(title: "Flight Time",
                                value: "\(String(format: "%.2f", flightTime())) s")
                    }
                    
                    Divider()
                    
                    // AI Insight Button
                    Button {
                        generateAIFeedback()
                        showAISheet = true
                    } label: {
                        HStack {
                            Image(systemName: "sparkles")
                            Text("Get AI Insight")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    // Next Button
                    Button {
                        nextRound()
                    } label: {
                        Text("Next Round")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
                .padding(24)
                .frame(maxWidth: 360)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.25), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.2),
                        radius: 20,
                        x: 0,
                        y: 10)
                .scaleEffect(showPopup ? 1 : 0.8)
                .animation(.spring(response: 0.4,
                                   dampingFraction: 0.75),
                           value: showPopup)
            }
        }
        .sheet(isPresented: $showAISheet) {
            NavigationStack {
                VStack(spacing: 20) {
                    
                    Text("AI Performance Review")
                        .font(.title2.bold())
                    
                    if aiManager.isLoading {
                        ProgressView("Analyzing...")
                            .padding()
                    } else {
                        
                        AIFeedbackView(feedback: aiManager.feedbackText)
                            .frame(maxHeight: .infinity)
                    }
                    
                    Button("Close") {
                        showAISheet = false
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .padding()
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
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
    func generateAIFeedback() {
        
        let result = GameResult(
            topic: "Projectile Motion",
            userInput: """
            Angle: \(Int(angle))°
            Speed: \(Int(speed)) m/s
            Gravity: \(selectedGravity)
            Target Range: \(String(format: "%.1f", targetDistance)) m
            """,
            correctConcept: """
            Range = (u² sin(2θ)) / g
            Time of Flight = (2u sinθ) / g
            Maximum Height = (u² sin²θ) / (2g)
            """,
            userOutcome: hitSuccess ? "Hit the target" : "Missed the target",
            score: score
        )
        
        Task {
            await aiManager.analyze(result: result)
            showAISheet = true
        }
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


