import SwiftUI

struct PendulumAnimationView: View {
    
    @State private var length: Double = 1.0      // meters
    @State private var gravity: Double = 9.8     // m/s²
    @State private var phase: Double = 0
    
    var timePeriod: Double {
        2 * .pi * sqrt(length / gravity)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            
            GeometryReader { geo in
                TimelineView(.animation) { timeline in
                    
                    let time = timeline.date.timeIntervalSinceReferenceDate
                    let omega = (2 * .pi) / timePeriod
                    let angle = sin(time * omega) * 0.6   // swing angle
                    
                    let centerX = geo.size.width / 2
                    let topY: CGFloat = 20
                    let bobLength = CGFloat(length * 120)
                    
                    let bobX = centerX + sin(angle) * bobLength
                    let bobY = topY + cos(angle) * bobLength
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemGray6))
                        
                      
                        Path { path in
                            path.move(to: CGPoint(x: centerX, y: topY))
                            path.addLine(to: CGPoint(x: bobX, y: bobY))
                        }
                        .stroke(.gray, lineWidth: 2)
                        
                      
                        Circle()
                            .fill(.blue)
                            .frame(width: 20, height: 20)
                            .position(x: bobX, y: bobY)
                        
                       
                        Circle()
                            .fill(.black)
                            .frame(width: 6, height: 6)
                            .position(x: centerX, y: topY)
                        
                      
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Time Period")
                                .font(.caption)
                            Text(String(format: "%.2f s", timePeriod))
                                .font(.caption.bold())
                        }
                        .padding(8)
                        .background(Color.black.opacity(0.25))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .foregroundColor(.white)
                        .padding(12)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .topTrailing
                        )
                    }
                }
            }
            .frame(height: 260)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            
            VStack(spacing: 12) {
                
                VStack(alignment: .leading) {
                    Text("Length: \(String(format: "%.2f", length)) m")
                        .font(.subheadline)
                    Slider(value: $length, in: 0.5...2.5, step: 0.1)
                }
                
                VStack(alignment: .leading) {
                    Text("Gravity: \(String(format: "%.1f", gravity)) m/s²")
                        .font(.subheadline)
                    Slider(value: $gravity, in: 1...20, step: 0.1)
                }
            }
        }
    }
}
