import SwiftUI

@available(iOS 26.0, *)
struct LaunchView: View {
    
    @State private var isActive = false
    @State private var animate = false
    
    var body: some View {
        
        if isActive {
            OnboardingView()
        } else {
            
            ZStack {
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.9),
                        Color.indigo
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    
                    Image("AppIconImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110)
                        .cornerRadius(24)
                        .scaleEffect(animate ? 1.0 : 0.8)
                        .opacity(animate ? 1 : 0)
                    
                    Text("PhysicLens")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .opacity(animate ? 1 : 0)
                    
                    Text("Learn Physics by Playing")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.85))
                        .opacity(animate ? 1 : 0)
                }
            }
            .onAppear {
                
                withAnimation(.easeInOut(duration: 1.2)) {
                    animate = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        LaunchView()
    } else {
        // Fallback on earlier versions
    }
}
