import SwiftUI

@available(iOS 26.0, *)
struct OnboardingView: View {
    
    @State private var currentPage = 0
    @State private var goToHome = false
    
        
        init() {
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.systemBlue
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.systemGray4
        }

       
    var body: some View {
        
        if goToHome {
            MainTabView()
        } else {
            
            ZStack {
                
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.08),
                        Color.indigo.opacity(0.12)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    
                    if currentPage != 2 {
                        HStack {
                            Spacer()
                            Button("Skip") {
                                goToHome = true
                            }
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.indigo)
                            .padding(.trailing, 25)
                            .padding(.top, 10)
                        }
                    }
                    
                    TabView(selection: $currentPage) {
                        
                        TopicOnboardingPage()
                            .tag(0)
                        
                        LearnOnboardingPage()
                            .tag(1)
                        
                        GameOnboardingPage()
                            .tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .animation(.easeInOut, value: currentPage)
                    
                    Spacer()
                    
                    if currentPage == 2 {
                        Button(action: {
                            goToHome = true
                        }) {
                            Text("Start Learning ")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.indigo)
                                .cornerRadius(16)
                                .padding(.horizontal, 40)
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
        }
    }
}

@available(iOS 26.0, *)
struct TopicOnboardingPage: View {
    
    let images = [
        "projectile",
        "pendulum",
        "freefall",
        "friction",
        "secondlaw"
    ]
    
    @State private var currentIndex = 0
    let timer = Timer.publish(every: 2.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 30) {
            
            Spacer()
            
            TabView(selection: $currentIndex) {
                ForEach(0..<images.count, id: \.self) { index in
                    Image(images[index])
                        .resizable()
                        .scaledToFit()
                        .frame(height: 320)
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 8)
                        .padding(.horizontal, 30)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 320)
            .onReceive(timer) { _ in
                withAnimation {
                    currentIndex = (currentIndex + 1) % images.count
                }
            }
            
            Text("Choose Your Topic")
                .font(.system(size: 28, weight: .bold))
            
            Text("Select any physics topic and start learning at your own pace.")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

@available(iOS 26.0, *)
struct LearnOnboardingPage: View {
    
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: 30) {
            
            Spacer()
            
            Image("animation")
                .resizable()
                .scaledToFit()
                .frame(height: 380)
                .cornerRadius(30)
                .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 10)
                .scaleEffect(animate ? 1 : 0.96)
                .opacity(animate ? 1 : 0)
            
            VStack(spacing: 8) {
                
                Text("Learn Creatively")
                    .font(.system(size: 28, weight: .bold))
                
                
                
                Text("Adjust values, explore animations and understand physics visually — not just formulas.")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .opacity(animate ? 1 : 0)
            
            Spacer()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                animate = true
            }
        }
        .onDisappear {
            animate = false
        }
    }
}

@available(iOS 26.0, *)
struct GameOnboardingPage: View {
    
    let gameImages = [
        "projectileGame",
        "pendulumGame",
        "freefallGame",
        "frictionGame",
        "second'sLawGame"
    ]
    
    @State private var currentIndex = 0
    let timer = Timer.publish(every: 2.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 30) {
            
            Spacer()
            
            TabView(selection: $currentIndex) {
                ForEach(0..<gameImages.count, id: \.self) { index in
                    Image(gameImages[index])
                        .resizable()
                        .scaledToFit()
                        .frame(height: 320)
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 8)
                        .padding(.horizontal, 30)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 320)
            .onReceive(timer) { _ in
                withAnimation {
                    currentIndex = (currentIndex + 1) % gameImages.count
                }
            }
            
            Text("Play & Apply")
                .font(.system(size: 28, weight: .bold))
            
            Text("Challenge yourself with interactive physics games after mastering the concept.")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}
