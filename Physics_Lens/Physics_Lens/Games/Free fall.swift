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
    @State private var showHint = false
    
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
                Text("Free Fall")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(.top, 15)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                GeometryReader { geometry in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 18) {
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
                                    
                                    // Speak & Rough Board buttons overlayed on top right
                                    HStack(spacing: 10) {
                                        Spacer()
                                        
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
                                    .padding(.top, 12)
                                    .padding(.trailing, 12)
                                }
                            }
                            .aspectRatio(1 / 0.6, contentMode: .fit)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                            .padding(.horizontal)
                            
                            VStack(spacing: 15) {
                                Text("Score: \(score)")
                                    .font(.headline)
                                
                                Text(getQuestionText())
                                    .multilineTextAlignment(.center)
                                
                                TextField("Enter Answer", text: $userAnswer)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(.roundedBorder)
                                
                                Button {
                                    startDrop()
                                } label: {
                                    Text("Drop Ball")
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                        .contentShape(Rectangle())
                                }
                                .disabled(showPopup)
                                
                                Button(action: {
                                    showHint.toggle()
                                }) {
                                    Text("💡 Show Hint")
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
        .onAppear { generateRound() }
        .overlay(
            ZStack {
                popupOverlay
                hintOverlay
            }
        )
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
    
    func getHintText() -> (title: String, formula: String, explanation: String, example: String) {
        switch questionType {
        case .time:
            return (
                title: "Finding Time of Fall (t)",
                formula: "t = √((2 × s) / g)",
                explanation: "When you know the height (s) from which the object is dropped, you can find the time it takes to reach the ground by rearranging s = ½gt².",
                example: "For Height s = \(Int(s)) m and g = 9.8 m/s²:\nt = √((2 × \(Int(s))) / 9.8) ≈ \(String(format: "%.2f", sqrt(2 * s / 9.8))) seconds."
            )
        case .velocity:
            return (
                title: "Finding Final Velocity (v)",
                formula: "v = g × t",
                explanation: "When you know the time of flight (t), the final velocity is simply the acceleration due to gravity (g) multiplied by time.",
                example: "For Time t = \(String(format: "%.1f", t)) s and g = 9.8 m/s²:\nv = 9.8 × \(String(format: "%.1f", t)) ≈ \(String(format: "%.2f", 9.8 * t)) m/s."
            )
        case .velocitySquare:
            return (
                title: "Finding Velocity from Height (v)",
                formula: "v = √(2 × g × s)",
                explanation: "When you know the height (s) but not the time, use the third equation of motion: v² = u² + 2gs (since initial velocity u = 0, v = √2gs).",
                example: "For Height s = \(Int(s)) m and g = 9.8 m/s²:\nv = √(2 × 9.8 × \(Int(s))) ≈ \(String(format: "%.2f", sqrt(2 * 9.8 * s))) m/s."
            )
        }
    }
    
    var hintOverlay: some View {
        Group {
            if showHint {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showHint = false
                    }
                
                let hint = getHintText()
                
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
                    
                    Text(hint.title)
                        .font(.subheadline.bold())
                        .foregroundColor(.blue)
                    
                    Text(hint.explanation)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Formula to Use:")
                            .font(.caption.bold())
                            .foregroundColor(.primary)
                        Text(hint.formula)
                            .font(.system(.body, design: .monospaced))
                            .bold()
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(6)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Step-by-Step for Current Values:")
                            .font(.caption.bold())
                            .foregroundColor(.primary)
                        Text(hint.example)
                            .font(.system(.footnote, design: .monospaced))
                            .foregroundColor(.secondary)
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(6)
                    }
                    
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
