import SwiftUI
import Combine

struct DopplerEffectExploreView: View {
    @State private var sourceVelocityRatio: Double = 0.5 // vs / v_sound (0.0 to 1.5)
    @State private var sourceFrequency: Double = 3.0    // waves per second
    
    @State private var sourceX: CGFloat = 50.0
    @State private var waves: [DopplerWave] = []
    @State private var tickCount: Int = 0
    @State private var canvasWidth: CGFloat = 400.0
    
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    let speedOfSound: CGFloat = 2.0 // pixels per frame
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Doppler Effect")
                    .font(.largeTitle.bold())
                    .padding(.top)
                
                Text("The change in frequency of a wave in relation to an observer who is moving relative to the wave source.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Sound Wave Canvas
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .background(Color.blue.opacity(0.08))
                        .frame(height: 280)
                    
                    GeometryReader { geo in
                        let h = geo.size.height
                        let w = geo.size.width
                        let centerY = h / 2
                        
                        // Draw all emitted sound waves
                        ForEach(waves) { wave in
                            Circle()
                                .stroke(Color.blue.opacity(max(0.0, 1.0 - Double(wave.radius / (w * 0.75)))), lineWidth: 1.5)
                                .frame(width: wave.radius * 2, height: wave.radius * 2)
                                .position(x: wave.centerX, y: centerY)
                        }
                        
                        // Sonic Boom / Mach Cone lines if supersonic
                        if sourceVelocityRatio > 1.0 {
                            let alpha = asin(1.0 / sourceVelocityRatio)
                            Path { path in
                                path.move(to: CGPoint(x: sourceX, y: centerY))
                                path.addLine(to: CGPoint(x: sourceX - 200, y: centerY - 200 * tan(CGFloat(alpha))))
                                path.move(to: CGPoint(x: sourceX, y: centerY))
                                path.addLine(to: CGPoint(x: sourceX - 200, y: centerY + 200 * tan(CGFloat(alpha))))
                            }
                            .stroke(Color.red.opacity(0.6), style: StrokeStyle(lineWidth: 2, dash: [4]))
                        }
                        
                        // Moving Jet / Source
                        Text(sourceVelocityRatio >= 1.0 ? "✈️" : "🔊")
                            .font(.title)
                            .position(x: sourceX, y: centerY)
                        
                        // Observers on the ground
                        let leftObserverX: CGFloat = 60
                        let rightObserverX: CGFloat = w - 60
                        let observerY = centerY + 80
                        
                        // Left Observer (A)
                        VStack(spacing: 2) {
                            Text("🧍")
                                .font(.title3)
                            Text("Observer A")
                                .font(.system(size: 8, weight: .bold))
                            
                            // Dynamic speech text
                            let leftText: String = {
                                if sourceVelocityRatio >= 1.0 {
                                    if sourceX < leftObserverX {
                                        return "Quiet..."
                                    } else {
                                        return "💥 BOOM!"
                                    }
                                } else if sourceX < leftObserverX {
                                    return "High Pitch 🔊"
                                } else {
                                    return "Low Pitch 🔉"
                                }
                            }()
                            
                            Text(leftText)
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(sourceX < leftObserverX ? .blue : .secondary)
                                .padding(4)
                                .background(Color(.systemBackground).opacity(0.85))
                                .cornerRadius(4)
                        }
                        .position(x: leftObserverX, y: observerY)
                        
                        // Right Observer (B)
                        VStack(spacing: 2) {
                            Text("🧍")
                                .font(.title3)
                            Text("Observer B")
                                .font(.system(size: 8, weight: .bold))
                            
                            // Dynamic speech text
                            let rightText: String = {
                                if sourceVelocityRatio >= 1.0 {
                                    if sourceX < rightObserverX {
                                        return "Silence..."
                                    } else {
                                        return "💥 BOOM!"
                                    }
                                } else {
                                    if sourceX < rightObserverX {
                                        return "High Pitch 🔊"
                                    } else {
                                        return "Low Pitch 🔉"
                                    }
                                }
                            }()
                            
                            Text(rightText)
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(sourceX < rightObserverX ? (sourceVelocityRatio >= 1.0 ? .secondary : .blue) : .secondary)
                                .padding(4)
                                .background(Color(.systemBackground).opacity(0.85))
                                .cornerRadius(4)
                        }
                        .position(x: rightObserverX, y: observerY)
                        
                        Color.clear
                            .onAppear {
                                canvasWidth = geo.size.width
                            }
                            .onChange(of: geo.size.width) { _, newValue in
                                canvasWidth = newValue
                            }
                    }
                }
                .frame(height: 280)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding(.horizontal)
                
                HStack(spacing: 12) {
                    ExploreResultCard(title: "Source Velocity", value: String(format: "%.2f Mach", sourceVelocityRatio))
                    let machAngleStr = sourceVelocityRatio > 1.0 ? String(format: "%.1f°", asin(1.0 / sourceVelocityRatio) * 180.0 / .pi) : "N/A"
                    ExploreResultCard(title: "Mach Cone Angle", value: machAngleStr)
                    ExploreResultCard(title: "Pitch (Front)", value: sourceVelocityRatio >= 1.0 ? "Sonic Boom" : (sourceVelocityRatio == 0 ? "Normal" : "High Pitch"))
                }
                .padding(.horizontal)
                
                VStack(spacing: 16) {
                    ExploreControlSlider(title: "Source Speed (vs/v)", value: $sourceVelocityRatio, range: 0.0...1.5, suffix: " Mach")
                    ExploreControlSlider(title: "Emitting Frequency", value: $sourceFrequency, range: 1.0...5.0, suffix: " Hz")
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Physics Equations")
                        .font(.headline)
                    
                    Text("Observer Frequency: f' = f * (v / (v ∓ vs))")
                    Text("Mach Cone Angle: sin(α) = v_sound / vs (for vs > v)")
                    Text("where v = speed of sound, vs = velocity of source")
                }
                .font(.system(.subheadline, design: .monospaced))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Concept Insight")
                        .font(.headline)
                    
                    Text("1. Subsonic (vs < v): Wavefronts bunch up ahead of the source, resulting in a higher observed frequency (blueshift). Behind the source, waves stretch out, lowering the frequency (redshift).")
                    Text("2. Transonic (vs = v): The source travels at the wave speed, causing all wavefronts to pile up in front, creating a barrier of high pressure (Sonic Boom).")
                    Text("3. Supersonic (vs > v): The source outruns its own waves, creating a V-shaped constructive interference wave envelope known as a Mach cone.")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
        .onReceive(timer) { _ in
            let w = canvasWidth
            
            // Move source
            let dx = CGFloat(sourceVelocityRatio * Double(speedOfSound))
            sourceX += dx
            
            if sourceX > w + 40 {
                sourceX = -20
                waves.removeAll()
            }
            
            // Increment wave radii
            for i in waves.indices {
                waves[i].radius += speedOfSound
            }
            
            // Filter out large waves
            waves.removeAll { $0.radius > w * 0.9 }
            
            // Emit new waves periodically based on frequency slider
            // 50 frames per second. We emit a wave every (50 / frequency) frames
            let emitInterval = Int(50.0 / sourceFrequency)
            tickCount += 1
            if tickCount >= emitInterval {
                tickCount = 0
                waves.append(DopplerWave(centerX: sourceX, radius: 0))
            }
        }
    }
}

struct DopplerWave: Identifiable {
    let id = UUID()
    let centerX: CGFloat
    var radius: CGFloat
}
