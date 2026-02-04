import Foundation

class WaterLevelSimulator {
    static let shared = WaterLevelSimulator()
    
    private init() {}
    
    func generateDailyData(for date: Date, waterBody: WaterBodyType) -> DailyWaterData {
        let moonPhase = MoonCalculator.shared.getMoonPhase(for: date)
        let levels = generateLevels(for: date, waterBody: waterBody, moonPhase: moonPhase)
        let bestTimeRanges = findBestTimeRanges(levels: levels)
        
        return DailyWaterData(
            date: date,
            levels: levels,
            moonPhase: moonPhase,
            bestTimeRanges: bestTimeRanges
        )
    }
    
    private func generateLevels(for date: Date, waterBody: WaterBodyType, moonPhase: MoonPhase) -> [WaterLevel] {
        var levels: [WaterLevel] = []
        
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let seed = Double(dayOfYear) * 0.1
        
        let tidalAmplitude = moonPhase.tidalStrength * waterBody.moonInfluence
        let baseAmplitude = 0.3 + tidalAmplitude * 0.4
        
        // Generate hourly data points
        for hour in 0..<24 {
            for minuteOffset in stride(from: 0, to: 60, by: 30) {
                let timeValue = Double(hour) + Double(minuteOffset) / 60.0
                
                // Primary tide cycle (roughly 12.4 hours)
                let primaryTide = sin((timeValue + seed) * .pi / 6.2) * baseAmplitude
                
                // Secondary variation
                let secondaryTide = sin((timeValue + seed * 2) * .pi / 3.1) * baseAmplitude * 0.3
                
                // Water body specific variation
                let bodyVariation: Double
                switch waterBody {
                case .river:
                    bodyVariation = sin(timeValue * .pi / 8) * 0.15
                case .reservoir:
                    bodyVariation = (timeValue > 6 && timeValue < 18) ? 0.1 : -0.1
                case .lakeInflow:
                    bodyVariation = sin(timeValue * .pi / 12) * 0.2
                }
                
                // Calculate final level (0 to 1)
                let rawLevel = 0.5 + primaryTide + secondaryTide + bodyVariation
                let level = max(0, min(1, rawLevel))
                
                // Determine if rising
                let nextTimeValue = timeValue + 0.5
                let nextPrimary = sin((nextTimeValue + seed) * .pi / 6.2) * baseAmplitude
                let nextSecondary = sin((nextTimeValue + seed * 2) * .pi / 3.1) * baseAmplitude * 0.3
                let nextRaw = 0.5 + nextPrimary + nextSecondary + bodyVariation
                let isRising = nextRaw > rawLevel
                
                // Determine fishing zone
                let zone = determineFishingZone(level: level, isRising: isRising, moonPhase: moonPhase)
                
                levels.append(WaterLevel(
                    hour: hour,
                    minute: minuteOffset,
                    level: level,
                    isRising: isRising,
                    zone: zone
                ))
            }
        }
        
        return levels
    }
    
    private func determineFishingZone(level: Double, isRising: Bool, moonPhase: MoonPhase) -> FishingZone {
        if isRising && level > 0.4 {
            return .excellent
        } else if level > 0.6 || (level > 0.3 && !isRising) {
            return .medium
        } else {
            return .poor
        }
    }
    
    private func findBestTimeRanges(levels: [WaterLevel]) -> [TimeRange] {
        var ranges: [TimeRange] = []
        var rangeStart: String?
        var lastExcellent: String?
        
        for level in levels {
            if level.zone == .excellent {
                if rangeStart == nil {
                    rangeStart = level.timeString
                }
                lastExcellent = level.timeString
            } else {
                if let start = rangeStart, let end = lastExcellent {
                    ranges.append(TimeRange(start: start, end: end))
                    rangeStart = nil
                    lastExcellent = nil
                }
            }
        }
        
        // Close final range if needed
        if let start = rangeStart, let end = lastExcellent {
            ranges.append(TimeRange(start: start, end: end))
        }
        
        return ranges
    }
}
