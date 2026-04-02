import SwiftUI

struct FreeFallAnimationView: View {
    
    @State private var height: Double = 20      // meters
    @State private var gravity: Double = 9.8    // m/s²
    
    var timeOfFall: Double {
        sqrt((2 * height) / gravity)
    }
    
    var finalVelocity: Double {
        gravity * timeOfFall
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
         
            GeometryReader { geo in
                TimelineView(.animation) { timeline in
                    
                    let time = timeline.date.timeIntervalSinceReferenceDate
                    let duration = timeOfFall
                    let t = min(time.truncatingRemainder(dividingBy: duration), duration)
                    
                    let progress = t / duration
                    
                    let topY: CGFloat = 20
                    let groundY: CGFloat = geo.size.height - 20
                    
                    let yPosition =
                    topY + CGFloat(progress) * (groundY - topY)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemGray6))
                        
                       
                        Circle()
                            .fill(.orange)
                            .frame(width: 18, height: 18)
                            .position(x: geo.size.width / 2, y: yPosition)
                        
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Time: \(String(format: "%.2f", timeOfFall)) s")
                            Text("Velocity: \(String(format: "%.2f", finalVelocity)) m/s")
                        }
                        .font(.caption.bold())
                        .padding(8)
                        .background(Color.black.opacity(0.25))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
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
                    Text("Height: \(String(format: "%.1f", height)) m")
                    Slider(value: $height, in: 5...50, step: 1)
                }
                
                VStack(alignment: .leading) {
                    Text("Gravity: \(String(format: "%.1f", gravity)) m/s²")
                    Slider(value: $gravity, in: 1...20, step: 0.1)
                }
            }
        }
    }
}
