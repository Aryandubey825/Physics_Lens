import Foundation
import Combine

struct AIInsightResponse {
    var mainInsight: String
    var funFact: String
    var dataPoints: [(String, String)]
    var userAnswer: String
    var correctAnswer: String
    var isCorrect: Bool
}

@MainActor
class AIFeedbackManager: ObservableObject {
    @Published var insightData: AIInsightResponse?
    @Published var feedbackText: String = "" // Keep for backwards compatibility if needed
    @Published var isLoading: Bool = false
    
    // Simulating an Apple Foundation Model (Apple Intelligence) request on-device
    func generateAppleFoundationInsight(topic: String, userAns: String, correctAns: String, details: String) async {
        isLoading = true
        insightData = nil
        feedbackText = ""
        
        // Simulating the processing time for on-device inference
        try? await Task.sleep(nanoseconds: 1_200_000_000)
        
        let lowerUserAns = userAns.lowercased()
        let lowerCorrectAns = correctAns.lowercased()
        let isCorrect = lowerUserAns == lowerCorrectAns || userAns == correctAns
        
        var insight = ""
        var funFact = ""
        
        // Parse details: "Speed=30.0m/s, Angle=45.0°, Target=85.0m, Range=91.84m"
        var parsedDataPoints: [(String, String)] = []
        let components = details.components(separatedBy: ",")
        for comp in components {
            let parts = comp.components(separatedBy: "=")
            if parts.count == 2 {
                parsedDataPoints.append((parts[0].trimmingCharacters(in: .whitespaces), parts[1].trimmingCharacters(in: .whitespaces)))
            } else if !comp.trimmingCharacters(in: .whitespaces).isEmpty {
                parsedDataPoints.append(("Detail", comp.trimmingCharacters(in: .whitespaces)))
            }
        }
        
        // Context-aware explanation logic based on Physics Topic
        switch topic.lowercased() {
        case "friction":
            insight = isCorrect ? "Great intuition! The static friction force opposes the applied force up to a maximum limit (μ_s * N). Once you exceed this limit, the object breaks free, and kinetic friction takes over." 
                                : "Not quite. Remember that an object only moves if the applied force exceeds the maximum static friction (μ_s * N)."
            funFact = "Did you know? Geckos use intermolecular forces (van der Waals forces), a type of nanoscale friction, to climb smooth vertical glass!"
            
        case "free fall":
            insight = isCorrect ? "Spot on! In a vacuum, all objects fall at the exact same rate (g = 9.8 m/s²) regardless of mass." 
                                : "A quick tip: Gravity provides a constant acceleration of 9.8 m/s² downwards. Mass doesn't affect the fall time unless there is air resistance."
            funFact = "Did you know? In 1971, Apollo 15 astronaut David Scott dropped a hammer and a feather on the Moon. Without air resistance, they hit the surface at the exact same time!"
            
        case "pendulum":
            insight = isCorrect ? "Excellent! The period of a simple pendulum depends entirely on its length and the local gravity (T = 2π√(L/g))." 
                                : "Here's the secret: A pendulum's period is proportional to the square root of its length. Mass and amplitude don't change the period."
            funFact = "Did you know? The Foucault pendulum was used in 1851 to provide the first simple, direct evidence that the Earth rotates on its axis."
            
        case "projectile motion":
            insight = isCorrect ? "Perfect calculation! Projectile motion splits into two independent parts: horizontal velocity remains constant, while vertical velocity changes due to gravity." 
                                : "To master projectiles, treat the X and Y axes separately. The maximum range usually happens at a 45° launch angle."
            funFact = "Did you know? To achieve maximum range on a flat surface in a vacuum, you should launch at 45°. But in real sports like shot put, the optimal angle is closer to 37° due to the release height!"
            
        case "newton's second law":
            insight = isCorrect ? "You got it! Newton's Second Law (F = ma) shows that acceleration is directly proportional to net force and inversely proportional to mass." 
                                : "Remember F = ma. If you want more acceleration, you need to apply more force or reduce the mass."
            funFact = "Did you know? Formula 1 cars generate so much aerodynamic downforce (which increases the normal force and friction without adding mass) that they could theoretically drive upside down in a tunnel at 200 km/h!"
            
        default:
            insight = "Understanding the interplay of forces and kinematics is key to predicting motion accurately."
            funFact = "Keep exploring physics to discover how the universe works!"
        }
        
        insightData = AIInsightResponse(
            mainInsight: insight, 
            funFact: funFact, 
            dataPoints: parsedDataPoints,
            userAnswer: userAns,
            correctAnswer: correctAns,
            isCorrect: isCorrect
        )
        feedbackText = insight // Fallback
        isLoading = false
    }
}
