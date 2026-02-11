import Foundation

final class LunarCycle {
    static let engine = LunarCycle()
    private init() {}

    func stage(for date: Date) -> LunarStage {
        let v = rawPhase(for: date)
        let bucket = Int(v * 8) % 8
        return LunarStage(rawValue: bucket) ?? .dark
    }

    func daysToFull(from date: Date) -> Int {
        let v = rawPhase(for: date)
        if v < 0.5 {
            return Int((0.5 - v) * 29.53)
        }
        return Int((1.5 - v) * 29.53)
    }

    func daysToDark(from date: Date) -> Int {
        let v = rawPhase(for: date)
        return Int((1.0 - v) * 29.53)
    }

    // MARK: - Internal

    private func rawPhase(for date: Date) -> Double {
        let cal = Calendar.current
        let c = cal.dateComponents([.year, .month, .day], from: date)
        guard let yr = c.year, let mo = c.month, let dy = c.day else { return 0 }

        var y = yr, m = mo
        if m < 3 { y -= 1; m += 12 }

        let a = y / 100
        let b = a / 4
        let cc = 2 - a + b
        let e = Int(365.25 * Double(y + 4716))
        let f = Int(30.6001 * Double(m + 1))
        let jd = Double(cc + dy + e + f) - 1524.5

        let elapsed = jd - 2451549.5
        let cycles = elapsed / 29.53059
        return cycles - floor(cycles)
    }
}
