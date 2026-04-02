import SwiftUI

import SwiftUI

struct NewtonSecondLawSimulator: View {
    
  
    @State private var force: Double = 20
    @State private var mass: Double = 5
    
  
    @State private var position: CGFloat = 40
    @State private var velocity: Double = 0
    @State private var isRunning = false
    
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    var acceleration: Double {
        force / mass
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Newton’s Second Law")
                .font(.title.bold())
            
           
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.blue.opacity(0.08))
                
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 60, height: 60)
                    .offset(x: position)
            }
            .frame(height: 200)
            
            
            Text("Acceleration: \(String(format: "%.2f", acceleration)) m/s²")
                .font(.headline)
            
           
            VStack {
                Text("Force: \(Int(force)) N")
                Slider(value: $force, in: 5...100)
                
                Text("Mass: \(Int(mass)) kg")
                Slider(value: $mass, in: 1...20)
            }
            
           
            HStack {
                Button("Apply Force") {
                    reset()
                    isRunning = true
                }
                .buttonStyle(.borderedProminent)
                
                Button("Reset") {
                    reset()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .onReceive(timer) { _ in
            guard isRunning else { return }
            
            velocity += acceleration * 0.02
            position += CGFloat(velocity)
            
            if position > 150 {
                isRunning = false
            }
        }
    }
    
    func reset() {
        position = 40
        velocity = 0
        isRunning = false
    }
}

#Preview {
    NewtonSecondLawSimulator()
}
