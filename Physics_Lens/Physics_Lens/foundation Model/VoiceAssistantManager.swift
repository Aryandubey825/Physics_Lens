import Foundation
import AVFoundation

@MainActor
class VoiceAssistantManager: ObservableObject {
    
    private let synthesizer = AVSpeechSynthesizer()
    
    
    private func speak(_ text: String) {
        
        // Stop previous speech if running
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-IN")
        utterance.rate = 0.45
        utterance.pitchMultiplier = 1.0
        
        synthesizer.speak(utterance)
    }
    
    
    func speakProjectileQuestion(
        angle: Double,
        range: Double,
        gravity: Double,
        lockAngle: Bool,
        lockSpeed: Bool
    ) {
        
        var instruction = ""
        
        if lockAngle {
            instruction = "The angle is locked. You need to calculate the required velocity."
        } else if lockSpeed {
            instruction = "The velocity is locked. You need to calculate the required launch angle."
        } else {
            instruction = "You need to calculate the correct velocity to hit the target."
        }
        
        let speechText = """
        Physics Challenge.
        
        Projectile Motion.
        
        The launch angle is \(Int(angle)) degrees.
        The target range is \(String(format: "%.1f", range)) meters.
        Gravity is \(gravity) meters per second squared.
        
        \(instruction)
        
        Use the range formula.
        R equals u square multiplied by sine of two theta divided by g.
        """
        
        speak(speechText)
    }
    
    
    func speakPendulumQuestion(
        lengthMeters: Double,
        gravity: Double
    ) {
        
        let speechText = """
        Pendulum Challenge.
        
        The length of the pendulum is \(String(format: "%.2f", lengthMeters)) meters.
        Gravity is \(gravity) meters per second squared.
        
        Calculate the time period of oscillation.
        
        Use the formula:
        T equals 2 pi square root of L divided by g.
        
        Remember, the time period does not depend on mass.
        """
        
        speak(speechText)
    }
    
    
    func speakFreeFallQuestion(
        height: Double?,
        time: Double?,
        velocity: Double?,
        findVariable: String
    ) {
        
        var givenText = ""
        
        if let height = height {
            givenText += "The height is \(Int(height)) meters. "
        }
        
        if let time = time {
            givenText += "The time is \(String(format: "%.2f", time)) seconds. "
        }
        
        if let velocity = velocity {
            givenText += "The velocity is \(String(format: "%.2f", velocity)) meters per second. "
        }
        
        var instruction = ""
        
        switch findVariable {
        case "t":
            instruction = "You need to calculate the time of fall."
        case "v":
            instruction = "You need to calculate the final velocity."
        case "s":
            instruction = "You need to calculate the height."
        default:
            instruction = "Solve the free fall problem."
        }
        
        let speechText = """
        Physics Challenge.
        
        Free Fall Motion.
        
        \(givenText)
        
        \(instruction)
        
        Use the appropriate free fall equations.
        S equals half g t square.
        V equals g t.
        V square equals two g s.
        """
        
        speak(speechText)
    }
   
    func speakRaceQuestion(
        questionType: String,
        mass: Double,
        time: Double,
        distance: Double,
        acceleration: Double
    ) {
        
        let speechText = """
        Physics Race Challenge.
        
        Acceleration is \(Int(acceleration)) meters per second squared.
        Time is \(Int(time)) seconds.
        Distance is \(Int(distance)) meters.
        Mass is \(Int(mass)) kilograms.
        
        You need to calculate \(questionType).
        
        Use the correct kinematics formula.
        """
        
        speak(speechText)
    }
    
        
        func speakFrictionQuestion(
            mass: Double,
            force: Double,
            staticMu: Double,
            kineticMu: Double,
            questionType: String
        ) {
            
            let speechText = """
            Friction Challenge.
            
            The mass of the object is \(Int(mass)) kilograms.
            The applied force is \(Int(force)) newtons.
            The coefficient of static friction is \(staticMu).
            The coefficient of kinetic friction is \(kineticMu).
            
            The question is: \(questionType).
            
            First compare applied force with maximum static friction.
            If it moves, use kinetic friction to calculate acceleration.
            """
            
            speak(speechText)
        }
    
}
