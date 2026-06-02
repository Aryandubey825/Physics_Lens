import SwiftUI

// MARK: - Physics Doodle Wallpaper Background
struct DoodleItem: Identifiable {
    let id = UUID()
    let systemName: String?
    let text: String?
    let x: CGFloat
    let y: CGFloat
    let rotation: Double
    let scale: CGFloat
}

struct PhysicsDoodleWallpaper: View {
    var body: some View {
        GeometryReader { geometry in
            let w = geometry.size.width
            let h = geometry.size.height
            
            ZStack {
                ForEach(physicsDoodles) { doodle in
                    Group {
                        if let systemName = doodle.systemName {
                            Image(systemName: systemName)
                                .font(.system(size: 24 * doodle.scale))
                        } else if let text = doodle.text {
                            Text(text)
                                .font(.system(size: 15 * doodle.scale, weight: .semibold, design: .serif))
                        }
                    }
                    .foregroundColor(Color.primary.opacity(0.08))
                    .rotationEffect(.degrees(doodle.rotation))
                    .position(x: doodle.x * w, y: doodle.y * h)
                }
            }
        }
    }
}

let physicsDoodles: [DoodleItem] = [
    // Icons
    DoodleItem(systemName: "atom", text: nil, x: 0.15, y: 0.1, rotation: 15, scale: 1.2),
    DoodleItem(systemName: "magnet.striped.in.magnetic.field", text: nil, x: 0.85, y: 0.15, rotation: -20, scale: 1.0),
    DoodleItem(systemName: "bolt.fill", text: nil, x: 0.45, y: 0.08, rotation: 10, scale: 0.8),
    DoodleItem(systemName: "lightbulb", text: nil, x: 0.7, y: 0.05, rotation: 5, scale: 1.1),
    DoodleItem(systemName: "gauge.with.needle", text: nil, x: 0.1, y: 0.4, rotation: -10, scale: 0.9),
    DoodleItem(systemName: "waveform", text: nil, x: 0.32, y: 0.66, rotation: 5, scale: 1.0),
    DoodleItem(systemName: "compass.drawing", text: nil, x: 0.85, y: 0.88, rotation: -15, scale: 1.1),
    DoodleItem(systemName: "chart.xyaxis.line", text: nil, x: 0.55, y: 0.92, rotation: 8, scale: 1.05),
    
    // Formulas
    DoodleItem(systemName: nil, text: "F = ma", x: 0.3, y: 0.18, rotation: -5, scale: 1.0),
    DoodleItem(systemName: nil, text: "E = mc²", x: 0.65, y: 0.22, rotation: 12, scale: 1.1),
    DoodleItem(systemName: nil, text: "v = u + at", x: 0.12, y: 0.28, rotation: -15, scale: 0.9),
    DoodleItem(systemName: nil, text: "μ_s = F_s/N", x: 0.8, y: 0.32, rotation: 8, scale: 1.0),
    DoodleItem(systemName: nil, text: "a = F_net / m", x: 0.4, y: 0.35, rotation: -8, scale: 1.1),
    DoodleItem(systemName: nil, text: "τ = r × F", x: 0.25, y: 0.48, rotation: 15, scale: 0.95),
    DoodleItem(systemName: nil, text: "p = mv", x: 0.72, y: 0.52, rotation: -10, scale: 1.0),
    DoodleItem(systemName: nil, text: "W = Fd", x: 0.52, y: 0.58, rotation: 25, scale: 1.05),
    DoodleItem(systemName: nil, text: "f = 1/T", x: 0.18, y: 0.62, rotation: -18, scale: 0.9),
    
    // Symbols
    DoodleItem(systemName: nil, text: "Δx", x: 0.88, y: 0.45, rotation: 15, scale: 1.0),
    DoodleItem(systemName: nil, text: "θ", x: 0.05, y: 0.68, rotation: 0, scale: 1.3),
    DoodleItem(systemName: nil, text: "λ", x: 0.82, y: 0.72, rotation: 20, scale: 1.2),
    DoodleItem(systemName: nil, text: "ΣF", x: 0.35, y: 0.78, rotation: -5, scale: 1.15),
    DoodleItem(systemName: nil, text: "Ω", x: 0.6, y: 0.82, rotation: 10, scale: 1.25),
    DoodleItem(systemName: nil, text: "π", x: 0.1, y: 0.88, rotation: -12, scale: 1.1)
]
