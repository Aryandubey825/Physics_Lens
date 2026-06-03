import SwiftUI
import Combine

struct MomentOfInertiaExploreView: View {
    @State private var rampAngleDegrees: Double = 25.0
    @State private var isRunning = false
    @State private var raceTime: Double = 0.0
    
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    // Ramp length parameter (visual pixels)
    let rampLength: CGFloat = 300
    
    // Acceleration factor (visual scaling)
    let scaleFactor: Double = 120.0 // pixels/m
    
    // Accel calculation: a = g*sin(theta) / (1 + I/MR^2)
    var gravity: Double { 9.8 }
    var thetaRad: Double { rampAngleDegrees * .pi / 180.0 }
    
    var accSphere: Double { (gravity * sin(thetaRad)) / (1.0 + 0.4) }
    var accCylinder: Double { (gravity * sin(thetaRad)) / (1.0 + 0.5) }
    var accHoop: Double { (gravity * sin(thetaRad)) / (1.0 + 1.0) }
    
    @State private var posSphere: Double = 0.0
    @State private var posCylinder: Double = 0.0
    @State private var posHoop: Double = 0.0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Moment of Inertia Race")
                    .font(.largeTitle.bold())
                    .padding(.top)
                
                Text("Objects with different mass distributions (moments of inertia) roll down an incline at different rates, even if they have the same mass and radius.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Race Track Canvas
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .background(Color.blue.opacity(0.08))
                        .frame(height: 350)
                    
                    GeometryReader { geo in
                        let startX: CGFloat = 90
                        let radius: CGFloat = 16
                        
                        let laneYHoop: CGFloat = 40
                        let laneYCylinder: CGFloat = 100
                        let laneYSphere: CGFloat = 160
                        
                        let deltaX = rampLength * cos(CGFloat(thetaRad))
                        let deltaY = rampLength * sin(CGFloat(thetaRad))
                        
                        // Draw 3 Parallel Lanes
                        ForEach(0..<3) { i in
                            let startY: CGFloat = {
                                switch i {
                                case 0: return laneYHoop
                                case 1: return laneYCylinder
                                default: return laneYSphere
                                }
                            }()
                            let endX = startX + deltaX
                            let endY = startY + deltaY
                            
                            // Lane Label on the left
                            Text(i == 0 ? "Hoop" : (i == 1 ? "Cylinder" : "Sphere"))
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                                .frame(width: 70, alignment: .trailing)
                                .position(x: 40, y: startY - 8)
                            
                            // Lane background fill under ramp
                            Path { path in
                                path.move(to: CGPoint(x: startX, y: startY))
                                path.addLine(to: CGPoint(x: endX, y: endY))
                                path.addLine(to: CGPoint(x: endX, y: endY + 12))
                                path.addLine(to: CGPoint(x: startX, y: startY + 12))
                                path.closeSubpath()
                            }
                            .fill(Color.secondary.opacity(0.1))
                            
                            // Ramp line for the lane
                            Path { path in
                                path.move(to: CGPoint(x: startX, y: startY))
                                path.addLine(to: CGPoint(x: endX, y: endY))
                            }
                            .stroke(Color.primary.opacity(0.4), lineWidth: 3)
                        }
                        
                        // Render Hoop (Top lane)
                        let hoopOffset = CGFloat(posHoop * scaleFactor)
                        let hoopX = startX + hoopOffset * cos(CGFloat(thetaRad))
                        let hoopY = laneYHoop + hoopOffset * sin(CGFloat(thetaRad)) - radius
                        let hoopRot = CGFloat(posHoop * scaleFactor) / radius
                        
                        RollingShapeView(name: "Hoop", color: .orange, type: .hoop, rotation: hoopRot)
                            .frame(width: radius * 2, height: radius * 2)
                            .position(x: hoopX, y: hoopY)
                        
                        // Render Solid Cylinder (Middle lane)
                        let cylinderOffset = CGFloat(posCylinder * scaleFactor)
                        let cylinderX = startX + cylinderOffset * cos(CGFloat(thetaRad))
                        let cylinderY = laneYCylinder + cylinderOffset * sin(CGFloat(thetaRad)) - radius
                        let cylinderRot = CGFloat(posCylinder * scaleFactor) / radius
                        
                        RollingShapeView(name: "Cylinder", color: .blue, type: .solidCylinder, rotation: cylinderRot)
                            .frame(width: radius * 2, height: radius * 2)
                            .position(x: cylinderX, y: cylinderY)
                        
                        // Render Solid Sphere (Bottom lane)
                        let sphereOffset = CGFloat(posSphere * scaleFactor)
                        let sphereX = startX + sphereOffset * cos(CGFloat(thetaRad))
                        let sphereY = laneYSphere + sphereOffset * sin(CGFloat(thetaRad)) - radius
                        let sphereRot = CGFloat(posSphere * scaleFactor) / radius
                        
                        RollingShapeView(name: "Sphere", color: .red, type: .solidSphere, rotation: sphereRot)
                            .frame(width: radius * 2, height: radius * 2)
                            .position(x: sphereX, y: sphereY)
                    }
                }
                .frame(height: 350)
                .padding(.horizontal)
                
                HStack(spacing: 12) {
                    ExploreResultCard(title: "Sphere Accel", value: String(format: "%.2f m/s²", accSphere))
                    ExploreResultCard(title: "Cylinder Accel", value: String(format: "%.2f m/s²", accCylinder))
                    ExploreResultCard(title: "Hoop Accel", value: String(format: "%.2f m/s²", accHoop))
                }
                .padding(.horizontal)
                
                VStack(spacing: 16) {
                    ExploreControlSlider(title: "Ramp Angle", value: $rampAngleDegrees, range: 10...35, suffix: "°")
                }
                .padding(.horizontal)
                
                HStack(spacing: 16) {
                    Button(action: {
                        reset()
                        isRunning = true
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }) {
                        Text("Start Race")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .font(.headline)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    
                    Button(action: {
                        reset()
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }) {
                        Text("Reset")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.ultraThinMaterial)
                            .foregroundColor(.primary)
                            .font(.headline)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Moments of Inertia (I)")
                        .font(.headline)
                    
                    Text("• Solid Sphere: I = 2/5 MR² (β = 0.40)")
                    Text("• Solid Cylinder: I = 1/2 MR² (β = 0.50)")
                    Text("• Hollow Hoop: I = MR² (β = 1.00)")
                }
                .font(.system(.subheadline, design: .monospaced))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Concept Insight")
                        .font(.headline)
                    
                    Text("1. When rolling without slipping, gravitational potential energy is converted into both linear kinetic energy and rotational kinetic energy.")
                    Text("2. The hoop has the largest moment of inertia, meaning it directs more energy into rotation and less into forward speed. Thus, it rolls slowest.")
                    Text("3. The solid sphere has the smallest moment of inertia, allowing it to translate energy into linear speed fastest and win the race.")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
        .onReceive(timer) { _ in
            guard isRunning else { return }
            
            raceTime += 0.02
            
            // s = 1/2 a t^2
            let sphereS = 0.5 * accSphere * raceTime * raceTime
            let cylinderS = 0.5 * accCylinder * raceTime * raceTime
            let hoopS = 0.5 * accHoop * raceTime * raceTime
            
            // Limit race distance visually to rampLength (in meters equivalent: rampLength / scaleFactor)
            let maxMeters = Double(rampLength) / scaleFactor
            
            posSphere = min(sphereS, maxMeters)
            posCylinder = min(cylinderS, maxMeters)
            posHoop = min(hoopS, maxMeters)
            
            if posSphere >= maxMeters && posCylinder >= maxMeters && posHoop >= maxMeters {
                isRunning = false
            }
        }
    }
    
    func reset() {
        raceTime = 0.0
        posSphere = 0.0
        posCylinder = 0.0
        posHoop = 0.0
        isRunning = false
    }
}

enum ShapeType {
    case solidSphere
    case solidCylinder
    case hoop
}

struct RollingShapeView: View {
    let name: String
    let color: Color
    let type: ShapeType
    let rotation: CGFloat
    
    var body: some View {
        ZStack {
            if type == .hoop {
                // Hoop is hollow
                Circle()
                    .stroke(color, lineWidth: 4)
                    .background(Color.clear)
            } else if type == .solidCylinder {
                Circle()
                    .fill(color.opacity(0.3))
                    .overlay(Circle().stroke(color, lineWidth: 2))
            } else {
                Circle()
                    .fill(RadialGradient(colors: [.white, color], center: .center, startRadius: 1, endRadius: 16))
            }
            
            // Rotation markings so rotation is visible
            Path { path in
                path.move(to: CGPoint(x: 16, y: 0))
                path.addLine(to: CGPoint(x: 16, y: 32))
                path.move(to: CGPoint(x: 0, y: 16))
                path.addLine(to: CGPoint(x: 32, y: 16))
            }
            .stroke(Color.black.opacity(0.5), lineWidth: 1.5)
            
            // Small badge text
            Text(name.prefix(1))
                .font(.caption2.bold())
                .foregroundColor(.white)
                .shadow(radius: 2)
        }
        .rotationEffect(.radians(Double(rotation)))
    }
}
