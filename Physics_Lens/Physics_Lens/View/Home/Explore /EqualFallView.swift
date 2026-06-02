import SwiftUI

struct EqualFallView: View {
    
    @State private var drop = false
    @State private var showVacuum = true
    @State private var isAnimating = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                
                
                Text("Equal Fall Speed")
                    .font(.largeTitle)
                    .bold()
                
                Text("In vacuum, all objects fall with the same acceleration.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                
                Toggle("Vacuum Mode", isOn: $showVacuum)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.ultraThinMaterial)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.blue.opacity(0.1))
                        )
                        .frame(height: 300)
                    
                    HStack(spacing: 80) {
                        
                        VStack {
                            Text("Heavy")
                                .font(.caption)
                            
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 40, height: 40)
                                .offset(y: drop ? 100 : -100)
                                .animation(
                                    isAnimating ? .easeIn(duration: showVacuum ? 1.5 : 1) : nil,
                                    value: drop
                                )
                        }
                        
                        VStack {
                            Text("Light")
                                .font(.caption)
                            
                            Circle()
                                .fill(Color.green)
                                .frame(width: 25, height: 25)
                                .offset(y: drop ? (showVacuum ? 100 : 60) : -100)
                                .animation(
                                    isAnimating ? .easeIn(duration: showVacuum ? 1.5 : 2.5) : nil,
                                    value: drop
                                )
                        }
                    }
                }
                
                
                Button(action: {
                    isAnimating = false
                    drop = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isAnimating = true
                        drop = true
                    }
                    
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    Text("Start Drop")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                }
                
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("Why Mass Doesn't Matter")
                        .font(.headline)
                    
                    Text("F = mg")
                        .font(.system(.title3, design: .monospaced))
                    
                    Text("Acceleration = F / m")
                        .font(.system(.title3, design: .monospaced))
                    
                    Text("""
Substitute F:

a = mg / m

Mass cancels out → a = g
""")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    Text("Concept Insight")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text("In vacuum, both objects hit the ground together.")
                        
                        Text("Gravity pulls more strongly on heavier objects, but they also resist acceleration more.")
                        
                        Text("These two effects cancel out.")
                        
                        Text("In air, lighter objects fall slower due to air resistance.")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                
            }
            .padding()
        }
    }
}
