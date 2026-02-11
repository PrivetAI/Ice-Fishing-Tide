import SwiftUI

// MARK: - Lunar Phase Rendered Disc

struct LunarDisc: View {
    let stage: LunarStage
    var diameter: CGFloat = 36

    var body: some View {
        ZStack {
            Circle()
                .fill(OceanPalette.Ink.frost.opacity(0.15))
                .frame(width: diameter, height: diameter)

            phaseShape
                .frame(width: diameter * 0.85, height: diameter * 0.85)
        }
        .frame(width: diameter, height: diameter)
    }

    @ViewBuilder
    private var phaseShape: some View {
        switch stage {
        case .dark:
            Circle()
                .stroke(OceanPalette.Ink.gold, lineWidth: 1.5)
        case .full:
            Circle()
                .fill(OceanPalette.Ink.gold)
        case .halfWax:
            HalfDisc(leftLit: false)
                .fill(OceanPalette.Ink.gold)
        case .halfWane:
            HalfDisc(leftLit: true)
                .fill(OceanPalette.Ink.gold)
        case .earlyWax:
            SlimCrescent(fraction: 0.25, waxing: true)
                .fill(OceanPalette.Ink.gold)
        case .earlyWane:
            SlimCrescent(fraction: 0.25, waxing: false)
                .fill(OceanPalette.Ink.gold)
        case .brightWax:
            FatGibbous(fraction: 0.75, waxing: true)
                .fill(OceanPalette.Ink.gold)
        case .brightWane:
            FatGibbous(fraction: 0.75, waxing: false)
                .fill(OceanPalette.Ink.gold)
        }
    }
}

// MARK: - Moon Shapes

private struct HalfDisc: Shape {
    let leftLit: Bool

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let r = min(rect.width, rect.height) / 2
        let sa: Angle = leftLit ? .degrees(-90) : .degrees(90)
        let ea: Angle = leftLit ? .degrees(90) : .degrees(270)
        p.addArc(center: center, radius: r, startAngle: sa, endAngle: ea, clockwise: false)
        p.closeSubpath()
        return p
    }
}

private struct SlimCrescent: Shape {
    let fraction: Double
    let waxing: Bool

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let r = min(rect.width, rect.height) / 2

        p.addArc(center: center, radius: r,
                 startAngle: .degrees(waxing ? -90 : 90),
                 endAngle: .degrees(waxing ? 90 : 270),
                 clockwise: false)

        let offset = r * CGFloat(1.0 - fraction * 2)
        let ic = CGPoint(x: center.x + (waxing ? -offset : offset), y: center.y)
        p.addArc(center: ic, radius: r,
                 startAngle: .degrees(waxing ? 90 : 270),
                 endAngle: .degrees(waxing ? -90 : 90),
                 clockwise: false)
        return p
    }
}

private struct FatGibbous: Shape {
    let fraction: Double
    let waxing: Bool

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let r = min(rect.width, rect.height) / 2

        p.addArc(center: center, radius: r,
                 startAngle: .degrees(-90),
                 endAngle: .degrees(90),
                 clockwise: waxing)

        let offset = r * CGFloat((fraction - 0.5) * 2)
        let ic = CGPoint(x: center.x + (waxing ? offset : -offset), y: center.y)
        p.addArc(center: ic, radius: r,
                 startAngle: .degrees(90),
                 endAngle: .degrees(-90),
                 clockwise: !waxing)
        return p
    }
}
