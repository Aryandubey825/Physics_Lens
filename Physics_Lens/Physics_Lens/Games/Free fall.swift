import SwiftUI
import UIKit

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
    @State private var showAIInsights = false
    
    @StateObject private var voiceManager = VoiceAssistantManager()
    @StateObject private var aiManager = AIFeedbackManager()
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
        .sheet(isPresented: $showAIInsights) {
            AIInsightSheetView(aiManager: aiManager, isPresented: $showAIInsights)
                .presentationDetents([.medium, .large])
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
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                VStack(spacing: 20) {
                    // Status Badge Icon
                    let statusColor: Color = wasCorrect ? .green : .red
                    let statusIcon: String = wasCorrect ? "checkmark.seal.fill" : "xmark.seal.fill"
                    let statusTitle = wasCorrect ? "Correct!" : "Incorrect"
                    
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
                        statRow(title: "Correct Answer", value: "\(String(format: "%.2f", correctAnswer))")
                        statRow(title: "Your Answer", value: userAnswer.isEmpty ? "--" : userAnswer)
                        statRow(title: "Formula Used", value: formulaForFindVariable())
                    }
                    .padding(14)
                    .background(Color.primary.opacity(0.04))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.primary.opacity(0.06), lineWidth: 1)
                    )
                    
                    // AI Insights Button
                    Button {
                        showAIInsights = true
                    } label: {
                        HStack {
                            Image(systemName: "applelogo")
                            Text("AI Insights")
                                .font(.headline.bold())
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(14)
                        .shadow(color: .blue.opacity(0.3), radius: 6, x: 0, y: 3)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 4)
                    
                    // Actions Stack
                    Button {
                        showPopup = false
                        generateRound()
                    } label: {
                        Text("Next Round")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .cornerRadius(14)
                            .shadow(color: Color.blue.opacity(0.25), radius: 6, x: 0, y: 3)
                    }
                    .buttonStyle(.plain)
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
        .onChange(of: showPopup) { newValue in
            if newValue {
                let details = "S=\(String(format: "%.1f", s))m, T=\(String(format: "%.1f", t))s, V=\(String(format: "%.1f", v))m/s"
                Task {
                    await aiManager.generateAppleFoundationInsight(
                        topic: "free fall",
                        userAns: userAnswer,
                        correctAns: "\(correctAnswer)",
                        details: details
                    )
                }
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
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showHint = false
                    }
                
                let hint = getHintText()
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 10) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.yellow)
                            .font(.title3)
                        Text("Solver Hint")
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
                            Text(hint.title)
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            Text(hint.explanation)
                                .font(.body)
                                .foregroundColor(.primary)
                                .lineSpacing(4)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Formula to Use:")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.primary)
                                Text(hint.formula)
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
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Step-by-Step for Current Values:")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.primary)
                                Text(hint.example)
                                    .font(.system(.subheadline, design: .monospaced))
                                    .foregroundColor(.primary.opacity(0.85))
                                    .padding(12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(.secondarySystemGroupedBackground))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                                    )
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
}
