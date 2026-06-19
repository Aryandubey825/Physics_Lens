import SwiftUI

@available(iOS 26.0, *)
struct AIInsightSheetView: View {
    @ObservedObject var aiManager: AIFeedbackManager
    @Binding var isPresented: Bool
    
    @State private var isAnimating = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                
                if aiManager.isLoading {
                    VStack(spacing: 24) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Apple Intelligence is analyzing your motion data...")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .opacity(isAnimating ? 1 : 0.5)
                            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnimating)
                    }
                    .onAppear { isAnimating = true }
                    .onDisappear { isAnimating = false }
                } else if let insight = aiManager.insightData {
                    ScrollView {
                        VStack(spacing: 24) {
                            
                            // Glowing header
                            VStack(spacing: 12) {
                                Image(systemName: "applelogo")
                                    .font(.system(size: 40))
                                    .foregroundStyle(LinearGradient(colors: [.blue, .purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .scaleEffect(isAnimating ? 1.05 : 0.95)
                                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                                
                                Text("Insight Generated")
                                    .font(.title2.bold())
                                    .foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                            }
                            .padding(.top, 20)
                            
                            // Main Insight Card
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "lightbulb.fill")
                                        .foregroundColor(.orange)
                                    Text("Feedback")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                }
                                
                                Text(insight.mainInsight)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .lineSpacing(4)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                            .padding(.horizontal)
                            .opacity(isAnimating ? 1 : 0)
                            .offset(y: isAnimating ? 0 : 20)
                            .animation(.easeOut(duration: 0.5).delay(0.1), value: isAnimating)
                            
                            // Result Comparison Card
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: insight.isCorrect ? "checkmark.seal.fill" : "xmark.seal.fill")
                                        .foregroundColor(insight.isCorrect ? .green : .red)
                                        .scaleEffect(isAnimating ? 1 : 0.5)
                                        .animation(.spring(response: 0.4, dampingFraction: 0.5).delay(0.3), value: isAnimating)
                                    Text("Result Analysis")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                }
                                .padding(.bottom, 4)
                                
                                HStack(spacing: 16) {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Your Answer")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text(insight.userAnswer.isEmpty ? "N/A" : insight.userAnswer)
                                            .font(.subheadline.bold())
                                            .foregroundColor(.primary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Divider()
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Correct Answer")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text(insight.correctAnswer)
                                            .font(.subheadline.bold())
                                            .foregroundColor(.green)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                            .padding(.horizontal)
                            .opacity(isAnimating ? 1 : 0)
                            .offset(y: isAnimating ? 0 : 20)
                            .animation(.easeOut(duration: 0.5).delay(0.2), value: isAnimating)
                            
                            // Data Points Grid
                            if !insight.dataPoints.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "chart.bar.xaxis")
                                            .foregroundColor(.blue)
                                        Text("Captured Metrics")
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                    }
                                    .padding(.horizontal)
                                    
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                        ForEach(insight.dataPoints, id: \.0) { point in
                                            VStack(spacing: 6) {
                                                Text(point.0)
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                                Text(point.1)
                                                    .font(.subheadline.bold())
                                                    .foregroundColor(.primary)
                                            }
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(Color(UIColor.secondarySystemGroupedBackground))
                                            .cornerRadius(12)
                                            .shadow(color: .black.opacity(0.03), radius: 3, x: 0, y: 1)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .opacity(isAnimating ? 1 : 0)
                                .offset(y: isAnimating ? 0 : 20)
                                .animation(.easeOut(duration: 0.5).delay(0.3), value: isAnimating)
                            }
                            
                            // Fun Fact Card
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "sparkles")
                                        .foregroundColor(.purple)
                                        .rotationEffect(.degrees(isAnimating ? 15 : -15))
                                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnimating)
                                    Text("Fun Fact")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                }
                                
                                Text(insight.funFact)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineSpacing(4)
                                    .italic()
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                LinearGradient(colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.purple.opacity(0.2), lineWidth: 1)
                            )
                            .padding(.horizontal)
                            .opacity(isAnimating ? 1 : 0)
                            .offset(y: isAnimating ? 0 : 20)
                            .animation(.easeOut(duration: 0.5).delay(0.4), value: isAnimating)
                            
                            Spacer(minLength: 40)
                        }
                    }
                    .onAppear {
                        // Small delay before starting the entry animations
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isAnimating = true
                        }
                    }
                    .onDisappear {
                        isAnimating = false
                    }
                } else {
                    Text("No insight available.")
                        .foregroundColor(.secondary)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                    .font(.headline)
                }
            }
        }
    }
}
