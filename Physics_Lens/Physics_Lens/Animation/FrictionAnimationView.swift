import SwiftUI

struct FrictionAnimationView: View {
    
    @State private var force: Double = 40
    @State private var friction: Double = 25
    @State private var position: CGFloat = 0
    
    var netForce: Double {
        force - friction
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            GeometryReader { geo in
                
                let groundY = geo.size.height * 0.75
                
                let boxWidth: CGFloat = 70
                let boxHeight: CGFloat = 60
                
                let boxCenterX = geo.size.width / 2 + position
                let boxCenterY = groundY - boxHeight/2
                
                let boxLeftEdge = boxCenterX - boxWidth/2
                let boxRightEdge = boxCenterX + boxWidth/2
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemGray6))
                    
                    
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: groundY))
                        path.addLine(to: CGPoint(x: geo.size.width, y: groundY))
                    }
                    .stroke(.gray, lineWidth: 2)
                    
                 
                    Rectangle()
                        .fill(.brown)
                        .frame(width: boxWidth, height: boxHeight)
                        .position(x: boxCenterX, y: boxCenterY)
                        .animation(.easeOut(duration: 1), value: position)
                    
                    
                    ArrowShape()
                        .fill(.green)
                        .frame(width: CGFloat(force), height: 8)
                        .position(
                            x: boxLeftEdge - CGFloat(force)/2,
                            y: boxCenterY
                        )
                    
                    
                    ArrowShape()
                        .fill(.red)
                        .frame(width: CGFloat(friction), height: 8)
                        .rotationEffect(.degrees(180))
                        .position(
                            x: boxRightEdge + CGFloat(friction)/2,
                            y: boxCenterY
                        )
                    
                   
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Force: \(Int(force)) N")
                        Text("Friction: \(Int(friction)) N")
                        Text("Net: \(Int(netForce)) N")
                            .bold()
                    }
                    .font(.caption)
                    .padding(8)
                    .background(Color.black.opacity(0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .foregroundColor(.white)
                    .padding()
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .topTrailing
                    )
                }
            }
            .frame(height: 260)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            
           
            VStack(spacing: 12) {
                
                VStack(alignment: .leading) {
                    Text("Applied Force: \(Int(force)) N")
                    Slider(value: $force, in: 0...150)
                }
                
                VStack(alignment: .leading) {
                    Text("Friction Force: \(Int(friction)) N")
                    Slider(value: $friction, in: 0...150)
                }
            }
            
           
            Button("Apply Force") {
                if netForce > 0 {
                    position += 120
                }
            }
            .buttonStyle(.borderedProminent)
            
            Button("Reset") {
                position = 0
            }
            .buttonStyle(.bordered)
        }
    }
}
struct ArrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width - 10, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width - 10, y: rect.midY - 6))
        path.addLine(to: CGPoint(x: rect.width, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width - 10, y: rect.midY + 6))
        path.addLine(to: CGPoint(x: rect.width - 10, y: rect.midY))
        
        return path
    }
}
