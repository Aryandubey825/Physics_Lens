import SwiftUI

struct FreeFallVelocityTimeGraph: View {
    
    
    let g: CGFloat = 9.8
    let maxTime: CGFloat = 5.0  // seconds
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
           
            HStack(spacing: 8) {
                Image(systemName: "chart.xyaxis.line")
                    .foregroundColor(.blue)
                Text("Velocity–Time Graph (Free Fall)")
                    .font(.headline)
            }
            
            ZStack {
                
               
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.15),
                        Color.white
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .clipShape(RoundedRectangle(cornerRadius: 18))
                
                GeometryReader { geo in
                    Canvas { context, size in
                        
                        let width = size.width
                        let height = size.height
                        let origin = CGPoint(x: 40, y: height - 40)
                        
                        let xScale = (width - 80) / maxTime
                        let yScale: CGFloat = 10
                        
                       
                        var axes = Path()
                        axes.move(to: origin)
                        axes.addLine(to: CGPoint(x: width - 20, y: origin.y)) // x-axis
                        axes.move(to: origin)
                        axes.addLine(to: CGPoint(x: origin.x, y: 20)) // y-axis
                        
                        context.stroke(axes, with: .color(.gray), lineWidth: 1)
                        
                        var vtLine = Path()
                        vtLine.move(to: origin)
                        
                        let endPoint = CGPoint(
                            x: origin.x + maxTime * xScale,
                            y: origin.y - g * yScale
                        )
                        vtLine.addLine(to: endPoint)
                        
                        context.stroke(vtLine, with: .color(.cyan), lineWidth: 3)
                        
                        context.draw(
                            Text("Slope = g")
                                .font(.caption.bold())
                                .foregroundColor(.blue),
                            at: CGPoint(x: endPoint.x - 40, y: endPoint.y - 20)
                        )
                        
                        context.draw(
                            Text("t (s)")
                                .font(.caption)
                                .foregroundColor(.secondary),
                            at: CGPoint(x: width - 30, y: origin.y + 12)
                        )
                        
                        context.draw(
                            Text("v (m/s)")
                                .font(.caption)
                                .foregroundColor(.secondary),
                            at: CGPoint(x: origin.x - 20, y: 20)
                        )
                        
                        context.draw(
                            Text("0")
                                .font(.caption)
                                .foregroundColor(.secondary),
                            at: CGPoint(x: origin.x - 12, y: origin.y + 10)
                        )
                    }
                }
            }
            .frame(height: 220)
        }
        .padding(.horizontal)
    }
}

