import SwiftUI

struct FormulaUnit: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let formulas: [FormulaItem]
}

struct FormulaData {
    static let units: [FormulaUnit] = [
        FormulaUnit(
            title: "Units & Measurements",
            subtitle: "Dimensions, errors & standard units",
            icon: "ruler",
            color: Color(red: 0.15, green: 0.65, blue: 0.60),
            formulas: [
                FormulaItem(
                    title: "Dimensional Formula of Force",
                    formula: "[M L T⁻²]",
                    explanation: """
Dimensions represent the base physical quantities.
Where:
• [M] = Dimension of Mass
• [L] = Dimension of Length
• [T] = Dimension of Time
Used for checking dimensional homogeneity of physical equations.
"""
                ),
                FormulaItem(
                    title: "Absolute Error",
                    formula: "Δa = |a_mean - a_i|",
                    explanation: """
Difference between the true value and the individual measured value.
Where:
• Δa = Absolute Error of the i-th measurement
• a_mean = Arithmetic mean of all measurements (taken as true value)
• a_i = Value obtained in the i-th measurement
Note: Absolute error is always positive (indicated by absolute value bars).
"""
                ),
                FormulaItem(
                    title: "Relative Error",
                    formula: "δa = Δa_mean / a_mean",
                    explanation: """
Ratio of mean absolute error to the mean value of the quantity.
Where:
• δa = Relative Error (dimensionless)
• Δa_mean = Mean Absolute Error
• a_mean = Arithmetic mean value
"""
                ),
                FormulaItem(
                    title: "Percentage Error",
                    formula: "δa% = (Δa_mean / a_mean) * 100",
                    explanation: """
Relative error expressed in percentage terms.
Where:
• δa% = Percentage Error
• Δa_mean = Mean Absolute Error
• a_mean = Arithmetic mean value
"""
                )
            ]
        ),
        FormulaUnit(
            title: "Kinematics",
            subtitle: "Motion in 1D & 2D, projectiles",
            icon: "arrow.up.right",
            color: Color(red: 0.22, green: 0.45, blue: 0.85),
            formulas: [
                FormulaItem(
                    title: "Equations of Motion",
                    formula: "v = u + at\ns = ut + ½at²\nv² = u² + 2as",
                    explanation: """
Relates key motion variables for constant/uniform acceleration.
Where:
• u = Initial velocity (m/s)
• v = Final velocity (m/s)
• a = Constant acceleration (m/s²)
• t = Time interval (s)
• s = Displacement (m)
"""
                ),
                FormulaItem(
                    title: "Time of Flight (Projectile)",
                    formula: "T = 2u sinθ / g",
                    explanation: """
Total duration the projectile remains in the air.
Where:
• T = Time of flight (s)
• u = Initial launch velocity (m/s)
• θ = Angle of projection relative to horizontal
• g = Acceleration due to gravity
  (Constant value: g ≈ 9.8 m/s² or 10 m/s²)
"""
                ),
                FormulaItem(
                    title: "Maximum Height (Projectile)",
                    formula: "H = u² sin²θ / 2g",
                    explanation: """
The highest vertical point attained by the projectile.
Where:
• H = Maximum height (m)
• u = Initial launch velocity (m/s)
• θ = Angle of projection
• g = Acceleration due to gravity (g ≈ 9.8 m/s²)
"""
                ),
                FormulaItem(
                    title: "Horizontal Range (Projectile)",
                    formula: "R = u² sin(2θ) / g",
                    explanation: """
Maximum horizontal distance travelled by the projectile.
Where:
• R = Horizontal range (m)
• u = Initial launch velocity (m/s)
• θ = Angle of projection
• g = Acceleration due to gravity (g ≈ 9.8 m/s²)
Note: Range is maximum when launch angle θ = 45°.
"""
                )
            ]
        ),
        FormulaUnit(
            title: "Laws of Motion",
            subtitle: "Newton's laws, force & friction",
            icon: "hand.raised.fill",
            color: Color(red: 0.82, green: 0.25, blue: 0.25),
            formulas: [
                FormulaItem(
                    title: "Newton's Second Law",
                    formula: "F = dp/dt = ma",
                    explanation: """
Net force acting on a body is equal to its rate of change of momentum.
Where:
• F = Net external force (N, where 1 N = 1 kg·m/s²)
• p = Linear momentum (kg·m/s)
• t = Time (s)
• m = Inertial mass of the body (kg)
• a = Acceleration produced (m/s²)
"""
                ),
                FormulaItem(
                    title: "Linear Momentum",
                    formula: "p = mv",
                    explanation: """
Vector quantity representing the amount of motion of a body.
Where:
• p = Linear momentum vector (kg·m/s)
• m = Mass of the body (kg)
• v = Velocity vector (m/s)
"""
                ),
                FormulaItem(
                    title: "Static Friction Max",
                    formula: "f_s ≤ μ_s * N",
                    explanation: """
Force that opposes the initiation of sliding motion.
Where:
• f_s = Static friction force (N)
• μ_s = Coefficient of static friction (dimensionless constant)
• N = Normal reaction force (N)
Note: Friction is self-adjusting up to the limiting value (f_max = μ_s * N).
"""
                ),
                FormulaItem(
                    title: "Kinetic Friction",
                    formula: "f_k = μ_k * N",
                    explanation: """
Friction acting between two surfaces sliding relative to each other.
Where:
• f_k = Kinetic friction force (N)
• μ_k = Coefficient of kinetic friction (dimensionless constant)
• N = Normal reaction force (N)
Note: Typically, μ_k < μ_s for the same surfaces.
"""
                ),
                FormulaItem(
                    title: "Centripetal Force",
                    formula: "F_c = m * v² / r",
                    explanation: """
Inward force required to keep a body moving along a circular path.
Where:
• F_c = Centripetal force (N)
• m = Mass of the rotating body (kg)
• v = Linear speed of the body (m/s)
• r = Radius of the circular trajectory (m)
"""
                )
            ]
        ),
        FormulaUnit(
            title: "Work, Energy & Power",
            subtitle: "Energy conservation & collisions",
            icon: "bolt.fill",
            color: Color(red: 0.90, green: 0.58, blue: 0.15),
            formulas: [
                FormulaItem(
                    title: "Work Done",
                    formula: "W = F · d = F * d * cosθ",
                    explanation: """
Measure of energy transfer that occurs when an object is moved by an external force.
Where:
• W = Work done (Joules, J where 1 J = 1 N·m)
• F = Magnitude of the force (N)
• d = Magnitude of the displacement (m)
• θ = Angle between the force and displacement vectors
"""
                ),
                FormulaItem(
                    title: "Kinetic Energy",
                    formula: "K = ½mv² = p² / (2m)",
                    explanation: """
Energy possessed by a body due to its motion.
Where:
• K = Kinetic energy (J)
• m = Mass of the body (kg)
• v = Speed of the body (m/s)
• p = Linear momentum (kg·m/s)
"""
                ),
                FormulaItem(
                    title: "Potential Energy (Gravity)",
                    formula: "U = mgh",
                    explanation: """
Energy stored in a mass due to its position in a gravitational field.
Where:
• U = Gravitational potential energy (J)
• m = Mass of the object (kg)
• g = Acceleration due to gravity (Constant: g ≈ 9.8 m/s²)
• h = Vertical height from reference level (m)
"""
                ),
                FormulaItem(
                    title: "Power",
                    formula: "P = dW/dt = F · v",
                    explanation: """
Rate at which work is performed or energy is consumed.
Where:
• P = Power (Watts, W where 1 W = 1 J/s)
• W = Work done (J)
• t = Time (s)
• F = Force vector (N)
• v = Velocity vector (m/s)
"""
                ),
                FormulaItem(
                    title: "Coefficient of Restitution",
                    formula: "e = (v₂ - v₁) / (u₁ - u₂)",
                    explanation: """
Ratio of relative velocity of separation to relative velocity of approach.
Where:
• e = Coefficient of restitution (dimensionless parameter)
• u₁, u₂ = Velocities of bodies 1 and 2 before collision (m/s)
• v₁, v₂ = Velocities of bodies 1 and 2 after collision (m/s)
Note: e = 1 (Elastic), e = 0 (Completely Inelastic).
"""
                )
            ]
        ),
        FormulaUnit(
            title: "Rotational Motion",
            subtitle: "Inertia, torque & angular momentum",
            icon: "arrow.clockwise.circle",
            color: Color(red: 0.58, green: 0.35, blue: 0.88),
            formulas: [
                FormulaItem(
                    title: "Center of Mass",
                    formula: "R_cm = Σ(m_i * r_i) / Σm_i",
                    explanation: """
The unique point where the entire mass of a system may be assumed to be concentrated.
Where:
• R_cm = Position vector of center of mass (m)
• m_i = Mass of the i-th particle (kg)
• r_i = Position vector of the i-th particle (m)
"""
                ),
                FormulaItem(
                    title: "Torque",
                    formula: "τ = r × F = I * α",
                    explanation: """
The rotational analog of linear force; measures turning ability.
Where:
• τ = Torque vector (N·m)
• r = Position vector of point of force application (m)
• F = Applied force vector (N)
• I = Moment of inertia of the body (kg·m²)
• α = Angular acceleration vector (rad/s²)
"""
                ),
                FormulaItem(
                    title: "Moment of Inertia",
                    formula: "I = Σ(m_i * r_i²)",
                    explanation: """
A body's resistance to change in its rotational motion.
Where:
• I = Moment of inertia (kg·m²)
• m_i = Mass of the i-th particle (kg)
• r_i = Perpendicular distance of the i-th particle from the axis of rotation (m)
"""
                ),
                FormulaItem(
                    title: "Angular Momentum",
                    formula: "L = r × p = I * ω",
                    explanation: """
Rotational counterpart of linear momentum.
Where:
• L = Angular momentum vector (kg·m²/s or J·s)
• r = Position vector relative to reference (m)
• p = Linear momentum vector (kg·m/s)
• I = Moment of inertia (kg·m²)
• ω = Angular velocity vector (rad/s)
"""
                ),
                FormulaItem(
                    title: "Rotational Kinetic Energy",
                    formula: "K_rot = ½ * I * ω²",
                    explanation: """
Kinetic energy stored in a body due to its rotation.
Where:
• K_rot = Rotational kinetic energy (J)
• I = Moment of inertia (kg·m²)
• ω = Angular velocity (rad/s)
"""
                )
            ]
        ),
        FormulaUnit(
            title: "Gravitation",
            subtitle: "Planetary orbits & escape speed",
            icon: "globe",
            color: Color(red: 0.28, green: 0.60, blue: 0.90),
            formulas: [
                FormulaItem(
                    title: "Universal Gravitation",
                    formula: "F = G * M * m / r²",
                    explanation: """
Gravitational force of attraction between two spherical point masses.
Where:
• F = Gravitational force (N)
• M, m = Masses of the two interacting bodies (kg)
• r = Distance between their centers (m)
• G = Universal Gravitational Constant
  (Constant value: G ≈ 6.674 × 10⁻¹¹ N·m²/kg²)
"""
                ),
                FormulaItem(
                    title: "Acceleration due to Gravity",
                    formula: "g = G * M / R²",
                    explanation: """
The acceleration experienced by a body due to gravitational pull of a planet.
Where:
• g = Acceleration due to gravity (m/s²)
• M = Mass of the planet (kg)
• R = Radius of the planet (m)
• G = Universal Gravitational Constant (G ≈ 6.674 × 10⁻¹¹ N·m²/kg²)
"""
                ),
                FormulaItem(
                    title: "Gravitational Potential Energy",
                    formula: "U = -G * M * m / r",
                    explanation: """
Work required to assemble the masses from infinite separation to distance r.
Where:
• U = Gravitational potential energy (J)
• M, m = Participating masses (kg)
• r = Center-to-center separation distance (m)
• G = Universal Gravitational Constant (G ≈ 6.674 × 10⁻¹¹ N·m²/kg²)
"""
                ),
                FormulaItem(
                    title: "Escape Velocity",
                    formula: "v_e = √(2 * G * M / R) = √(2 * g * R)",
                    explanation: """
Minimum speed required to escape the gravitational field of a primary body.
Where:
• v_e = Escape velocity (m/s)
• M = Mass of the celestial body (kg)
• R = Radius of the celestial body (m)
• g = Surface gravitational acceleration (g ≈ 9.8 m/s²)
• G = Universal Gravitational Constant (G ≈ 6.674 × 10⁻¹¹ N·m²/kg²)
"""
                ),
                FormulaItem(
                    title: "Orbital Velocity",
                    formula: "v_o = √(G * M / r)",
                    explanation: """
Velocity needed to keep a satellite in circular orbit at radius r.
Where:
• v_o = Orbital velocity (m/s)
• M = Mass of the central attracting planet (kg)
• r = Distance from the planet's center to the satellite (m)
• G = Universal Gravitational Constant (G ≈ 6.674 × 10⁻¹¹ N·m²/kg²)
"""
                )
            ]
        ),
        FormulaUnit(
            title: "Properties of Matter",
            subtitle: "Solids, fluids & fluid mechanics",
            icon: "square.stack.3d.up.fill",
            color: Color(red: 0.32, green: 0.70, blue: 0.92),
            formulas: [
                FormulaItem(
                    title: "Young's Modulus",
                    formula: "Y = (F/A) / (ΔL/L₀)",
                    explanation: """
Measure of resistance of solid material to elastic elongation.
Where:
• Y = Young's Modulus of elasticity (N/m² or Pascal, Pa)
• F = Applied tensile/compressive force (N)
• A = Cross-sectional area of load application (m²)
• L₀ = Original undeformed length of object (m)
• ΔL = Change in length under load (m)
"""
                ),
                FormulaItem(
                    title: "Fluid Pressure",
                    formula: "P = P₀ + ρ * g * h",
                    explanation: """
Total pressure at a depth inside a static liquid under gravity.
Where:
• P = Hydrostatic pressure at depth (N/m² or Pa)
• P₀ = Atmospheric pressure at fluid surface
  (Standard Constant: P₀ ≈ 1.013 × 10⁵ Pa or 1 atm)
• ρ = Mass density of fluid (kg/m³)
• g = Acceleration due to gravity (g ≈ 9.8 m/s²)
• h = Depth below the liquid surface (m)
"""
                ),
                FormulaItem(
                    title: "Continuity Equation",
                    formula: "A₁ * v₁ = A₂ * v₂",
                    explanation: """
Derived from the conservation of mass in a streamline fluid flow.
Where:
• A₁, A₂ = Cross-sectional areas of pipe at points 1 & 2 (m²)
• v₁, v₂ = Velocities of fluid flow at points 1 & 2 (m/s)
"""
                ),
                FormulaItem(
                    title: "Bernoulli's Equation",
                    formula: "P + ½ * ρ * v² + ρ * g * h = Constant",
                    explanation: """
Statement of energy conservation for frictionless, streamline fluid flow.
Where:
• P = Static pressure (Pa)
• ρ = Mass density of the fluid (kg/m³)
• v = Fluid flow velocity (m/s)
• g = Acceleration due to gravity (g ≈ 9.8 m/s²)
• h = Elevation height above reference level (m)
"""
                ),
                FormulaItem(
                    title: "Viscous Drag (Stokes' Law)",
                    formula: "F_d = 6 * π * η * r * v",
                    explanation: """
Drag force acting on a sphere moving through a viscous fluid.
Where:
• F_d = Viscous drag force (N)
• η = Dynamic coefficient of viscosity of the fluid (Pa·s)
• r = Radius of the spherical object (m)
• v = Terminal velocity of the sphere (m/s)
• π = Pi (Mathematical constant: π ≈ 3.14159)
"""
                )
            ]
        ),
        FormulaUnit(
            title: "Thermal Properties",
            subtitle: "Heat transfer & thermal expansion",
            icon: "thermometer.medium",
            color: Color(red: 0.95, green: 0.40, blue: 0.20),
            formulas: [
                FormulaItem(
                    title: "Thermal Expansion",
                    formula: "ΔL = L₀ * α * ΔT",
                    explanation: """
Linear expansion of solids due to heating.
Where:
• ΔL = Increase in length (m)
• L₀ = Original length (m)
• α = Coefficient of linear expansion (material constant, K⁻¹ or °C⁻¹)
• ΔT = Temperature change (K or °C)
"""
                ),
                FormulaItem(
                    title: "Heat Capacity",
                    formula: "Q = m * c * ΔT",
                    explanation: """
Heat energy transferred to change the temperature of a mass.
Where:
• Q = Heat energy added or removed (J or Calorie)
• m = Mass of the substance (kg)
• c = Specific heat capacity (material specific constant, J/kg·K)
• ΔT = Temperature difference (K or °C)
"""
                ),
                FormulaItem(
                    title: "Latent Heat",
                    formula: "Q = m * L",
                    explanation: """
Heat absorbed or released during phase transition without temperature change.
Where:
• Q = Heat energy transferred (J)
• m = Mass of substance undergoing phase change (kg)
• L = Latent heat constant of substance (e.g., fusion or vaporization, J/kg)
"""
                ),
                FormulaItem(
                    title: "Wien's Law",
                    formula: "λ_max * T = b",
                    explanation: """
Wavelength at which blackbody radiation intensity is maximum.
Where:
• λ_max = Wavelength of peak spectral emission (meters, m)
• T = Absolute temperature of blackbody (Kelvin, K)
• b = Wien's displacement constant
  (Constant value: b ≈ 2.898 × 10⁻³ m·K)
"""
                ),
                FormulaItem(
                    title: "Stefan-Boltzmann Law",
                    formula: "E = σ * A * T⁴",
                    explanation: """
Total energy emitted per unit time from blackbody surface.
Where:
• E = Rate of energy emission / power (W)
• A = Surface area of emitting body (m²)
• T = Absolute temperature (Kelvin, K)
• σ = Stefan-Boltzmann Constant
  (Constant value: σ ≈ 5.670 × 10⁻⁸ W/m²·K⁴)
"""
                )
            ]
        ),
        FormulaUnit(
            title: "Thermodynamics",
            subtitle: "Laws of heat & heat engines",
            icon: "flame.fill",
            color: Color(red: 0.92, green: 0.32, blue: 0.32),
            formulas: [
                FormulaItem(
                    title: "First Law of Thermodynamics",
                    formula: "ΔQ = ΔU + ΔW",
                    explanation: """
Conservation of energy in thermodynamic systems.
Where:
• ΔQ = Heat energy supplied to system (J)
• ΔU = Change in internal energy (J)
• ΔW = Work done by system on environment (J)
"""
                ),
                FormulaItem(
                    title: "Work in Isothermal Expansion",
                    formula: "W = n * R * T * ln(V_f / V_i)",
                    explanation: """
Work done by gas expanding at constant temperature.
Where:
• W = Work done (J)
• n = Amount of substance in moles (mol)
• T = Constant absolute temperature (Kelvin, K)
• V_i, V_f = Initial and final volumes of gas (m³)
• R = Universal Ideal Gas Constant
  (Constant value: R ≈ 8.314 J/mol·K)
"""
                ),
                FormulaItem(
                    title: "Work in Adiabatic Expansion",
                    formula: "W = (P_i*V_i - P_f*V_f) / (γ - 1)",
                    explanation: """
Work done when system undergoes change with zero heat exchange.
Where:
• W = Work done (J)
• P_i, V_i = Initial pressure (Pa) & volume (m³)
• P_f, V_f = Final pressure (Pa) & volume (m³)
• γ = Adiabatic index (Ratio of specific heats, dimensionless)
  (Constant example: γ ≈ 1.4 for dry air/diatomic gases)
"""
                ),
                FormulaItem(
                    title: "Carnot Engine Efficiency",
                    formula: "η = 1 - T_c / T_h",
                    explanation: """
Maximum theoretical efficiency of a cyclic heat engine.
Where:
• η = Thermal efficiency (fraction between 0 and 1)
• T_c = Temperature of the cold reservoir / sink (Kelvin, K)
• T_h = Temperature of the hot reservoir / source (Kelvin, K)
"""
                )
            ]
        ),
        FormulaUnit(
            title: "Kinetic Theory",
            subtitle: "Ideal gas laws & molecule motion",
            icon: "bubbles.and.sparkles",
            color: Color(red: 0.50, green: 0.68, blue: 0.22),
            formulas: [
                FormulaItem(
                    title: "Ideal Gas Equation",
                    formula: "P * V = n * R * T",
                    explanation: """
State equation relating pressure, volume, temperature of an ideal gas.
Where:
• P = Pressure of gas (Pa)
• V = Volume occupied by gas (m³)
• n = Quantity of gas (moles, mol)
• T = Absolute temperature (Kelvin, K)
• R = Universal Ideal Gas Constant (R ≈ 8.314 J/mol·K)
"""
                ),
                FormulaItem(
                    title: "Kinetic Pressure",
                    formula: "P = ⅓ * ρ * v_rms²",
                    explanation: """
Pressure derived from molecular collisions on container boundary.
Where:
• P = Gas pressure (Pa)
• ρ = Density of the gas (kg/m³)
• v_rms = Root-mean-square velocity of gas molecules (m/s)
"""
                ),
                FormulaItem(
                    title: "Average Kinetic Energy",
                    formula: "K_avg = ³/₂ * k_B * T",
                    explanation: """
Average translational kinetic energy of a single gas molecule.
Where:
• K_avg = Average kinetic energy per molecule (J)
• T = Absolute temperature (Kelvin, K)
• k_B = Boltzmann Constant
  (Constant value: k_B ≈ 1.381 × 10⁻²³ J/K)
"""
                ),
                FormulaItem(
                    title: "RMS Velocity",
                    formula: "v_rms = √(3 * R * T / M)",
                    explanation: """
Measure of typical speed of particles in gas.
Where:
• v_rms = Root-mean-square velocity (m/s)
• T = Temperature (Kelvin, K)
• M = Molar mass of the gas (kg/mol)
• R = Universal Ideal Gas Constant (R ≈ 8.314 J/mol·K)
"""
                )
            ]
        ),
        FormulaUnit(
            title: "Oscillations",
            subtitle: "Simple Harmonic Motion (SHM)",
            icon: "waveform.path.ecg",
            color: Color(red: 0.44, green: 0.44, blue: 0.88),
            formulas: [
                FormulaItem(
                    title: "SHM Displacement",
                    formula: "x = A * sin(ω * t + φ)",
                    explanation: """
Positional coordinate of a body oscillating in Simple Harmonic Motion.
Where:
• x = Displacement from equilibrium position (m)
• A = Amplitude (maximum displacement from mean position, m)
• ω = Angular frequency (rad/s)
• t = Elapsed time (s)
• φ = Phase constant or initial phase angle (rad)
"""
                ),
                FormulaItem(
                    title: "SHM Velocity",
                    formula: "v = ω * √(A² - x²)",
                    explanation: """
Speed of an oscillating body at displacement coordinate x.
Where:
• v = Linear velocity (m/s)
• ω = Angular frequency (rad/s)
• A = Oscillation amplitude (m)
• x = Instantaneous displacement from equilibrium (m)
Note: Velocity is maximum (v_max = ω*A) at equilibrium (x=0).
"""
                ),
                FormulaItem(
                    title: "SHM Acceleration",
                    formula: "a = -ω² * x",
                    explanation: """
Restoring acceleration in SHM, directed towards the center.
Where:
• a = Instantaneous linear acceleration (m/s²)
• ω = Angular frequency (rad/s)
• x = Instantaneous displacement from equilibrium (m)
Note: Acceleration is maximum (a_max = ω²*A) at extreme points (x = ±A).
"""
                ),
                FormulaItem(
                    title: "Simple Pendulum Period",
                    formula: "T = 2 * π * √(L / g)",
                    explanation: """
Time required to complete one full oscillation cycle.
Where:
• T = Time period of pendulum (s)
• L = Length of pendulum string (m)
• g = Acceleration due to gravity (g ≈ 9.8 m/s²)
• π = Pi (Mathematical constant: π ≈ 3.14159)
Note: Valid only for small amplitude oscillations (< 15 degrees).
"""
                ),
                FormulaItem(
                    title: "Spring-Mass System Period",
                    formula: "T = 2 * π * √(m / k)",
                    explanation: """
Time period of a mass oscillating on a linear spring.
Where:
• T = Oscillation period (s)
• m = Mass of oscillating load (kg)
• k = Spring stiffness constant / force constant (N/m)
• π = Pi (Constant: π ≈ 3.14159)
"""
                )
            ]
        ),
        FormulaUnit(
            title: "Waves",
            subtitle: "Sound waves & wave propagation",
            icon: "waveform",
            color: Color(red: 0.52, green: 0.52, blue: 0.58),
            formulas: [
                FormulaItem(
                    title: "Wave Velocity",
                    formula: "v = f * λ",
                    explanation: """
The speed at which a wave profile propagates through a medium.
Where:
• v = Wave velocity (m/s)
• f = Frequency of oscillation (Hertz, Hz where 1 Hz = 1/s)
• λ = Wavelength (Greek letter Lambda, distance of one full wave cycle, m)
"""
                ),
                FormulaItem(
                    title: "Velocity of Sound in Gas",
                    formula: "v = √(γ * P / ρ)",
                    explanation: """
The speed of sound in a gas derived from the Newton-Laplace formula.
Where:
• v = Velocity of sound waves (m/s)
• P = Static pressure of the gas (Pa)
• ρ = Mass density of the gas medium (kg/m³)
• γ = Adiabatic index of the gas (ratio of specific heats, dimensionless constant)
  (Constant example: γ ≈ 1.4 for diatomic gases like Air)
"""
                ),
                FormulaItem(
                    title: "Wave on Stretched String",
                    formula: "v = √(T / μ)",
                    explanation: """
Speed of transverse waves propagating along a stretched wire or string.
Where:
• v = Wave velocity (m/s)
• T = Tension force applied to the string (N)
• μ = Linear mass density / mass per unit length (Greek letter Mu, kg/m)
"""
                ),
                FormulaItem(
                    title: "Doppler Effect (Frequency)",
                    formula: "f' = f * (v ± v_o) / (v ∓ v_s)",
                    explanation: """
Observed shift in frequency due to relative motion between source and observer.
Where:
• f' = Apparent frequency heard by observer (Hz)
• f = True frequency emitted by source (Hz)
• v = Speed of sound wave in medium (m/s)
• v_o = Speed of observer relative to medium (m/s)
• v_s = Speed of source relative to medium (m/s)
Note: Use upper signs (+ in numerator, - in denominator) when source/observer approach each other.
"""
                )
            ]
        )
    ]
}
