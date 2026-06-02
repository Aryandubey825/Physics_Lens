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

// MARK: - Embedded Drawing Board Card
struct EmbeddedRoughBoardView: View {
    @State private var lines: [[CGPoint]] = []
    @State private var currentLine: [CGPoint] = []
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "pencil.and.outline")
                    .foregroundColor(.blue)
                Text("Rough Work Board")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Button(action: {
                    lines = []
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "trash")
                        Text("Clear")
                    }
                    .font(.subheadline.bold())
                    .foregroundColor(.red)
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Divider()
            
            ZStack {
                Color.white.opacity(0.85) // white paper look
                    .cornerRadius(12)
                
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
            .frame(height: 150)
            .padding([.horizontal, .bottom], 12)
        }
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.08), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Visual Button Card for Rough Board
struct RoughBoardButtonCard: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: "pencil.and.outline")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding(10)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Rough Work Board")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("Tap to open drawing pad for calculations")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.footnote.bold())
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

