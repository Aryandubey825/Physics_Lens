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
                
                let boxCenterY = groundY - boxHeight/2
                let range = geo.size.width > 0 ? geo.size.width : 400
                let k_center = Int(floor((position + geo.size.width / 2) / range))
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemGray6))
                    
                    
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: groundY))
                        path.addLine(to: CGPoint(x: geo.size.width, y: groundY))
                    }
                    .stroke(.gray, lineWidth: 2)
                    
                    
                    ForEach(Array((k_center - 1)...(k_center + 1)), id: \.self) { k in
                        let currentBoxCenterX = geo.size.width / 2 + position - CGFloat(k) * range
                        let currentBoxLeftEdge = currentBoxCenterX - boxWidth/2
                        let currentBoxRightEdge = currentBoxCenterX + boxWidth/2
                        
                        Rectangle()
                            .fill(.brown)
                            .frame(width: boxWidth, height: boxHeight)
                            .position(x: currentBoxCenterX, y: boxCenterY)
                            .animation(.easeOut(duration: 1), value: position)
                        
                        Text("🏃")
                            .font(.system(size: 55))
                            .scaleEffect(x: -1, y: 1)
                            .position(
                                x: currentBoxLeftEdge - 25,
                                y: groundY - 27.5
                            )
                            .animation(.easeOut(duration: 1), value: position)
                        
                        ArrowShape()
                            .fill(.red)
                            .frame(width: CGFloat(friction), height: 8)
                            .rotationEffect(.degrees(180))
                            .position(
                                x: currentBoxRightEdge + CGFloat(friction)/2,
                                y: boxCenterY
                            )
                            .animation(.easeOut(duration: 1), value: position)
                    }
                    
                   
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
