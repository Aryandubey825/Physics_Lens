import SwiftUI
import FoundationModels
import AVFoundation

@available(iOS 26.0, *)
struct PhysicsRacePro: View {
    
    enum QuestionType: CaseIterable {
        case force, distance, time
    }
    
    @StateObject private var voiceManager = VoiceAssistantManager()
    @StateObject private var aiManager = AIFeedbackManager()
    
    @State private var showBoard = false
    @State private var showPopup = false
    @State private var showAISheet = false
    
    @State private var questionType: QuestionType = .force
    @State private var mass: Double = 5
    @State private var time: Double = 2
    @State private var distance: Double = 100
    @State private var acceleration: Double = 10
    
    @State private var userAnswer: String = ""
    
    @State private var carProgress: CGFloat = 0
    @State private var resultText = ""
    @State private var solutionText = ""
    
    @State private var score = 0
    @State private var streak = 0
    
    @State private var timer: Int = 15
    @State private var answered = false
    @State private var hint = ""
    @State private var glow = false
    @State private var showHint = false
    
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
                Text("Physics Race PRO 🚗💨")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(.top, 15)
                    .padding(.bottom, 10)
                
                GeometryReader { geometry in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 18) {
                            ZStack {
                                // Premium Cyber Indigo Card Background
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(red: 0.08, green: 0.09, blue: 0.15))
                                
                                VStack(spacing: 16) {
                                    topBar
                                    questionCard
                                    gameTrack
                                }
                                .padding(.top, 12)
                                .padding(.bottom, 16)
                            }
                            .frame(height: 480)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.12), lineWidth: 1.5)
                            )
                            .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 5)
                            .padding(.horizontal)
                            
                            inputSection
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
        .overlay(
            ZStack {
                popupOverlay
                hintOverlay
            }
        )
        .sheet(isPresented: $showBoard) {
            RoughBoardView()
        }
        .sheet(isPresented: $showAISheet) {
            NavigationStack {
                VStack(spacing: 20) {
                    Text("AI Performance Review")
                        .font(.title2.bold())
                    
                    if aiManager.isLoading {
                        ProgressView("Analyzing...")
                            .padding(.top, 30)
                    } else {
                        AIFeedbackView(feedback: aiManager.feedbackText)
                            .frame(maxWidth: .infinity)
                    }
                    
                    Button("Close") {
                        showAISheet = false
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .padding(.top, 10)
                }
                .padding()
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .onAppear {
            startGame()
        }
    }
    
    // MARK: Top Bar
    var topBar: some View {
        HStack {
            // Score & Streak Badges
            HStack(spacing: 10) {
                HStack(spacing: 4) {
                    Image(systemName: "flag.fill")
                        .foregroundColor(.blue)
                        .font(.caption)
                    Text("SCORE: \(score)")
                        .font(.system(.caption, design: .monospaced).bold())
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)
                
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                        .font(.caption)
                    Text("STREAK: \(streak)")
                        .font(.system(.caption, design: .monospaced).bold())
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.orange.opacity(0.2))
                .cornerRadius(8)
            }
            
            Spacer()
            
            // Timer Badge
            HStack(spacing: 6) {
                Image(systemName: "timer")
                    .foregroundColor(timer <= 5 ? .red : .green)
                    .font(.caption.bold())
                Text("\(timer)s")
                    .font(.system(.footnote, design: .monospaced).bold())
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background((timer <= 5 ? Color.red : Color.green).opacity(0.2))
            .cornerRadius(8)
            .shadow(color: (timer <= 5 ? Color.red : Color.green).opacity(0.25), radius: 4)
            
            // Speaker Button
            Button {
                voiceQuestion()
            } label: {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.white.opacity(0.12))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: Question Card
    var questionCard: some View {
        VStack(spacing: 14) {
            Text("ARCADE HUD / SIMULATION")
                .font(.system(.caption2, design: .monospaced).bold())
                .foregroundColor(.cyan)
                .tracking(2)
            
            // Badges Grid
            HStack(spacing: 8) {
                ParameterBadge(label: "Acceleration", value: "\(Int(acceleration)) m/s²", icon: "gauge.with.needle.fill", color: .cyan)
                
                if questionType != .time {
                    ParameterBadge(label: "Time", value: "\(Int(time)) s", icon: "timer", color: .purple)
                }
                
                if questionType != .distance {
                    ParameterBadge(label: "Distance", value: "\(Int(distance)) m", icon: "arrow.left.and.right", color: .green)
                }
                
                if questionType == .force {
                    ParameterBadge(label: "Mass", value: "\(Int(mass)) kg", icon: "scalemass.fill", color: .orange)
                }
            }
            
            Divider()
                .background(Color.white.opacity(0.12))
            
            // Target
            HStack {
                Text("TARGET VARIABLE")
                    .font(.system(.caption2, design: .monospaced))
                    .foregroundColor(.secondary)
                Spacer()
                Text(title())
                    .font(.system(.footnote, design: .rounded).bold())
                    .foregroundColor(.yellow)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.yellow.opacity(0.18))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.yellow.opacity(0.35), lineWidth: 1)
                    )
            }
        }
        .padding()
        .background(Color.black.opacity(0.35))
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
        .padding(.horizontal)
    }
    
    // MARK: Game Track
    var gameTrack: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // Asphalt track lane
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(
                        colors: [Color(red: 0.12, green: 0.14, blue: 0.22), Color(red: 0.05, green: 0.06, blue: 0.10)],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                
                // Neon glowing boundaries
                VStack {
                    Rectangle()
                        .fill(LinearGradient(colors: [.blue, .cyan], startPoint: .leading, endPoint: .trailing))
                        .frame(height: 2)
                        .shadow(color: .cyan.opacity(0.7), radius: 3)
                    Spacer()
                    Rectangle()
                        .fill(LinearGradient(colors: [.blue, .cyan], startPoint: .leading, endPoint: .trailing))
                        .frame(height: 2)
                        .shadow(color: .cyan.opacity(0.7), radius: 3)
                }
                
                // Checkered Start Band
                CheckeredBand()
                    .frame(width: 12)
                    .padding(.leading, 30)
                
                // Checkered Finish Band
                CheckeredBand()
                    .frame(width: 12)
                    .padding(.trailing, 30)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                // Track Labels
                VStack {
                    HStack {
                        Text("START")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .foregroundColor(.cyan.opacity(0.7))
                            .padding(.leading, 24)
                        Spacer()
                        Text("FINISH 🏁")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .foregroundColor(.green.opacity(0.7))
                            .padding(.trailing, 16)
                    }
                    .padding(.top, 8)
                    Spacer()
                }
                
                // Center dotted lane separator
                Path { path in
                    path.move(to: CGPoint(x: 45, y: 80))
                    path.addLine(to: CGPoint(x: geo.size.width - 45, y: 80))
                }
                .stroke(style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [10, 8]))
                .foregroundColor(.white.opacity(0.2))
                
                // Animated Car
                let startX: CGFloat = 30 + 12 + 5 // after start band
                let endX: CGFloat = geo.size.width - 30 - 12 - 85 // before finish band
                let currentX = startX + (carProgress * (endX - startX))
                
                Image("car")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 40)
                    .position(x: currentX + 40, y: 80)
                    .shadow(color: glow ? .green : .blue.opacity(0.4), radius: glow ? 12 : 5)
            }
        }
        .frame(height: 160)
        .padding(.horizontal)
    }
    
    // MARK: Input Section
    var inputSection: some View {
        VStack(spacing: 16) {
            Text("INPUT METRIC FOR SIMULATION")
                .font(.system(.caption, design: .monospaced).bold())
                .foregroundColor(.secondary)
                .tracking(1.5)
            
            HStack(spacing: 12) {
                TextField("0.0", text: $userAnswer)
                    .keyboardType(.decimalPad)
                    .font(.system(.body, design: .monospaced))
                    .padding(14)
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
                
                Button {
                    checkAnswer()
                } label: {
                    HStack(spacing: 6) {
                        Text("Drive")
                        Image(systemName: "bolt.fill")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(12)
                    .shadow(color: .blue.opacity(0.3), radius: 6)
                }
            }
            
            Button {
                showHint = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.orange)
                    Text("Show Hint")
                        .font(.footnote.bold())
                        .foregroundColor(.orange)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    // MARK: Popup
    var popupOverlay: some View {
        ZStack {
            if showPopup {
                Color.black.opacity(0.45)
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Result title with custom glow
                    Text(resultText)
                        .font(.system(.title2, design: .rounded).bold())
                        .foregroundColor(resultText.contains("Wrong") ? .red : (resultText.contains("Perfect") ? .green : .orange))
                        .shadow(color: (resultText.contains("Wrong") ? Color.red : (resultText.contains("Perfect") ? Color.green : Color.orange)).opacity(0.3), radius: 5)
                    
                    VStack(spacing: 12) {
                        Text("Concept Solution:")
                            .font(.caption.bold())
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(solutionText)
                            .font(.system(.body, design: .monospaced).bold())
                            .foregroundColor(.primary)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.06))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    }
                    
                    VStack(spacing: 12) {
                        Button {
                            generateAIFeedback()
                        } label: {
                            HStack {
                                Image(systemName: "sparkles")
                                Text("Get AI Performance Insight")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(colors: [.indigo, .purple], startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(12)
                        }
                        
                        Button {
                            showPopup = false
                            nextRound()
                        } label: {
                            Text("Next Round")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(25)
                .background(.ultraThinMaterial)
                .cornerRadius(24)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .frame(maxWidth: 340)
                .shadow(color: .black.opacity(0.35), radius: 20, x: 0, y: 10)
            }
        }
    }
    
    // MARK: Game Logic (UNCHANGED)
    func startGame() {
        generateQuestion()
        startTimer()
    }
    
    func generateQuestion() {
        questionType = QuestionType.allCases.randomElement()!
        mass = Double(Int.random(in: 2...10))
        time = Double(Int.random(in: 2...5))
        acceleration = Double(Int.random(in: 5...15))
        distance = 0.5 * acceleration * time * time
        userAnswer = ""
        carProgress = 0
        hint = ""
        answered = false
    }
    
    func correctAnswer() -> Double {
        switch questionType {
        case .force: return mass * acceleration
        case .distance: return 0.5 * acceleration * time * time
        case .time: return sqrt((2 * distance) / acceleration)
        }
    }
    
    func checkAnswer() {
        answered = true
        
        guard let user = Double(userAnswer) else {
            resultText = "Invalid Input"
            solutionText = ""
            showPopup = true
            return
        }
        
        let correct = correctAnswer()
        let error = abs(user - correct)
        
        var speed: CGFloat = 0.2
        
        if error < 2 {
            resultText = "🎯 Perfect!"
            score += 20
            streak += 1
            speed = 1.0
            glowEffect()
        } else if error < 10 {
            resultText = "😐 Close!"
            score += 10
            streak = 0
            speed = 0.6
        } else {
            resultText = "❌ Wrong!"
            streak = 0
        }
        
        solutionText = getSolution(correct: correct)
        moveCar(speed: speed)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            showPopup = true
        }
    }
    
    func moveCar(speed: CGFloat) {
        withAnimation(.easeInOut(duration: 1.0)) {
            carProgress = speed
        }
    }
    
    func glowEffect() {
        glow = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            glow = false
        }
    }
    
    func startTimer() {
        timer = 15
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if answered {
                t.invalidate()
                return
            }
            
            if timer > 0 {
                timer -= 1
            } else {
                t.invalidate()
                timeUp()
            }
        }
    }
    
    func timeUp() {
        resultText = "⏱ Time Up!"
        solutionText = getSolution(correct: correctAnswer())
        streak = 0
        showPopup = true
    }
    
    func title() -> String {
        switch questionType {
        case .force: return "Force (N)"
        case .distance: return "Distance (m)"
        case .time: return "Time (s)"
        }
    }
    
    func getSolution(correct: Double) -> String {
        switch questionType {
        case .force:
            return "F = m × a = \(Int(correct)) N"
        case .distance:
            return "s = ½at² = \(Int(correct)) m"
        case .time:
            return "t = √(2s/a) = \(String(format: "%.2f", correct)) s"
        }
    }
    
    func getHint() -> String {
        switch questionType {
        case .force: return "F = m × a"
        case .distance: return "s = ½ a t²"
        case .time: return "t = √(2s/a)"
        }
    }
    
    func nextRound() {
        startGame()
    }
    
    func voiceQuestion() {
        let typeText: String
        
        switch questionType {
        case .force: typeText = "Force"
        case .distance: typeText = "Distance"
        case .time: typeText = "Time"
        }
        
        voiceManager.speakRaceQuestion(
            questionType: typeText,
            mass: mass,
            time: time,
            distance: distance,
            acceleration: acceleration
        )
    }
    
    func generateAIFeedback() {
        let result = GameResult(
            topic: "Newton's Second Law & Kinematics",
            userInput: "Mass: \(mass), Time: \(time), Distance: \(distance), Acceleration: \(acceleration)",
            correctConcept: "F = ma, s = ½at², t = √(2s/a)",
            userOutcome: resultText,
            score: score
        )
        
        Task {
            await aiManager.analyze(result: result)
            showAISheet = true
        }
    }
    
    // MARK: Solver Hint Overlay
    var hintOverlay: some View {
        Group {
            if showHint {
                ZStack {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showHint = false
                        }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 8) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.yellow)
                                .font(.title2)
                            Text("Solver Hint")
                                .font(.headline)
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
                            VStack(alignment: .leading, spacing: 14) {
                                Text("🎯 Solve Guide:")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.blue)
                                
                                switch questionType {
                                case .force:
                                    Text("To find Force, apply Newton's Second Law of Motion: F = m × a")
                                        .font(.footnote)
                                        .foregroundColor(.primary)
                                    
                                    Text("F = m × a")
                                        .font(.system(.body, design: .monospaced))
                                        .bold()
                                        .padding(6)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(6)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Current Values:")
                                            .font(.caption.bold())
                                        Text("• Mass (m) = \(Int(mass)) kg")
                                        Text("• Acceleration (a) = \(Int(acceleration)) m/s²")
                                    }
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Step-by-Step Calculation:")
                                            .font(.caption.bold())
                                        Text("F = \(Int(mass)) × \(Int(acceleration)) = \(Int(mass * acceleration)) N")
                                            .font(.system(.footnote, design: .monospaced))
                                            .padding(6)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(6)
                                    }
                                    
                                case .distance:
                                    Text("To find Distance (s), use the Kinematics equation of motion starting from rest (u = 0): s = ½at²")
                                        .font(.footnote)
                                        .foregroundColor(.primary)
                                    
                                    Text("s = ½ × a × t²")
                                        .font(.system(.body, design: .monospaced))
                                        .bold()
                                        .padding(6)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(6)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Current Values:")
                                            .font(.caption.bold())
                                        Text("• Acceleration (a) = \(Int(acceleration)) m/s²")
                                        Text("• Time (t) = \(Int(time)) s")
                                    }
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Step-by-Step Calculation:")
                                            .font(.caption.bold())
                                        Text("s = 0.5 × \(Int(acceleration)) × (\(Int(time))²)\ns = 0.5 × \(Int(acceleration)) × \(Int(time * time)) = \(Int(0.5 * acceleration * time * time)) m")
                                            .font(.system(.footnote, design: .monospaced))
                                            .padding(6)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(6)
                                    }
                                    
                                case .time:
                                    Text("To find Time (t), rearrange the kinematics equation (s = ½at²) to solve for t:")
                                        .font(.footnote)
                                        .foregroundColor(.primary)
                                    
                                    Text("t = √(2s / a)")
                                        .font(.system(.body, design: .monospaced))
                                        .bold()
                                        .padding(6)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(6)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Current Values:")
                                            .font(.caption.bold())
                                        Text("• Distance (s) = \(Int(distance)) m")
                                        Text("• Acceleration (a) = \(Int(acceleration)) m/s²")
                                    }
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Step-by-Step Calculation:")
                                            .font(.caption.bold())
                                        Text("t = √((2 × \(Int(distance))) / \(Int(acceleration)))\nt = √(\(Int(2 * distance)) / \(Int(acceleration))) ≈ \(String(format: "%.2f", sqrt(2 * distance / acceleration))) seconds")
                                            .font(.system(.footnote, design: .monospaced))
                                            .padding(6)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(6)
                                    }
                                }
                            }
                        }
                        .frame(maxHeight: 280)
                        
                        Divider()
                        
                        Button("Got it!") {
                            showHint = false
                        }
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                    }
                    .padding(20)
                    .frame(maxWidth: 340)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                    )
                    .shadow(radius: 10)
                    .padding()
                }
            }
        }
    }
}

// MARK: - Premium UI Subviews
struct ParameterBadge: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundColor(color)
                Text(label)
                    .font(.system(size: 9, weight: .bold, design: .rounded))
                    .foregroundColor(.secondary)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
            }
            Text(value)
                .font(.system(.footnote, design: .monospaced).bold())
                .foregroundColor(.white)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(Color.white.opacity(0.06))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}

struct CheckeredBand: View {
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<10, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<2, id: \.self) { col in
                        Rectangle()
                            .fill((row + col) % 2 == 0 ? Color.white : Color.black)
                    }
                }
            }
        }
        .opacity(0.15)
    }
}

