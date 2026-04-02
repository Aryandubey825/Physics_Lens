import SwiftUI

struct EarthMoonCompareView: View {
    
    @State private var height: Double = 20   // meters
    
    let earthG: Double = 9.8
    let moonG: Double = 1.6
    
    var earthTime: Double {
        sqrt((2 * height) / earthG)
    }
    
    var moonTime: Double {
        sqrt((2 * height) / moonG)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            
            Text("Earth vs Moon")
                .font(.largeTitle.bold())
            
            Text("Same height, different gravity")
                .foregroundStyle(.secondary)
            
            HStack(spacing: 16) {
                
                CompareFallCard(
                    title: "Earth",
                    gravity: earthG,
                    height: height,
                    color: .blue
                )
                
                CompareFallCard(
                    title: "Moon",
                    gravity: moonG,
                    height: height,
                    color: .gray
                )
            }
            
            VStack(alignment: .leading) {
                Text("Height: \(String(format: "%.1f", height)) m")
                Slider(value: $height, in: 5...50, step: 1)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Time of Fall")
                    .font(.headline)
                
                Text("Earth: \(String(format: "%.2f", earthTime)) s")
                Text("Moon: \(String(format: "%.2f", moonTime)) s")
            }
            .padding()
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding()
    }
}



struct CompareFallCard: View {
    
    let title: String
    let gravity: Double
    let height: Double
    let color: Color
    
    var timeOfFall: Double {
        sqrt((2 * height) / gravity)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            
            Text(title)
                .font(.headline)
            
            GeometryReader { geo in
                TimelineView(.animation) { timeline in
                    
                    let time = timeline.date.timeIntervalSinceReferenceDate
                    let t = min(time.truncatingRemainder(dividingBy: timeOfFall), timeOfFall)
                    let progress = t / timeOfFall
                    
                    let topY: CGFloat = 12
                    let bottomY: CGFloat = geo.size.height - 12
                    let yPos = topY + CGFloat(progress) * (bottomY - topY)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                        
                        Circle()
                            .fill(color)
                            .frame(width: 14, height: 14)
                            .position(
                                x: geo.size.width / 2,
                                y: yPos
                            )
                    }
                }
            }
            .frame(height: 180)
            
            Text("g = \(gravity) m/s²")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
