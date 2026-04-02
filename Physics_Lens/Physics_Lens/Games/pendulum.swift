import SwiftUI

@available(iOS 26.0, *)
struct PendulumGame: View {
    
    @StateObject private var aiManager = AIFeedbackManager()
    @State private var showAISheet = false
    
    @StateObject private var voiceManager = VoiceAssistantManager()
    
    @State private var showBoard = false
    
    @State private var angle: Double = 0
    @State private var time: Double = 0
    @State private var motionTimer: Timer?
    
    @State private var lengthPixels: Double = 220
    @State private var gravity: Double = 9.8
    @State private var randomMode: Bool = false
    
    @State private var userGuess: String = ""
    @State private var score: Int = 0
    @State private var isCorrect: Bool = false
    @State private var showPopup = false
    
    @State private var showHint = false
    
    let amplitude: Double = 0.6
    let pixelToMeter: Double = 150
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Text("Simple Pendulum")
                .font(.system(size: 32, weight: .bold))
            
            ZStack {
                
                LinearGradient(
                    colors: [.black, .blue.opacity(0.9)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ZStack(alignment: .top) {
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 14)
                    
                    ZStack(alignment: .top) {
                        
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 3,
                                   height: lengthPixels)
                        
                        Image("ball1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .offset(y: lengthPixels)
                    }
                    .rotationEffect(.radians(angle),
                                    anchor: .top)
                }
                .padding(.top, 40)
                
                VStack {
                    HStack {
                        
                        Text("Score: \(score)")
                            .foregroundColor(.white)
                            .padding(.leading)
                        
                        Spacer()
                        
                        Button {
                            let lengthMeters = lengthPixels / pixelToMeter
                            voiceManager.speakPendulumQuestion(
                                lengthMeters: lengthMeters,
                                gravity: gravity
                            )
                        } label: {
                            Image(systemName: "speaker.wave.2.fill")
                                .foregroundColor(.white)
                        }
                        
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
                        
                        Spacer().frame(width: 12)
                    }
                    
                    Spacer()
                }
                
                popupOverlay
                hintOverlay
            }
            .frame(height: 450)
            
            VStack(spacing: 15) {
                
                Toggle("Random Length Mode",
                       isOn: $randomMode)
                
                let lengthMeters = lengthPixels / pixelToMeter
                Text("Length: \(String(format: "%.2f", lengthMeters)) m")
                
                if !randomMode {
                    Slider(value: $lengthPixels,
                           in: 150...280)
                }
                
                Picker("Gravity",
                       selection: $gravity) {
                    Text("Earth").tag(9.8)
                    Text("Moon").tag(1.6)
                    Text("Mars").tag(3.7)
                }
                .pickerStyle(.segmented)
                
                TextField("Time Period (seconds)",
                          text: $userGuess)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                Button {
                    checkAnswer()
                } label: {
                    Text("Submit")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                
                Button {
                    showHint = true
                } label: {
                    Text("Hint")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                
            }
            .padding()
            .background(Color(.systemGray6))
        }
        .onAppear {
            startPendulum()
        }
        .sheet(isPresented: $showAISheet) {
            aiSheetView
        }
    }
    
    
    var hintOverlay: some View {
        Group {
            if showHint {
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("📘 Pendulum Formula")
                        .font(.headline)
                    
                    Text("Time Period:")
                    Text("T = 2π√(L/g)")
                    
                    Text("• Depends only on Length and Gravity")
                    Text("• Independent of Mass")
                    
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
                
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    Text(isCorrect ? "🎯 Correct!" : "❌ Incorrect")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(
                            isCorrect ?
                            LinearGradient(colors: [.green, .mint],
                                           startPoint: .leading,
                                           endPoint: .trailing)
                            :
                            LinearGradient(colors: [.red, .orange],
                                           startPoint: .leading,
                                           endPoint: .trailing)
                        )
                    
                    Divider()
                    
                    VStack(spacing: 12) {
                        statRow(title: "Length",
                                value: "\(String(format: "%.2f", lengthPixels/pixelToMeter)) m")
                        
                        statRow(title: "Gravity",
                                value: "\(gravity)")
                        
                        statRow(title: "Correct T",
                                value: "\(String(format: "%.2f", realTimePeriod())) s")
                    }
                    
                    Divider()
                    
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
                    
                    Button {
                        nextRound()
                    } label: {
                        Text("Next Round")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(24)
                .frame(maxWidth: 360)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                )
                .shadow(radius: 20)
            }
        }
    }
    
    
    var aiSheetView: some View {
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
    }
  
    
    func startPendulum() {
        motionTimer?.invalidate()
        time = 0
        
        motionTimer = Timer.scheduledTimer(withTimeInterval: 0.01,
                                           repeats: true) { _ in
            time += 0.01
            let L = lengthPixels / pixelToMeter
            let omega = sqrt(gravity / L)
            angle = amplitude * cos(omega * time)
        }
    }
    
    func realTimePeriod() -> Double {
        let L = lengthPixels / pixelToMeter
        return 2 * Double.pi * sqrt(L / gravity)
    }
    
    func checkAnswer() {
        guard let guess = Double(userGuess) else { return }
        
        let correctT = realTimePeriod()
        let tolerance = correctT * 0.05   // 5% tolerance
        
        isCorrect = abs(guess - correctT) <= tolerance
        
        if isCorrect { score += 1 }
        
        showPopup = true
    }
    
    func nextRound() {
        if randomMode {
            lengthPixels = Double.random(in: 150...280)
        }
        userGuess = ""
        showPopup = false
    }
    
    func generateAIFeedback() {
        let result = GameResult(
            topic: "Simple Pendulum",
            userInput: """
            Length: \(String(format: "%.2f", lengthPixels/pixelToMeter)) m
            Gravity: \(gravity)
            """,
            correctConcept: "T = 2π√(L/g). Time period depends only on length and gravity.",
            userOutcome: isCorrect ? "Correct Answer" : "Incorrect Answer",
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
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}
