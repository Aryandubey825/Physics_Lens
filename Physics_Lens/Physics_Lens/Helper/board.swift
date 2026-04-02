
import SwiftUI

struct RoughBoardView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var lines: [[CGPoint]] = []
    @State private var currentLine: [CGPoint] = []
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                Canvas { context, size in
                    for line in lines {
                        var path = Path()
                        path.addLines(line)
                        context.stroke(path, with: .color(.black), lineWidth: 3)
                    }
                    
                    var currentPath = Path()
                    currentPath.addLines(currentLine)
                    context.stroke(currentPath, with: .color(.black), lineWidth: 3)
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            currentLine.append(value.location)
                        }
                        .onEnded { _ in
                            lines.append(currentLine)
                            currentLine = []
                        }
                )
            }
            .navigationTitle("Rough Work Board")
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear") {
                        lines = []
                    }
                }
            }
        }
    }
}
