import SwiftUI
import FoundationModels
import AVFoundation

@available(iOS 26.0, *)
struct FrictionGame: View {
    
    @StateObject private var voiceManager = VoiceAssistantManager()
    @StateObject private var aiManager = AIFeedbackManager()
    
    @State private var showBoard = false
    @State private var showFormula = false
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
        VStack(spacing: 0) {
            
            Text("Friction Challenge Arena")
                .font(.system(size: 30, weight: .bold))
            
            ZStack {
                LinearGradient(
                    colors: [.black, .blue.opacity(0.8)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 15) {
                    topBar
                    surfaceInfoCard
                    surfaceArea
                }
            }
            .frame(height: 450)
            
            bottomControls
        }
        .overlay(
            ZStack {
                popupOverlay
                formulaOverlay
            }
        )
        .onAppear { newRound() }
    }
    
    // MARK: Top Bar
    var topBar: some View {
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
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Image("box")
                .resizable()
                .frame(width: 55, height: 55)
                .offset(x: boxOffset)
                .padding(.bottom, 25)
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
            
            Button("Show Formula") {
                showFormula = true
            }
        }
        .padding()
        .background(Color(.systemGray6))
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
    
    // MARK: Formula Overlay
    var formulaOverlay: some View {
        Group {
            if showFormula {
                VStack(spacing: 10) {
                    Text("📘 Friction Formulas")
                        .font(.headline)
                    
                    Text("Fₛ(max) = μₛ mg")
                    Text("Fₖ = μₖ mg")
                    Text("a = (F - Fₖ)/m")
                    
                    Button("Close") {
                        showFormula = false
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .padding()
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
                    boxOffset = 260
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
