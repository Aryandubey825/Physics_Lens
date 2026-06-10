import SwiftUI

@available(iOS 26.0, *)
struct PendulumGame: View {
    
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
                Text("Simple Pendulum")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(.top, 15)
                    .padding(.bottom, 10)
                
                GeometryReader { geometry in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 18) {
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
                                            .frame(width: 3, height: lengthPixels)
                                        
                                        Image("ball1")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50)
                                            .offset(y: lengthPixels)
                                    }
                                    .rotationEffect(.radians(angle), anchor: .top)
                                }
                                .padding(.top, 40)
                                
                                VStack {
                                    HStack {
                                        Text("Score: \(score)")
                                            .foregroundColor(.primary)
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
                                                .font(.title3)
                                                .padding(10)
                                                .background(.ultraThinMaterial)
                                                .clipShape(Circle())
                                        }
                                        
                                        Spacer().frame(width: 12)
                                    }
                                    .padding(.top, 20)
                                    
                                    Spacer()
                                }
                            }
                            .frame(height: 450)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                            .padding(.horizontal)
                            
                            VStack(spacing: 15) {
                                Toggle("Random Length Mode", isOn: $randomMode)
                                
                                let lengthMeters = lengthPixels / pixelToMeter
                                Text("Length: \(String(format: "%.2f", lengthMeters)) m")
                                
                                if !randomMode {
                                    Slider(value: $lengthPixels, in: 150...280)
                                }
                                
                                Picker("Gravity", selection: $gravity) {
                                    Text("Earth").tag(9.8)
                                    Text("Moon").tag(1.6)
                                    Text("Mars").tag(3.7)
                                }
                                .pickerStyle(.segmented)
                                
                                TextField("Time Period (seconds)", text: $userGuess)
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
        .overlay(
            ZStack {
                popupOverlay
                hintOverlay
            }
        )
        .onAppear {
            startPendulum()
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
                
                let lengthMeters = lengthPixels / pixelToMeter
                let correctT = realTimePeriod()
                
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
                            
                            Text("Time Period (T) equation:")
                                .font(.body)
                                .foregroundColor(.primary)
                            
                            Text("T = 2π × √(L / g)")
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
                                    .foregroundColor(.primary)
                                Text("• Length (L) = \(String(format: "%.2f", lengthMeters)) m")
                                Text("• Gravity (g) = \(gravity) m/s²")
                            }
                            .font(.subheadline)
                            .foregroundColor(.primary.opacity(0.85))
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Step-by-Step for Current Values:")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.primary)
                                Text("T = 2 × 3.1416 × √(\(String(format: "%.2f", lengthMeters)) / \(gravity))\nT ≈ \(String(format: "%.2f", correctT)) seconds")
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
    
    
    var popupOverlay: some View {
        ZStack {
            if showPopup {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                VStack(spacing: 20) {
                    // Status Badge Icon
                    let statusColor: Color = isCorrect ? .green : .red
                    let statusIcon: String = isCorrect ? "checkmark.seal.fill" : "xmark.seal.fill"
                    let statusTitle = isCorrect ? "Correct!" : "Incorrect"
                    
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
                        statRow(title: "Length", value: "\(String(format: "%.2f", lengthPixels/pixelToMeter)) m")
                        statRow(title: "Gravity", value: "\(gravity)")
                        statRow(title: "Correct T", value: "\(String(format: "%.2f", realTimePeriod())) s")
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
                            nextRound()
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
