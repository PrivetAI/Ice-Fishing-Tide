import Foundation

class MoonCalculator {
    static let shared = MoonCalculator()
    
    private init() {}
    
    func getMoonPhase(for date: Date) -> MoonPhase {
        let phase = calculateMoonPhaseValue(for: date)
        return phaseFromValue(phase)
    }
    
    private func calculateMoonPhaseValue(for date: Date) -> Double {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        guard let year = components.year,
              let month = components.month,
              let day = components.day else {
            return 0
        }
        
        var y = year
        var m = month
        
        if m < 3 {
            y -= 1
            m += 12
        }
        
        let a = y / 100
        let b = a / 4
        let c = 2 - a + b
        let e = Int(365.25 * Double(y + 4716))
        let f = Int(30.6001 * Double(m + 1))
        let jd = Double(c + day + e + f) - 1524.5
        
        let daysSinceNew = jd - 2451549.5
        let newMoons = daysSinceNew / 29.53059
        let phase = (newMoons - floor(newMoons))
        
        return phase
    }
    
    private func phaseFromValue(_ value: Double) -> MoonPhase {
        let normalized = value * 8
        let index = Int(normalized) % 8
        return MoonPhase(rawValue: index) ?? .newMoon
    }
    
    func getDaysUntilFullMoon(from date: Date) -> Int {
        let phase = calculateMoonPhaseValue(for: date)
        let fullMoonPhase = 0.5
        
        if phase < fullMoonPhase {
            return Int((fullMoonPhase - phase) * 29.53)
        } else {
            return Int((1.0 - phase + fullMoonPhase) * 29.53)
        }
    }
    
    func getDaysUntilNewMoon(from date: Date) -> Int {
        let phase = calculateMoonPhaseValue(for: date)
        return Int((1.0 - phase) * 29.53)
    }
}
