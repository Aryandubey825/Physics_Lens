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
    
    @State private var carPosition: CGFloat = 0
    @State private var resultText = ""
    @State private var solutionText = ""
    
    @State private var score = 0
    @State private var streak = 0
    
    @State private var timer: Int = 15
    @State private var answered = false
    @State private var hint = ""
    @State private var glow = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Text("Physics Race PRO 🚗💨")
                .font(.system(size: 30, weight: .bold))
                .padding(.top)
            
            ZStack {
                
                LinearGradient(
                    colors: [.black.opacity(0.50), .green.opacity(0.50)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 15) {
                    topBar
                    questionCard
                    gameTrack
                }
                .padding(.top)
            }
            .frame(height: 480)
            
            inputSection
        }
        .overlay(popupOverlay)
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
            
            VStack(alignment: .leading) {
                Text("Score: \(score)")
                Text("Streak: \(streak) 🔥")
            }
            .foregroundColor(.white)
            
            Spacer()
            
            Text("⏱ \(timer)s")
                .foregroundColor(timer <= 5 ? .red : .white)
            
            Button {
                showBoard = true
            } label: {
                HStack {
                    Image(systemName: "pencil.and.outline")
                    Text("Rough Work")
                }
            }
            .buttonStyle(.bordered)
            
            Button {
                voiceQuestion()
            } label: {
                Image(systemName: "speaker.wave.2.fill")
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: Question Card
    var questionCard: some View {
        VStack(spacing: 6) {
            
            Text("Acceleration: \(Int(acceleration)) m/s²")
            
            if questionType != .time {
                Text("Time: \(Int(time)) s")
            }
            
            if questionType != .distance {
                Text("Distance: \(Int(distance)) m")
            }
            
            if questionType == .force {
                Text("Mass: \(Int(mass)) kg")
            }
            
            Text("Find: \(title())")
                .foregroundColor(.yellow)
                .bold()
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .padding(.horizontal)
    }
    
    // MARK: Game Track
    var gameTrack: some View {
        GeometryReader { geo in
            
            ZStack(alignment: .leading) {
                
                Image("road")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 160)
                    .clipped()
                    .cornerRadius(16)
                
                Text("START")
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .padding(.leading, 12)
                    .offset(y: -50)
                
                Text("FINISH 🏁")
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .position(x: geo.size.width - 50, y: 25)
                
                Image("car")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 40)
                    .offset(x: carPosition, y: 60)
                    .shadow(color: glow ? .green : .black.opacity(0.3), radius: 10)
            }
        }
        .frame(height: 160)
        .padding(.horizontal)
    }
    
    // MARK: Input Section (FIXED BUTTON HERE)
    var inputSection: some View {
        VStack(spacing: 10) {
            
            TextField("Enter Answer", text: $userAnswer)
                .keyboardType(.decimalPad)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            
            // ✅ FIXED FULL WIDTH CLICKABLE BUTTON
            Button {
                checkAnswer()
            } label: {
                Text("Drive 🚗")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .contentShape(Rectangle())
            }
            
            Button("Hint 💡") {
                hint = getHint()
            }
            
            Text(hint)
                .foregroundColor(.orange)
        }
        .padding()
    }
    
    // MARK: Popup
    var popupOverlay: some View {
        ZStack {
            if showPopup {
                
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    Text(resultText)
                        .font(.title2.bold())
                    
                    Text(solutionText)
                        .multilineTextAlignment(.center)
                    
                    Button {
                        generateAIFeedback()
                    } label: {
                        HStack {
                            Image(systemName: "sparkles")
                            Text("Get AI Insight")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Next Round") {
                        showPopup = false
                        nextRound()
                    }
                    .buttonStyle(.bordered)
                }
                .padding(25)
                .background(.ultraThinMaterial)
                .cornerRadius(24)
                .frame(maxWidth: 350)
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
        carPosition = 0
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
        let maxWidth = UIScreen.main.bounds.width - 120
        carPosition = maxWidth * speed
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
}
