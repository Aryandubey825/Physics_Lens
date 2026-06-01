import SwiftUI

struct TodayTip {
    let title: String
    let description: String
    let icon: String
    
    static let tips: [TodayTip] = [
        TodayTip(
            title: "Maximum Projectile Range",
            description: "For maximum range in projectile motion on flat ground, the launch angle should be 45°.",
            icon: "sparkles"
        ),
        TodayTip(
            title: "Pendulum & Mass",
            description: "The period of a simple pendulum depends only on its length and gravity, not the mass of the bob!",
            icon: "timer"
        ),
        TodayTip(
            title: "Free Fall Speed",
            description: "In a vacuum, all objects fall with the exact same acceleration (g ≈ 9.8 m/s²), regardless of their mass.",
            icon: "arrow.down.circle"
        ),
        TodayTip(
            title: "Action & Reaction",
            description: "According to Newton's Third Law, forces always occur in equal and opposite pairs.",
            icon: "arrow.left.and.right"
        ),
        TodayTip(
            title: "Friction Direction",
            description: "Friction always opposes relative motion or the tendency of motion between contact surfaces.",
            icon: "hand.raised"
        ),
        TodayTip(
            title: "Conservation of Energy",
            description: "Energy can neither be created nor destroyed; it can only transform from one form to another.",
            icon: "bolt.circle"
        ),
        TodayTip(
            title: "Escape Velocity",
            description: "To escape Earth's gravity, an object needs a minimum launch speed of about 11.2 km/s.",
            icon: "paperplane"
        ),
        TodayTip(
            title: "Speed of Light",
            description: "The speed of light in a vacuum is a universal constant: approximately 300,000 km/s.",
            icon: "sun.max"
        ),
        TodayTip(
            title: "Inertia",
            description: "An object at rest stays at rest, and an object in motion stays in motion, unless acted upon by a net external force.",
            icon: "gauge.with.needle"
        ),
        TodayTip(
            title: "Centripetal Force",
            description: "Centripetal force is not a new force, but rather a label for any net force pointing towards the center of a circular path.",
            icon: "circle.dashed"
        )
    ]
    
    static func getTipForToday() -> TodayTip {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % tips.count
        return tips[index]
    }
}
