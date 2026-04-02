import SwiftUI

struct ProjectileGraphView: View {
    var body: some View {
        Canvas { context, size in
            
            let w = size.width
            let h = size.height
            
            let groundY = h * 0.75
            let startX: CGFloat = 40
            let endX: CGFloat = w - 40
            
            var ground = Path()
            ground.move(to: CGPoint(x: startX, y: groundY))
            ground.addLine(to: CGPoint(x: endX, y: groundY))
            context.stroke(ground, with: .color(.purple), lineWidth: 2)
            
            context.draw(
                Text("Range (R)")
                    .font(.caption.bold())
                    .foregroundColor(.purple),
                at: CGPoint(x: w / 2, y: groundY + 12)
            )
            
            var path = Path()
            path.move(to: CGPoint(x: startX, y: groundY))
            
            for t in stride(from: 0.0, through: 1.0, by: 0.02) {
                let x = startX + (endX - startX) * t
                let y = groundY - 120 * (4 * t * (1 - t))
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            context.stroke(path, with: .color(.cyan), lineWidth: 3)
            
            context.draw(
                Text("Vy = 0")
                    .font(.caption.bold())
                    .foregroundColor(.red),
                at: CGPoint(x: w / 2, y: groundY - 130)
            )
            
            drawArrow(
                context: context,
                from: CGPoint(x: startX, y: groundY),
                to: CGPoint(x: startX, y: groundY - 50),
                color: .red
            )
            
            drawArrow(
                context: context,
                from: CGPoint(x: startX, y: groundY),
                to: CGPoint(x: startX + 55, y: groundY),
                color: .green
            )
            
            drawArrow(
                context: context,
                from: CGPoint(x: startX, y: groundY),
                to: CGPoint(x: startX + 45, y: groundY - 45),
                color: .blue
            )
            
           
            drawLabel(context, text: "Vy", at: CGPoint(x: startX - 12, y: groundY - 30), color: .red)
            drawLabel(context, text: "Vx", at: CGPoint(x: startX + 30, y: groundY + 12), color: .green)
            drawLabel(context, text: "V", at: CGPoint(x: startX + 30, y: groundY - 40), color: .blue)
            
            drawArrow(
                context: context,
                from: CGPoint(x: endX, y: groundY),
                to: CGPoint(x: endX, y: groundY - 50),
                color: .red
            )
            
            drawArrow(
                context: context,
                from: CGPoint(x: endX, y: groundY),
                to: CGPoint(x: endX - 55, y: groundY),
                color: .green
            )
            
            drawArrow(
                context: context,
                from: CGPoint(x: endX, y: groundY),
                to: CGPoint(x: endX - 45, y: groundY - 45),
                color: .blue
            )
            
          
            drawLabel(context, text: "Vy", at: CGPoint(x: endX + 12, y: groundY - 30), color: .red)
            drawLabel(context, text: "Vx", at: CGPoint(x: endX - 30, y: groundY + 12), color: .green)
            drawLabel(context, text: "V", at: CGPoint(x: endX - 30, y: groundY - 40), color: .blue)
        }
        .frame(height: 260)
        .padding()
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

func drawArrow(
    context: GraphicsContext,
    from start: CGPoint,
    to end: CGPoint,
    color: Color
) {
    var path = Path()
    path.move(to: start)
    path.addLine(to: end)
    
    let angle = atan2(end.y - start.y, end.x - start.x)
    let arrowSize: CGFloat = 8
    
    let p1 = CGPoint(
        x: end.x - arrowSize * cos(angle - .pi / 6),
        y: end.y - arrowSize * sin(angle - .pi / 6)
    )
    
    let p2 = CGPoint(
        x: end.x - arrowSize * cos(angle + .pi / 6),
        y: end.y - arrowSize * sin(angle + .pi / 6)
    )
    
    path.addLine(to: p1)
    path.move(to: end)
    path.addLine(to: p2)
    
    context.stroke(path, with: .color(color), lineWidth: 2)
}

func drawLabel(
    _ context: GraphicsContext,
    text: String,
    at point: CGPoint,
    color: Color
) {
    context.draw(
        Text(text)
            .font(.caption.bold())
            .foregroundColor(color),
        at: point
    )
}
