import Foundation

final class TideEngine {
    static let engine = TideEngine()
    private init() {}

    func forecast(for date: Date, body: WaterBodyKind) -> DayForecast {
        let lunar = LunarCycle.engine.stage(for: date)
        let readings = buildReadings(date: date, body: body, lunar: lunar)
        let windows = extractWindows(readings)
        return DayForecast(date: date, readings: readings, lunar: lunar, primeWindows: windows)
    }

    // Predict best fishing score for a given day (0-100)
    func fishingScore(for date: Date, body: WaterBodyKind) -> Int {
        let lunar = LunarCycle.engine.stage(for: date)
        let base: Double
        switch lunar.biteRating {
        case .prime: base = 85
        case .favorable: base = 70
        case .moderate: base = 50
        case .sluggish: base = 30
        }
        let bodyBonus = body.lunarWeight * 15
        return min(100, Int(base + bodyBonus))
    }

    private func buildReadings(date: Date, body: WaterBodyKind, lunar: LunarStage) -> [TideReading] {
        var out: [TideReading] = []
        let cal = Calendar.current
        let doy = cal.ordinality(of: .day, in: .year, for: date) ?? 1
        let seed = Double(doy) * 0.1
        let tidalAmp = lunar.pullStrength * body.lunarWeight
        let baseAmp = 0.3 + tidalAmp * 0.4

        for hr in 0..<24 {
            for minOff in stride(from: 0, to: 60, by: 30) {
                let t = Double(hr) + Double(minOff) / 60.0
                let primary = sin((t + seed) * .pi / 6.2) * baseAmp
                let secondary = sin((t + seed * 2) * .pi / 3.1) * baseAmp * 0.3

                let bodyVar: Double
                switch body {
                case .flowingStream: bodyVar = sin(t * .pi / 8) * 0.15
                case .managedBasin: bodyVar = (t > 6 && t < 18) ? 0.1 : -0.1
                case .fedLake: bodyVar = sin(t * .pi / 12) * 0.2
                }

                let raw = 0.5 + primary + secondary + bodyVar
                let amp = max(0, min(1, raw))

                let nt = t + 0.5
                let nPri = sin((nt + seed) * .pi / 6.2) * baseAmp
                let nSec = sin((nt + seed * 2) * .pi / 3.1) * baseAmp * 0.3
                let nRaw = 0.5 + nPri + nSec + bodyVar
                let climbing = nRaw > raw

                let prospect = classifyProspect(amp: amp, climbing: climbing)
                out.append(TideReading(hour: hr, minute: minOff, amplitude: amp, climbing: climbing, prospect: prospect))
            }
        }
        return out
    }

    private func classifyProspect(amp: Double, climbing: Bool) -> FeedingProspect {
        if climbing && amp > 0.4 { return .hotBite }
        if amp > 0.6 || (amp > 0.3 && !climbing) { return .steadyBite }
        return .coldBite
    }

    private func extractWindows(_ readings: [TideReading]) -> [ClockWindow] {
        var windows: [ClockWindow] = []
        var start: String?
        var last: String?
        for r in readings {
            if r.prospect == .hotBite {
                if start == nil { start = r.clock }
                last = r.clock
            } else {
                if let s = start, let l = last {
                    windows.append(ClockWindow(open: s, close: l))
                    start = nil; last = nil
                }
            }
        }
        if let s = start, let l = last {
            windows.append(ClockWindow(open: s, close: l))
        }
        return windows
    }
}
