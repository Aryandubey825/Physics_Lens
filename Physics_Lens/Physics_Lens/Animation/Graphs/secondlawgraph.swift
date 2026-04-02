import SwiftUI

struct NewtonSecondLawVisual: View {
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text("Newton’s Second Law")
                .font(.title.bold())
            
            Canvas { context, size in
                
                let w = size.width
                let h = size.height
                
                let groundY = h * 0.75
                
                var ground = Path()
                ground.move(to: CGPoint(x: 0, y: groundY))
                ground.addLine(to: CGPoint(x: w, y: groundY))
                context.stroke(ground, with: .color(.gray), lineWidth: 2)
                
                let boxRect = CGRect(x: w * 0.45, y: groundY - 80, width: 100, height: 80)
                context.fill(Path(roundedRect: boxRect, cornerRadius: 8),
                             with: .color(.brown))
                
                context.draw(
                    Text("m")
                        .font(.title.bold())
                        .foregroundColor(.white),
                    at: CGPoint(x: boxRect.midX, y: boxRect.midY)
                )
                
                drawArrow(
                    context: context,
                    from: CGPoint(x: w * 0.25, y: groundY - 40),
                    to: CGPoint(x: boxRect.minX, y: groundY - 40),
                    color: .red
                )
                
                drawLabel(
                    context,
                    text: "Force (F)",
                    at: CGPoint(x: w * 0.32, y: groundY - 60),
                    color: .red
                )
                
                drawArrow(
                    context: context,
                    from: CGPoint(x: boxRect.maxX, y: groundY - 40),
                    to: CGPoint(x: boxRect.maxX + 70, y: groundY - 40),
                    color: .green
                )
                
                drawLabel(
                    context,
                    text: "Acceleration (a)",
                    at: CGPoint(x: boxRect.maxX + 60, y: groundY - 60),
                    color: .green
                )
            }
            .frame(height: 250)
            .background(
                LinearGradient(
                    colors: [.blue.opacity(0.15), .white],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Text("F = ma")
                .font(.title2.bold())
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Color.red.opacity(0.15))
                .clipShape(Capsule())
        }
        .padding()
    }
}
