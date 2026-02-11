import SwiftUI

struct TideGraph: View {
    let forecast: DayForecast
    @State private var touched: TideReading?
    @State private var showTip = false

    var body: some View {
        VStack(spacing: 14) {
            // Lunar label
            HStack(spacing: 8) {
                LunarDisc(stage: forecast.lunar, diameter: 26)
                Text(forecast.lunar.label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(OceanPalette.Ink.frost)
                Spacer()
            }

            // Graph area
            GeometryReader { geo in
                let cw = geo.size.width - 40
                let ch = geo.size.height - 28

                ZStack(alignment: .topLeading) {
                    gridLines(cw: cw, ch: ch)
                    fillArea(cw: cw, ch: ch)
                    curveLine(cw: cw, ch: ch)
                    hourLabels(cw: cw, ch: ch, fullHeight: geo.size.height)

                    if showTip, let pt = touched {
                        tipBubble(pt, cw: cw, ch: ch, fullW: geo.size.width)
                    }
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { v in onTouch(v.location, cw: cw, ch: ch) }
                        .onEnded { _ in withAnimation(.easeOut(duration: 0.25)) { showTip = false } }
                )
            }
            .frame(height: 190)

            // Prime windows
            Text(forecast.windowSummary)
                .font(.system(size: 13))
                .foregroundColor(OceanPalette.Ink.primeGreen)
                .multilineTextAlignment(.center)
        }
        .padding(16)
        .deepPanel()
    }

    // MARK: - Drawing

    private func gridLines(cw: CGFloat, ch: CGFloat) -> some View {
        ForEach([0, 25, 50, 75, 100], id: \.self) { pct in
            let y = ch * (1 - CGFloat(pct) / 100)
            HStack(spacing: 4) {
                Text("\(pct)")
                    .font(.system(size: 9))
                    .foregroundColor(OceanPalette.Ink.frost.opacity(0.4))
                    .frame(width: 28, alignment: .trailing)
                Rectangle()
                    .fill(OceanPalette.Ink.frost.opacity(0.08))
                    .frame(height: 1)
            }
            .offset(y: y - 5)
        }
    }

    private func curveLine(cw: CGFloat, ch: CGFloat) -> some View {
        let pts = forecast.readings
        return Path { p in
            guard !pts.isEmpty else { return }
            let dx = cw / CGFloat(pts.count - 1)
            for (i, r) in pts.enumerated() {
                let x: CGFloat = 35 + CGFloat(i) * dx
                let y = ch * (1 - CGFloat(r.amplitude))
                if i == 0 { p.move(to: CGPoint(x: x, y: y)) }
                else { p.addLine(to: CGPoint(x: x, y: y)) }
            }
        }
        .stroke(
            LinearGradient(colors: [OceanPalette.Ink.gold, OceanPalette.Ink.amber],
                           startPoint: .leading, endPoint: .trailing),
            style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)
        )
    }

    private func fillArea(cw: CGFloat, ch: CGFloat) -> some View {
        let pts = forecast.readings
        return Path { p in
            guard !pts.isEmpty else { return }
            let dx = cw / CGFloat(pts.count - 1)
            p.move(to: CGPoint(x: 35, y: ch))
            for (i, r) in pts.enumerated() {
                let x: CGFloat = 35 + CGFloat(i) * dx
                let y = ch * (1 - CGFloat(r.amplitude))
                p.addLine(to: CGPoint(x: x, y: y))
            }
            p.addLine(to: CGPoint(x: 35 + cw, y: ch))
            p.closeSubpath()
        }
        .fill(
            LinearGradient(colors: [OceanPalette.Ink.amber.opacity(0.25), OceanPalette.Ink.amber.opacity(0.03)],
                           startPoint: .top, endPoint: .bottom)
        )
    }

    private func hourLabels(cw: CGFloat, ch: CGFloat, fullHeight: CGFloat) -> some View {
        HStack(spacing: 0) {
            Spacer().frame(width: 35)
            ForEach([0, 6, 12, 18, 23], id: \.self) { h in
                if h > 0 { Spacer() }
                Text(String(format: "%02d:00", h))
                    .font(.system(size: 9))
                    .foregroundColor(OceanPalette.Ink.frost.opacity(0.5))
                if h < 23 { Spacer() }
            }
        }
        .offset(y: fullHeight - 18)
    }

    private func onTouch(_ loc: CGPoint, cw: CGFloat, ch: CGFloat) {
        let relX = loc.x - 35
        let pct = relX / cw
        let idx = Int(pct * CGFloat(forecast.readings.count - 1))
        if idx >= 0 && idx < forecast.readings.count {
            touched = forecast.readings[idx]
            withAnimation(.easeOut(duration: 0.12)) { showTip = true }
        }
    }

    private func tipBubble(_ pt: TideReading, cw: CGFloat, ch: CGFloat, fullW: CGFloat) -> some View {
        let idx = forecast.readings.firstIndex(where: { $0.id == pt.id }) ?? 0
        let dx = cw / CGFloat(forecast.readings.count - 1)
        let x = 35 + CGFloat(idx) * dx
        let y = ch * (1 - CGFloat(pt.amplitude))

        return VStack(spacing: 3) {
            Text(pt.clock)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(OceanPalette.Ink.ivory)
            Text("\(pt.percent)%")
                .font(.system(size: 10))
                .foregroundColor(OceanPalette.Ink.gold)
            Text(pt.prospect.explanation)
                .font(.system(size: 9))
                .foregroundColor(prospectTint(pt.prospect))
                .multilineTextAlignment(.center)
        }
        .padding(8)
        .background(OceanPalette.Ink.raised)
        .cornerRadius(8)
        .shadow(radius: 4)
        .position(x: min(max(x, 80), fullW - 80), y: max(y - 50, 40))
    }

    private func prospectTint(_ p: FeedingProspect) -> Color {
        switch p {
        case .hotBite: return OceanPalette.Ink.primeGreen
        case .steadyBite: return OceanPalette.Ink.cautionOrange
        case .coldBite: return OceanPalette.Ink.mutedSteel
        }
    }
}
