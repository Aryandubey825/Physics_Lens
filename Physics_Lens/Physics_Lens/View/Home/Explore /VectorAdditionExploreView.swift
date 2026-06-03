import SwiftUI

struct VectorAdditionExploreView: View {
    @State private var magA: Double = 60.0
    @State private var angleA: Double = 30.0 // degrees
    
    @State private var magB: Double = 50.0
    @State private var angleB: Double = 120.0 // degrees
    
    // Components
    var ax: Double { magA * cos(angleA * .pi / 180.0) }
    var ay: Double { magA * sin(angleA * .pi / 180.0) }
    
    var bx: Double { magB * cos(angleB * .pi / 180.0) }
    var by: Double { magB * sin(angleB * .pi / 180.0) }
    
    var rx: Double { ax + bx }
    var ry: Double { ay + by }
    
    var magR: Double { sqrt(rx * rx + ry * ry) }
    var angleR: Double {
        let rad = atan2(ry, rx)
        let deg = rad * 180.0 / .pi
        return deg < 0 ? deg + 360.0 : deg
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Vector Addition")
                    .font(.largeTitle.bold())
                    .padding(.top)
                
                Text("Vectors have both magnitude and direction. They are added geometrically using the head-to-tail method or the parallelogram law.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Vector Canvas
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .background(Color.blue.opacity(0.08))
                        .frame(height: 300)
                    
                    GeometryReader { geo in
                        let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2 + 20)
                        
                        // Draw Grid lines
                        Path { path in
                            // Horizontal axis
                            path.move(to: CGPoint(x: 20, y: center.y))
                            path.addLine(to: CGPoint(x: geo.size.width - 20, y: center.y))
                            
                            // Vertical axis
                            path.move(to: CGPoint(x: center.x, y: 20))
                            path.addLine(to: CGPoint(x: center.x, y: geo.size.height - 20))
                        }
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                        
                        // Let's scale vectors so 100 units = 80 pixels
                        let scale: CGFloat = 1.0
                        
                        let endA = CGPoint(
                            x: center.x + CGFloat(ax) * scale,
                            y: center.y - CGFloat(ay) * scale // Y goes down in UIKit/SwiftUI
                        )
                        
                        let endB = CGPoint(
                            x: center.x + CGFloat(bx) * scale,
                            y: center.y - CGFloat(by) * scale
                        )
                        
                        let endR = CGPoint(
                            x: center.x + CGFloat(rx) * scale,
                            y: center.y - CGFloat(ry) * scale
                        )
                        
                        // Vector A (Solid Blue)
                        VectorArrow(start: center, end: endA, color: .blue, label: "A")
                        
                        // Vector B (Faint solid orange from origin)
                        VectorArrow(start: center, end: endB, color: .orange.opacity(0.4), label: "")
                        
                        // Vector B shifted (Head-to-tail: from end of A to end of R)
                        VectorArrow(start: endA, end: endR, color: .orange, label: "B", isDashed: true)
                        
                        // Resultant R (Solid Red)
                        VectorArrow(start: center, end: endR, color: .red, label: "R")
                    }
                }
                .frame(height: 300)
                .padding(.horizontal)
                
                HStack(spacing: 12) {
                    ExploreResultCard(title: "Resultant |R|", value: String(format: "%.1f u", magR))
                    ExploreResultCard(title: "Angle (θR)", value: String(format: "%.1f°", angleR))
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Vector Components")
                        .font(.headline)
                    
                    Text("Vector A: (\(String(format: "%.1f", ax)) î + \(String(format: "%.1f", ay)) ĵ)")
                    Text("Vector B: (\(String(format: "%.1f", bx)) î + \(String(format: "%.1f", by)) ĵ)")
                    Text("Resultant R: (\(String(format: "%.1f", rx)) î + \(String(format: "%.1f", ry)) ĵ)")
                }
                .font(.system(.subheadline, design: .monospaced))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                
                VStack(spacing: 16) {
                    ExploreControlSlider(title: "Vector A Magnitude", value: $magA, range: 10...90, suffix: "")
                    ExploreControlSlider(title: "Vector A Angle", value: $angleA, range: 0...360, suffix: "°")
                    ExploreControlSlider(title: "Vector B Magnitude", value: $magB, range: 10...90, suffix: "")
                    ExploreControlSlider(title: "Vector B Angle", value: $angleB, range: 0...360, suffix: "°")
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Mathematical Formulas")
                        .font(.headline)
                    
                    Text("Magnitude: R = √(A² + B² + 2AB cos(θ))")
                    Text("Direction: tan(α) = B sin(θ) / (A + B cos(θ))")
                    Text("where θ is the angle between A and B, and α is angle of R relative to A.")
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
                    
                    Text("1. Head-to-Tail Rule: Place the tail of vector B at the head of vector A. The resultant R goes from the start of A to the end of B.")
                    Text("2. Analytical Method: Split vectors into horizontal (x) and vertical (y) components, add them independently, then reconstruct the resultant.")
                    Text("3. Commutative Property: Vector addition is commutative, meaning A + B = B + A. The order of addition does not change the resultant vector.")
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
    }
}

struct VectorArrow: View {
    let start: CGPoint
    let end: CGPoint
    let color: Color
    let label: String
    var isDashed: Bool = false
    
    var body: some View {
        ZStack {
            // Draw Line
            Path { path in
                path.move(to: start)
                path.addLine(to: end)
            }
            .stroke(color, style: StrokeStyle(lineWidth: 3, dash: isDashed ? [4] : []))
            
            // Draw Arrow Head
            Path { path in
                let angle = atan2(end.y - start.y, end.x - start.x)
                let arrowLength: CGFloat = 10
                let arrowAngle: CGFloat = .pi / 6
                
                let p1 = CGPoint(
                    x: end.x - arrowLength * cos(angle - arrowAngle),
                    y: end.y - arrowLength * sin(angle - arrowAngle)
                )
                let p2 = CGPoint(
                    x: end.x - arrowLength * cos(angle + arrowAngle),
                    y: end.y - arrowLength * sin(angle + arrowAngle)
                )
                
                path.move(to: end)
                path.addLine(to: p1)
                path.addLine(to: p2)
                path.closeSubpath()
            }
            .fill(color)
            
            // Draw Label
            if !label.isEmpty {
                let midPoint = CGPoint(
                    x: (start.x + end.x) / 2 + 12 * cos(atan2(end.y - start.y, end.x - start.x) + .pi / 2),
                    y: (start.y + end.y) / 2 + 12 * sin(atan2(end.y - start.y, end.x - start.x) + .pi / 2)
                )
                Text(label)
                    .font(.caption.bold())
                    .foregroundColor(color)
                    .position(midPoint)
            }
        }
    }
}
