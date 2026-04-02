import SwiftUI

struct ExploreView: View {
    
    enum ExploreCategory: String, CaseIterable {
        case featured = "Featured concepts"
        case formulas = "Formulas sheet"
    }
    
    @State private var selectedCategory: ExploreCategory = .featured
    
    let columns = [
        GridItem(.adaptive(minimum: 280), spacing: 24)
    ]
    
    var body: some View {
        NavigationStack {
            
            VStack(spacing: 0) {
                
                Picker("", selection: $selectedCategory) {
                    ForEach(ExploreCategory.allCases, id: \.self) { category in
                        Text(category.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 8)
                
                
                ScrollView {
                    
                    LazyVGrid(columns: columns, spacing: 24) {
                        
                        if selectedCategory == .featured {
                            
                            NavigationLink {
                                EarthMoonCompareView()
                            } label: {
                                ExploreCard(
                                    title: "Free Fall: Moon vs Earth",
                                    subtitle: "Why falling feels different?",
                                    color: Color(red: 0.23, green: 0.51, blue: 0.87)
                                )
                            }
                            .buttonStyle(.plain)
                            
                            
                            NavigationLink {
                                TerminalVelocityView()
                            } label: {
                                ExploreCard(
                                    title: "Terminal Velocity",
                                    subtitle: "Why skydivers stop accelerating?",
                                    color: Color(red: 0.91, green: 0.56, blue: 0.25)
                                )
                            }
                            .buttonStyle(.plain)
                            
                            
                            NavigationLink {
                                EqualFallView()
                            } label: {
                                ExploreCard(
                                    title: "Equal Fall Speed",
                                    subtitle: "Why heavy & light objects fall same?",
                                    color: Color(red: 0.67, green: 0.37, blue: 0.84)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                        
                        if selectedCategory == .formulas {
                            
                            NavigationLink {
                                MotionFormulaView()
                            } label: {
                                ExploreCard(
                                    title: "Motion Formulas",
                                    subtitle: "All kinematics equations",
                                    color: Color(red: 0.36, green: 0.45, blue: 0.82)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 24)  
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(.systemGroupedBackground))
        }
    }
}
