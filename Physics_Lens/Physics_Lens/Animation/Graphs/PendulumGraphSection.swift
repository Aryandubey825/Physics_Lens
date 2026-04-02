import SwiftUI

struct PendulumGraphWithValues: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(spacing: 8) {
                Image(systemName: "chart.xyaxis.line")
                    .foregroundColor(.blue)
                Text("Angle (θ) vs Time (t)")
                    .font(.headline)
            }
            
            ZStack {
                
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.18),
                        Color.gray.opacity(0.12)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .clipShape(RoundedRectangle(cornerRadius: 18))
                
                GeometryReader { geo in
                    Canvas { context, size in
                        
                        let midY = size.height / 2
                        let width = size.width
                        let height = size.height
                        
                        let amplitude: CGFloat = 40
                        let cycles: CGFloat = 2
                        let steps = 300
                        
                        
                        var wave = Path()
                        for i in 0...steps {
                            let x = CGFloat(i) / CGFloat(steps) * width
                            let angle = CGFloat(i) / CGFloat(steps) * cycles * 2 * .pi
                            let y = midY - amplitude * sin(angle)
                            
                            if i == 0 {
                                wave.move(to: CGPoint(x: x, y: y))
                            } else {
                                wave.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                        
                        context.stroke(wave, with: .color(.cyan), lineWidth: 3)
                        
                        // ─── X Axis
                        var xAxis = Path()
                        xAxis.move(to: CGPoint(x: 0, y: midY))
                        xAxis.addLine(to: CGPoint(x: width, y: midY))
                        context.stroke(xAxis, with: .color(.gray), lineWidth: 1)
                        
                        // ─── Y Axis
                        var yAxis = Path()
                        yAxis.move(to: CGPoint(x: 30, y: 0))
                        yAxis.addLine(to: CGPoint(x: 30, y: height))
                        context.stroke(yAxis, with: .color(.gray), lineWidth: 1)
                    }
                }
                
               
                VStack {
                    Text("+θ max")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("0")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("-θ max")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.leading, 6)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 220)
            
           
            HStack {
                Text("0 s")
                Spacer()
                Text("T/2")
                Spacer()
                Text("T")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 6)
        }
        .padding(.horizontal)
    }
}
