import SwiftUI

struct Frictiongraph: View {
    
    var body: some View {
        Canvas { context, size in
            
            let origin = CGPoint(x: 50, y: size.height - 40)
            
            // X Axis
            var xAxis = Path()
            xAxis.move(to: origin)
            xAxis.addLine(to: CGPoint(x: size.width - 30, y: origin.y))
            context.stroke(xAxis, with: .color(.green), lineWidth: 2)
            
            // Y Axis
            var yAxis = Path()
            yAxis.move(to: origin)
            yAxis.addLine(to: CGPoint(x: 50, y: 30))
            context.stroke(yAxis, with: .color(.red), lineWidth: 2)
            
            // Line f = μN
            var line = Path()
            line.move(to: origin)
            line.addLine(to: CGPoint(x: origin.x + 200, y: origin.y - 120))
            context.stroke(line, with: .color(.blue), lineWidth: 3)
            
            drawLabel(context, text: "f = μN", at: CGPoint(x: 180, y: 100), color: .blue)
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
    }
}
