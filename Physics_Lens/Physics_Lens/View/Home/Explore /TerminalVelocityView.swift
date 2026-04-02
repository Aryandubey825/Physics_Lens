import SwiftUI

struct TerminalVelocityView: View {
    
    @State private var falling = false
    @State private var showArrows = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                
                Text("Terminal Velocity")
                    .font(.largeTitle)
                    .bold()
                
                Text("When air resistance balances gravity, acceleration becomes zero.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.ultraThinMaterial)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.blue.opacity(0.1))
                        )
                        .frame(height: 300)
                    
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 40, height: 40)
                        .offset(y: falling ? 80 : -80)
                        .animation(.easeInOut(duration: 2), value: falling)
                    
                    VStack {
                        Spacer()
                        
                        Image(systemName: "arrow.down")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                            .opacity(showArrows ? 1 : 0)
                        
                        Text("Gravity (mg)")
                            .font(.caption)
                            .foregroundColor(.red)
                            .opacity(showArrows ? 1 : 0)
                    }
                    .animation(.easeIn(duration: 1), value: showArrows)
                    
                    VStack {
                        Image(systemName: "arrow.up")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                            .opacity(showArrows ? 1 : 0)
                        
                        Text("Air Resistance")
                            .font(.caption)
                            .foregroundColor(.green)
                            .opacity(showArrows ? 1 : 0)
                        
                        Spacer()
                    }
                    .animation(.easeIn(duration: 1), value: showArrows)
                    
                }
                
                Button(action: {
                    falling = false
                    showArrows = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        falling = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        showArrows = true
                    }
                    
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    Text("Start Simulation")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                }
                
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("Terminal Velocity Formula")
                        .font(.headline)
                    
                    Text("Vt = √(2mg / ρACd)")
                        .font(.system(.title3, design: .monospaced))
                    
                    Text("""
m = mass  
ρ = air density  
A = cross sectional area  
Cd = drag coefficient
""")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    Text("What Happens Physically?")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text("Initially, gravity pulls the object downward.")
                        
                        Text("As speed increases, air resistance also increases.")
                        
                        Text("At terminal velocity:")
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("• Air Resistance = Gravity")
                            Text("• Net Force = 0")
                            Text("• Acceleration = 0")
                            Text("• Speed becomes constant")
                        }
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
