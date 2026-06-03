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

                            
                            NavigationLink {
                                PendulumExploreView()
                            } label: {
                                ExploreCard(
                                    title: "Simple Pendulum",
                                    subtitle: "Time period & length dependency",
                                    color: Color(red: 0.38, green: 0.63, blue: 0.92)
                                )
                            }
                            .buttonStyle(.plain)
                            
                            NavigationLink {
                                KeplerLawExploreView()
                            } label: {
                                ExploreCard(
                                    title: "Kepler's Second Law",
                                    subtitle: "Sweep equal areas in equal times",
                                    color: Color(red: 0.44, green: 0.32, blue: 0.87)
                                )
                            }
                            .buttonStyle(.plain)
                            
                            NavigationLink {
                                HookesLawExploreView()
                            } label: {
                                ExploreCard(
                                    title: "Hooke's Law & Spring",
                                    subtitle: "Restoring force & spring constants",
                                    color: Color(red: 0.18, green: 0.70, blue: 0.82)
                                )
                            }
                            .buttonStyle(.plain)
                            
                            NavigationLink {
                                VectorAdditionExploreView()
                            } label: {
                                ExploreCard(
                                    title: "Vector Addition",
                                    subtitle: "Resultant of two vectors in 2D",
                                    color: Color(red: 0.86, green: 0.30, blue: 0.61)
                                )
                            }
                            .buttonStyle(.plain)
                            
                            NavigationLink {
                                MomentOfInertiaExploreView()
                            } label: {
                                ExploreCard(
                                    title: "Moment of Inertia Race",
                                    subtitle: "Which shape rolls down fastest?",
                                    color: Color(red: 0.55, green: 0.68, blue: 0.15)
                                )
                            }
                            .buttonStyle(.plain)
                            
                            NavigationLink {
                                BernoulliExploreView()
                            } label: {
                                ExploreCard(
                                    title: "Bernoulli's Principle",
                                    subtitle: "Velocity & pressure in fluid flow",
                                    color: Color(red: 0.20, green: 0.45, blue: 0.65)
                                )
                            }
                            .buttonStyle(.plain)
                            
                            NavigationLink {
                                GasKineticTheoryExploreView()
                            } label: {
                                ExploreCard(
                                    title: "Gas Laws & Kinetic Theory",
                                    subtitle: "Molecular collisions and pressure",
                                    color: Color(red: 0.90, green: 0.45, blue: 0.20)
                                )
                            }
                            .buttonStyle(.plain)
                            
                            NavigationLink {
                                DopplerEffectExploreView()
                            } label: {
                                ExploreCard(
                                    title: "Doppler Effect",
                                    subtitle: "Wavelength shifts for moving source",
                                    color: Color(red: 0.50, green: 0.50, blue: 0.55)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                        
                        if selectedCategory == .formulas {
                            ForEach(FormulaData.units) { unit in
                                NavigationLink {
                                    FormulaDetailView(
                                        unitTitle: unit.title,
                                        formulas: unit.formulas,
                                        themeColor: unit.color,
                                        iconName: unit.icon
                                    )
                                } label: {
                                    ExploreCard(
                                        title: unit.title,
                                        subtitle: unit.subtitle,
                                        color: unit.color,
                                        icon: unit.icon
                                    )
                                }
                                .buttonStyle(.plain)
                            }
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

struct ExploreResultCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Text(value)
                .font(.headline.bold())
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct ExploreControlSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let suffix: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Text("\(String(format: "%.1f", value))\(suffix)")
                    .font(.subheadline.bold())
                    .foregroundColor(.blue)
            }
            Slider(value: $value, in: range)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

