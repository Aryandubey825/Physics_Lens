import Foundation
import FoundationModels
import SwiftUI

@available(iOS 26.0, *)
@MainActor
class AIFeedbackManager: ObservableObject {
    
    @Published var feedbackText: String = ""
    @Published var isLoading: Bool = false
    
    private let model = SystemLanguageModel.default
    
    
    func analyze(result: GameResult) async {
        
        isLoading = true
        
        let prompt = """
        You are a friendly and encouraging physics tutor.
        
        Topic: \(result.topic)
        
        Student Attempt:
        \(result.userInput)
        
        Correct Concept:
        \(result.correctConcept)
        
        Outcome:
        \(result.userOutcome)
        
        Score: \(result.score)
        
        Give feedback strictly in this format without using any symbols like *, #, -, or markdown.
        
        Write plain text only using these section titles exactly:
        
        Result Summary:
        Concept Reminder:
        Improvement Advice:
        Motivation:
        
        Keep it clean, simple, and structured.
        """
        
        do {
            let session = LanguageModelSession(model: model)
            let response = try await session.respond(to: prompt)
            feedbackText = response.content
                .trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            feedbackText = "AI feedback unavailable on this device."
        }
        
        isLoading = false
    }
}


struct AIFeedbackView: View {
    
    let feedback: String
    
    var resultSummary: String {
        extractSection(after: "Result Summary:")
    }
    
    var conceptReminder: String {
        extractSection(after: "Concept Reminder:")
    }
    
    var improvementAdvice: String {
        extractSection(after: "Improvement Advice:")
    }
    
    var motivation: String {
        extractSection(after: "Motivation:")
    }
    
    func extractSection(after title: String) -> String {
        guard let range = feedback.range(of: title) else { return "" }
        
        let substring = feedback[range.upperBound...]
        
        let nextTitles = [
            "Result Summary:",
            "Concept Reminder:",
            "Improvement Advice:",
            "Motivation:"
        ]
        
        for next in nextTitles {
            if next != title,
               let nextRange = substring.range(of: next) {
                return String(substring[..<nextRange.lowerBound])
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        return String(substring)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                FeedbackCard(
                    title: "Result Summary",
                    content: resultSummary
                )
                
                FeedbackCard(
                    title: "Concept Reminder",
                    content: conceptReminder
                )
                
                FeedbackCard(
                    title: "Improvement Advice",
                    content: improvementAdvice
                )
                
                FeedbackCard(
                    title: "Motivation",
                    content: motivation
                )
            }
            .padding()
        }
    }
}
struct FeedbackCard: View {
    
    let title: String
    let content: String
    
    var pastelBackground: Color {
        switch title {
        case "Result Summary":
            return Color.blue.opacity(0.12)
        case "Concept Reminder":
            return Color.purple.opacity(0.12)
        case "Improvement Advice":
            return Color.orange.opacity(0.12)
        case "Motivation":
            return Color.green.opacity(0.12)
        default:
            return Color.gray.opacity(0.08)
        }
    }
    
    var titleColor: Color {
        switch title {
        case "Result Summary":
            return .blue
        case "Concept Reminder":
            return .purple
        case "Improvement Advice":
            return .orange
        case "Motivation":
            return .green
        default:
            return .primary
        }
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            Text(title)
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(titleColor)
            
            Text(content)
                .font(.system(size: 15))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(pastelBackground)
        )
    }
}
