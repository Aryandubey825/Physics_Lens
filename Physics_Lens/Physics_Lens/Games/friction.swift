import SwiftUI
import AVFoundation

@available(iOS 26.0, *)
struct FrictionGame: View {
    
    @StateObject private var voiceManager = VoiceAssistantManager()
    
    @State private var showBoard = false
    @State private var showHint = false
    @State private var showPopup = false
    
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
    // MARK: Hint Overlay
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
                            Text("🎯 Solve Guide:")
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            if questionType == .move {
                                Text("To check if the box moves, compare the Applied Force (F) with the Maximum Static Friction Force (F_static,max):")
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .lineSpacing(4)
                                
                                Text("F_static,max = μ_s × m × g")
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
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Current Values:")
                                        .font(.subheadline.bold())
                                    Text("• Applied Force (F) = \(Int(appliedForce)) N")
                                    Text("• Mass (m) = \(Int(mass)) kg")
                                    Text("• Coefficient (μ_s) = \(selectedSurface.staticFriction, specifier: "%.2f")")
                                    Text("• Gravity (g) = 9.8 m/s²")
                                }
                                .font(.subheadline)
                                .foregroundColor(.primary.opacity(0.85))
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Step-by-Step Calculation:")
                                        .font(.subheadline.bold())
                                    
                                    Text("F_static,max = \(selectedSurface.staticFriction, specifier: "%.2f") × \(Int(mass)) × 9.8 = \(String(format: "%.1f", maxStaticForce)) N")
                                        .font(.system(.subheadline, design: .monospaced))
                                        .padding(12)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color(.secondarySystemGroupedBackground))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                                        )
                                    
                                    if appliedForce > maxStaticForce {
                                        Text("Since Applied Force (\(Int(appliedForce)) N) is greater than F_static,max (\(String(format: "%.1f", maxStaticForce)) N), the box will move (Yes).")
                                            .font(.body.bold())
                                            .foregroundColor(.green)
                                            .padding(.top, 4)
                                    } else {
                                        Text("Since Applied Force (\(Int(appliedForce)) N) is less or equal to F_static,max (\(String(format: "%.1f", maxStaticForce)) N), the box will not move (No).")
                                            .font(.body.bold())
                                            .foregroundColor(.red)
                                            .padding(.top, 4)
                                    }
                                }
                            } else {
                                Text("First, verify if the box moves (Applied Force > F_static,max):")
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .lineSpacing(4)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("F_static,max = μ_s × m × g = \(String(format: "%.1f", maxStaticForce)) N")
                                        .font(.system(.subheadline, design: .monospaced))
                                        .padding(10)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color(.secondarySystemGroupedBackground))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                                        )
                                    
                                    Text("Applied Force = \(Int(appliedForce)) N")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                if appliedForce > maxStaticForce {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("The box moves! Find acceleration using:")
                                            .font(.body.bold())
                                            .foregroundColor(.green)
                                            .padding(.top, 4)
                                        
                                        Text("a = (F - F_kinetic) / m")
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
                                        
                                        Text("Where Kinetic Friction Force (F_kinetic) is:")
                                            .font(.subheadline.bold())
                                        
                                        Text("F_kinetic = μ_k × m × g\nF_kinetic = \(selectedSurface.kineticFriction, specifier: "%.2f") × \(Int(mass)) × 9.8 = \(String(format: "%.1f", kineticForce)) N")
                                            .font(.system(.subheadline, design: .monospaced))
                                            .padding(10)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color(.secondarySystemGroupedBackground))
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                                            )
                                        
                                        Text("Step-by-Step Calculation:")
                                            .font(.subheadline.bold())
                                        Text("a = (\(Int(appliedForce)) - \(String(format: "%.1f", kineticForce))) / \(Int(mass))\na ≈ \(String(format: "%.2f", acceleration)) m/s²")
                                            .font(.system(.subheadline, design: .monospaced))
                                            .foregroundColor(.primary.opacity(0.85))
                                            .padding(10)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color(.secondarySystemGroupedBackground))
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                                            )
                                    }
                                } else {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("The box does not move because Applied Force (\(Int(appliedForce)) N) ≤ F_static,max (\(String(format: "%.1f", maxStaticForce)) N).")
                                            .font(.body.bold())
                                            .foregroundColor(.red)
                                            .padding(.top, 4)
                                        
                                        Text("Therefore, acceleration a = 0 m/s².")
                                            .font(.body)
                                        
                                        Text("a = 0 m/s²")
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
                .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 24)
            }
        }
    }
    
    // MARK: Popup
    var popupOverlay: some View {
        ZStack {
            if showPopup {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                VStack(spacing: 20) {
                    // Status Badge Icon
                    let statusColor: Color = answeredCorrectly ? .green : .red
                    let statusIcon: String = answeredCorrectly ? "checkmark.seal.fill" : "xmark.seal.fill"
                    let statusTitle = answeredCorrectly ? "Correct!" : "Wrong!"
                    
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
                        statRow(title: "Max Static Force", value: "\(String(format: "%.2f", maxStaticForce)) N")
                        statRow(title: "Kinetic Force", value: "\(String(format: "%.2f", kineticForce)) N")
                        statRow(title: "Acceleration", value: "\(String(format: "%.2f", acceleration)) m/s²")
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
                            newRound()
                            showPopup = false
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


