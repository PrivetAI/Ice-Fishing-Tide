import SwiftUI

// MARK: - Wave Pattern Background

struct DeepWaveBackground: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                OceanPalette.Ink.seaGradient

                // Three layered waves at bottom
                RollingWave(phaseShift: 0, amplitude: 18)
                    .fill(OceanPalette.Ink.midnightBlue.opacity(0.4))
                    .frame(height: 120)
                    .offset(y: geo.size.height - 100)

                RollingWave(phaseShift: 1.2, amplitude: 14)
                    .fill(OceanPalette.Ink.slate.opacity(0.25))
                    .frame(height: 100)
                    .offset(y: geo.size.height - 70)

                RollingWave(phaseShift: 2.8, amplitude: 10)
                    .fill(OceanPalette.Ink.deepNavy.opacity(0.5))
                    .frame(height: 80)
                    .offset(y: geo.size.height - 40)
            }
        }
        .ignoresSafeArea()
    }
}

struct RollingWave: Shape {
    var phaseShift: Double
    var amplitude: Double

    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: 0, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height * 0.5))

        let steps = Int(rect.width / 3)
        for i in 0...steps {
            let x = CGFloat(i) * 3
            let frac = Double(x) / Double(rect.width)
            let y = rect.height * 0.5 + CGFloat(sin((frac * 4.0 + phaseShift) * .pi) * amplitude)
            p.addLine(to: CGPoint(x: x, y: y))
        }

        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.closeSubpath()
        return p
    }
}

// MARK: - Hexagonal Card Shape

struct HexCardShape: Shape {
    func path(in rect: CGRect) -> Path {
        let inset: CGFloat = 8
        var p = Path()
        p.move(to: CGPoint(x: inset, y: 0))
        p.addLine(to: CGPoint(x: rect.width - inset, y: 0))
        p.addLine(to: CGPoint(x: rect.width, y: inset))
        p.addLine(to: CGPoint(x: rect.width, y: rect.height - inset))
        p.addLine(to: CGPoint(x: rect.width - inset, y: rect.height))
        p.addLine(to: CGPoint(x: inset, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height - inset))
        p.addLine(to: CGPoint(x: 0, y: inset))
        p.closeSubpath()
        return p
    }
}

// MARK: - Diamond Accent

struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: 0))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.addLine(to: CGPoint(x: 0, y: rect.midY))
        p.closeSubpath()
        return p
    }
}

// MARK: - Score Arc

struct ScoreArc: Shape {
    var progress: Double // 0 to 1

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - 4
        let start = Angle.degrees(-225)
        let end = Angle.degrees(-225 + 270 * progress)
        p.addArc(center: center, radius: radius, startAngle: start, endAngle: end, clockwise: false)
        return p
    }
}
