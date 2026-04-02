import SwiftUI
import UIKit
import FoundationModels

@available(iOS 26.0, *)
struct FreeFallGame: View {
    
    enum QuestionType: CaseIterable {
        case time, velocity, velocitySquare
    }
    
    let g = 9.8
    let ballSize: CGFloat = 40
    
    @State private var ballY: CGFloat = 0
    @State private var fallDuration: Double = 1.5
    @State private var showSplash = false
    
    @StateObject private var aiManager = AIFeedbackManager()
    @State private var showAISheet = false
    
    @StateObject private var voiceManager = VoiceAssistantManager()
    @State private var showBoard = false
    
    @State private var v: Double = 0
    @State private var t: Double = 0
    @State private var s: Double = 40
    
    @State private var questionType: QuestionType = .time
    @State private var findVariable = ""
    @State private var givenVariables: [String] = []
    
    @State private var correctAnswer: Double = 0
    @State private var userAnswer = ""
    
    @State private var score = 0
    @State private var showPopup = false
    @State private var wasCorrect = false
    
    @State private var totalDrop: CGFloat = 0
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack {
                Text("Free Fall")
                    .font(.system(size: 32, weight: .bold))
                
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
                    speakFreeFall()
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.title3)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
            }
            .padding()
            
            GeometryReader { geo in
                ZStack(alignment: .top) {
                    
                    Image("pisa_bg")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width)
                    
                    let imageHeight = geo.size.width * 0.6
                    let startY = imageHeight * 0.15
                    let groundY = imageHeight * 0.80
                    
                    ZStack {
                        Image("ball")
                            .resizable()
                            .frame(width: ballSize, height: ballSize)
                            .position(
                                x: geo.size.width / 2,
                                y: startY + ballY
                            )
                            .animation(.easeIn(duration: fallDuration), value: ballY)
                        
                        if showSplash {
                            Image("splash")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .position(
                                    x: geo.size.width / 2,
                                    y: groundY
                                )
                        }
                    }
                    .onAppear {
                        totalDrop = groundY - startY
                    }
                }
            }
            .frame(height: UIScreen.main.bounds.width * 0.6)
            
            VStack(spacing: 15) {
                
                Text("Score: \(score)")
                
                Text(getQuestionText())
                    .multilineTextAlignment(.center)
                
                TextField("Enter Answer", text: $userAnswer)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                
                Button {
                    startDrop()
                } label: {
                    Text("Drop Ball")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .contentShape(Rectangle())
                }
                .disabled(showPopup)
                
                Button("Next Round") {
                    generateRound()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            .padding()
        }
        .onAppear { generateRound() }
        .overlay(popupOverlay)
    }
    
    
    func startDrop() {
        ballY = totalDrop
        
        DispatchQueue.main.asyncAfter(deadline: .now() + fallDuration) {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            showSplash = true
            checkAnswer()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showSplash = false
            }
        }
    }
    
    func checkAnswer() {
        guard let user = Double(userAnswer) else {
            wasCorrect = false
            showPopup = true
            return
        }
        
        let tolerance = correctAnswer * 0.1
        let diff = abs(user - correctAnswer)
        
        if diff <= tolerance {
            score += 10
            wasCorrect = true
        } else {
            wasCorrect = false
        }
        
        showPopup = true
    }
    
    
    var popupOverlay: some View {
        ZStack {
            if showPopup {
                Color.black.opacity(0.25).ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    Text(wasCorrect ? "🎯 Correct!" : "❌ Incorrect")
                        .font(.title.bold())
                    
                    Divider()
                    
                    statRow(title: "Correct Answer",
                            value: "\(String(format: "%.2f", correctAnswer))")
                    
                    statRow(title: "Your Answer",
                            value: userAnswer)
                    
                    statRow(title: "Formula Used",
                            value: formulaForFindVariable())
                    
                    Divider()
                    
                    Button("Next Round") {
                        showPopup = false
                        generateRound()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(24)
                .frame(maxWidth: 350)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                )
            }
        }
    }
    
    
    func generateRound() {
        questionType = QuestionType.allCases.randomElement()!
        userAnswer = ""
        ballY = 0
        showSplash = false
        
        switch questionType {
        case .time:
            s = Double(Int.random(in: 20...80))
            t = sqrt((2 * s) / g)
            correctAnswer = t
            findVariable = "t"
            givenVariables = ["s"]
            
        case .velocity:
            t = Double(Int.random(in: 2...6))
            v = g * t
            correctAnswer = v
            findVariable = "v"
            givenVariables = ["t"]
            
        case .velocitySquare:
            s = Double(Int.random(in: 20...80))
            v = sqrt(2 * g * s)
            correctAnswer = v
            findVariable = "v"
            givenVariables = ["s"]
        }
    }
    
    func getQuestionText() -> String {
        var text = "Given:\n"
        if givenVariables.contains("s") { text += "Height = \(Int(s)) m\n" }
        if givenVariables.contains("t") { text += "Time = \(t) s\n" }
        if givenVariables.contains("v") { text += "Velocity = \(v) m/s\n" }
        text += "\nFind: \(getFindText())"
        return text
    }
    
    func getFindText() -> String {
        switch findVariable {
        case "t": return "Time (t)"
        case "v": return "Velocity (v)"
        case "s": return "Height (s)"
        default: return ""
        }
    }
    
    func formulaForFindVariable() -> String {
        switch findVariable {
        case "t": return "s = ½gt²"
        case "v": return "v = gt or v² = 2gs"
        default: return ""
        }
    }
    
    func statRow(title: String, value: String) -> some View {
        HStack {
            Text(title).foregroundColor(.secondary)
            Spacer()
            Text(value).fontWeight(.semibold)
        }
    }
    
    func speakFreeFall() {
        voiceManager.speakFreeFallQuestion(
            height: givenVariables.contains("s") ? s : nil,
            time: givenVariables.contains("t") ? t : nil,
            velocity: givenVariables.contains("v") ? v : nil,
            findVariable: findVariable
        )
    }
}
