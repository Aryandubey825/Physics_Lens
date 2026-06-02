import SwiftUI
import FoundationModels
import AVFoundation

@available(iOS 26.0, *)
struct FrictionGame: View {
    
    @StateObject private var voiceManager = VoiceAssistantManager()
    @StateObject private var aiManager = AIFeedbackManager()
    
    @State private var showBoard = false
    @State private var showHint = false
    @State private var showPopup = false
    @State private var showAISheet = false
    
    @State private var selectedSurface: Surface = surfaces[0]
    @State private var questionType: QuestionType = .move
    
    @State private var mass: Double = 10
    @State private var appliedForce: Double = 50
    
    @State private var randomMode = true
    
    @State private var userAnswer = ""
    @State private var score = 0
    @State private var answeredCorrectly = false
    
    @State private var boxOffset: CGFloat = 0
    
    let g = 9.8
    
    enum QuestionType: CaseIterable {
        case move
        case acceleration
    }
    
    var maxStaticForce: Double {
        selectedSurface.staticFriction * mass * g
    }
    
    var kineticForce: Double {
        selectedSurface.kineticFriction * mass * g
    }
    
    var willMove: Bool {
        appliedForce > maxStaticForce
    }
    
    var acceleration: Double {
        willMove ? (appliedForce - kineticForce) / mass : 0
    }
    
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
                Text("Friction Challenge Arena")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(.top, 15)
                    .padding(.bottom, 10)
                
                GeometryReader { geometry in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 18) {
                            topBar
                            surfaceInfoCard
                            surfaceArea
                            bottomControls
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
        .onAppear { newRound() }
    }
    
    // MARK: Top Bar
    var topBar: some View {
        HStack {
            
            Text("Score: \(score)")
                .foregroundColor(.primary)
                .padding(.leading)
            
            Spacer()
            
            Button {
                voiceManager.speakFrictionQuestion(
                    mass: mass,
                    force: appliedForce,
                    staticMu: selectedSurface.staticFriction,
                    kineticMu: selectedSurface.kineticFriction,
                    questionType: questionType == .move ? "Will it move" : "Find acceleration"
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
    }
    
    // MARK: Surface Info
    var surfaceInfoCard: some View {
        VStack(spacing: 4) {
            Text("Surface: \(selectedSurface.name)")
                .font(.headline)
            
            Text("μₛ = \(selectedSurface.staticFriction, specifier: "%.2f")")
            Text("μₖ = \(selectedSurface.kineticFriction, specifier: "%.2f")")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .cornerRadius(18)
        .padding(.horizontal)
    }
    
    // MARK: Surface Area
    var surfaceArea: some View {
        ZStack(alignment: .bottomLeading) {
            
            Image(selectedSurface.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Image("box")
                .resizable()
                .scaledToFit()
                .frame(width: 170, height: 170)
                .offset(x: boxOffset)
                .padding(.bottom, 15)
        }
        .padding(.horizontal)
    }
    
    // MARK: Bottom Controls
    var bottomControls: some View {
        VStack(spacing: 14) {
            
            Toggle("Random Surface Mode", isOn: $randomMode)
                .onChange(of: randomMode) {
                    newRound()
                }
                .padding(.horizontal)
            
            if !randomMode {
                surfaceSelector
            }
            
            Text("Mass = \(Int(mass)) kg")
            Text("Applied Force = \(Int(appliedForce)) N")
            
            if questionType == .move {
                Text("Will the box move? (Yes/No)")
                    .font(.headline)
            } else {
                Text("Find Acceleration (m/s²)")
                    .font(.headline)
            }
            
            TextField("Enter Answer", text: $userAnswer)
                .textFieldStyle(.roundedBorder)
            
            // ✅ FIXED FULL WIDTH CLICKABLE BUTTON
            Button {
                checkAnswer()
            } label: {
                Text("Submit")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .contentShape(Rectangle())
            }
            
            Button {
                showHint = true
            } label: {
                HStack {
                    Image(systemName: "lightbulb.fill")
                    Text("Hint")
                }
                .font(.headline)
                .foregroundColor(.orange)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
    
    var surfaceSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(surfaces) { surface in
                    Button {
                        selectedSurface = surface
                        newRound()
                    } label: {
                        Text(surface.name)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(
                                selectedSurface.id == surface.id ?
                                Color.green : Color.blue
                            )
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: Hint Overlay
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
                                
                                if questionType == .move {
                                    Text("To check if the box moves, compare the Applied Force (F) with the Maximum Static Friction Force (F_static,max):")
                                        .font(.footnote)
                                        .foregroundColor(.primary)
                                    
                                    Text("F_static,max = μ_s × m × g")
                                        .font(.system(.body, design: .monospaced))
                                        .bold()
                                        .padding(6)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(6)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Current Values:")
                                            .font(.caption.bold())
                                        Text("• Applied Force (F) = \(Int(appliedForce)) N")
                                        Text("• Mass (m) = \(Int(mass)) kg")
                                        Text("• Coefficient (μ_s) = \(selectedSurface.staticFriction, specifier: "%.2f")")
                                        Text("• Gravity (g) = 9.8 m/s²")
                                    }
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Step-by-Step Calculation:")
                                            .font(.caption.bold())
                                        
                                        Text("F_static,max = \(selectedSurface.staticFriction, specifier: "%.2f") × \(Int(mass)) × 9.8 = \(String(format: "%.1f", maxStaticForce)) N")
                                            .font(.system(.footnote, design: .monospaced))
                                            .padding(6)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(6)
                                        
                                        if appliedForce > maxStaticForce {
                                            Text("Since Applied Force (\(Int(appliedForce)) N) is greater than F_static,max (\(String(format: "%.1f", maxStaticForce)) N), the box will move (Yes).")
                                                .font(.footnote.bold())
                                                .foregroundColor(.green)
                                                .padding(.top, 4)
                                        } else {
                                            Text("Since Applied Force (\(Int(appliedForce)) N) is less or equal to F_static,max (\(String(format: "%.1f", maxStaticForce)) N), the box will not move (No).")
                                                .font(.footnote.bold())
                                                .foregroundColor(.red)
                                                .padding(.top, 4)
                                        }
                                    }
                                } else {
                                    Text("First, verify if the box moves (Applied Force > F_static,max):")
                                        .font(.footnote)
                                        .foregroundColor(.primary)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("F_static,max = μ_s × m × g = \(String(format: "%.1f", maxStaticForce)) N")
                                            .font(.system(.footnote, design: .monospaced))
                                            .padding(6)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(6)
                                        
                                        Text("Applied Force = \(Int(appliedForce)) N")
                                            .font(.footnote)
                                    }
                                    
                                    if appliedForce > maxStaticForce {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("The box moves! Find acceleration using:")
                                                .font(.footnote.bold())
                                                .foregroundColor(.green)
                                            
                                            Text("a = (F - F_kinetic) / m")
                                                .font(.system(.body, design: .monospaced))
                                                .bold()
                                                .padding(6)
                                                .background(Color.blue.opacity(0.1))
                                                .cornerRadius(6)
                                            
                                            Text("Where Kinetic Friction Force (F_kinetic) is:")
                                                .font(.caption)
                                            Text("F_kinetic = μ_k × m × g\nF_kinetic = \(selectedSurface.kineticFriction, specifier: "%.2f") × \(Int(mass)) × 9.8 = \(String(format: "%.1f", kineticForce)) N")
                                                .font(.system(.caption, design: .monospaced))
                                                .padding(6)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .background(Color.gray.opacity(0.1))
                                                .cornerRadius(6)
                                            
                                            Text("Step-by-Step Calculation:")
                                                .font(.caption.bold())
                                            Text("a = (\(Int(appliedForce)) - \(String(format: "%.1f", kineticForce))) / \(Int(mass))\na ≈ \(String(format: "%.2f", acceleration)) m/s²")
                                                .font(.system(.footnote, design: .monospaced))
                                                .foregroundColor(.secondary)
                                                .padding(6)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .background(Color.gray.opacity(0.1))
                                                .cornerRadius(6)
                                        }
                                    } else {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("The box does not move because Applied Force (\(Int(appliedForce)) N) ≤ F_static,max (\(String(format: "%.1f", maxStaticForce)) N).")
                                                .font(.footnote.bold())
                                                .foregroundColor(.red)
                                            
                                            Text("Therefore, acceleration a = 0 m/s².")
                                                .font(.footnote)
                                            
                                            Text("a = 0 m/s²")
                                                .font(.system(.body, design: .monospaced))
                                                .bold()
                                                .padding(6)
                                                .background(Color.blue.opacity(0.1))
                                                .cornerRadius(6)
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxHeight: 300)
                        
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
    
    // MARK: Popup
    var popupOverlay: some View {
        ZStack {
            if showPopup {
                Color.black.opacity(0.3).ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    Text(answeredCorrectly ? "✅ Correct!" : "❌ Wrong!")
                        .font(.title2.bold())
                    
                    statRow(title: "Max Static Force",
                            value: "\(String(format: "%.2f", maxStaticForce)) N")
                    
                    statRow(title: "Kinetic Force",
                            value: "\(String(format: "%.2f", kineticForce)) N")
                    
                    statRow(title: "Acceleration",
                            value: "\(String(format: "%.2f", acceleration)) m/s²")
                    
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
                        newRound()
                        showPopup = false
                    }
                    .buttonStyle(.bordered)
                }
                .padding(24)
                .background(.ultraThinMaterial)
                .cornerRadius(24)
                .frame(maxWidth: 350)
            }
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
    }
    
    // MARK: Game Logic
    func newRound() {
        if randomMode {
            selectedSurface = surfaces.randomElement()!
        }
        
        questionType = QuestionType.allCases.randomElement()!
        mass = Double(Int.random(in: 5...20))
        appliedForce = Double(Int.random(in: 20...120))
        userAnswer = ""
        boxOffset = 0
    }
    
    func checkAnswer() {
        if questionType == .move {
            let ans = userAnswer.lowercased()
            answeredCorrectly =
            (ans == "yes" && willMove) ||
            (ans == "no" && !willMove)
        } else if let val = Double(userAnswer) {
            answeredCorrectly = abs(val - acceleration) < 0.5
        }
        
        if answeredCorrectly {
            score += 1
            if willMove {
                withAnimation(.easeOut(duration: selectedSurface.animationSpeed)) {
                    boxOffset = 180
                }
            }
        }
        
        showPopup = true
    }
    
    func generateAIFeedback() {
        let result = GameResult(
            topic: "Friction",
            userInput: "Mass: \(mass), Force: \(appliedForce), Surface: \(selectedSurface.name)",
            correctConcept: "Fₛ(max)=μₛmg, Fₖ=μₖmg, a=(F-Fₖ)/m",
            userOutcome: answeredCorrectly ? "Correct" : "Incorrect",
            score: score
        )
        
        Task {
            await aiManager.analyze(result: result)
            showAISheet = true
        }
    }
    
    func statRow(title: String, value: String) -> some View {
        HStack {
            Text(title).foregroundColor(.secondary)
            Spacer()
            Text(value).bold()
        }
    }
}

// MARK: Surface Model
struct Surface: Identifiable {
    let id = UUID()
    let name: String
    let staticFriction: Double
    let kineticFriction: Double
    let imageName: String
    let animationSpeed: Double
}

let surfaces: [Surface] = [
    Surface(name: "Ice", staticFriction: 0.1, kineticFriction: 0.05, imageName: "iceTexture", animationSpeed: 0.8),
    Surface(name: "Wood", staticFriction: 0.4, kineticFriction: 0.3, imageName: "woodTexture", animationSpeed: 1.5),
    Surface(name: "Sand", staticFriction: 0.7, kineticFriction: 0.6, imageName: "sandTexture", animationSpeed: 2.5),
    Surface(name: "Metal", staticFriction: 0.3, kineticFriction: 0.2, imageName: "metalTexture", animationSpeed: 1.2)
]


