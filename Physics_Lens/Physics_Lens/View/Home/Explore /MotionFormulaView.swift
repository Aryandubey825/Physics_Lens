import SwiftUI

struct MotionFormulaView: View {
    
    @State private var selectedType = 0
    let types = ["Linear Motion", "Vertical Motion"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                
                Text("Motion Formula Library")
                    .font(.largeTitle)
                    .bold()
                
                Picker("Type", selection: $selectedType) {
                    ForEach(0..<types.count, id: \.self) { index in
                        Text(types[index])
                    }
                }
                .pickerStyle(.segmented)
                
                
                if selectedType == 0 {
                    FormulaCard1(
                        title: "Velocity Equation",
                        formula: "v = u + at",
                        explanation: "Final velocity depends on initial velocity and acceleration."
                    )
                    
                    FormulaCard1(
                        title: "Displacement Equation",
                        formula: "s = ut + ½at²",
                        explanation: "Used when time and acceleration are known."
                    )
                    
                    FormulaCard1(
                        title: "Velocity Square Equation",
                        formula: "v² = u² + 2as",
                        explanation: "Useful when time is not given."
                    )
                } else {
                    FormulaCard1(
                        title: "Free Fall Velocity",
                        formula: "v = gt",
                        explanation: "Object accelerating downward due to gravity."
                    )
                    
                    FormulaCard1(
                        title: "Height Equation",
                        formula: "h = ½gt²",
                        explanation: "Distance fallen under gravity."
                    )
                }
                
            }
            .padding()
        }
        
    }
}

