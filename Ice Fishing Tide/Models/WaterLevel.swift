import Foundation

struct WaterLevel: Identifiable {
    let id = UUID()
    let hour: Int
    let minute: Int
    let level: Double // 0.0 to 1.0 (0% to 100%)
    let isRising: Bool
    let zone: FishingZone
    
    var timeString: String {
        String(format: "%02d:%02d", hour, minute)
    }
    
    var levelPercent: Int {
        Int(level * 100)
    }
}

enum FishingZone: String {
    case excellent = "excellent"
    case medium = "medium"
    case poor = "poor"
    
    var description: String {
        switch self {
        case .excellent:
            return "Water rising - fish are actively feeding"
        case .medium:
            return "Water at peak or slowly falling - moderate activity"
        case .poor:
            return "Water falling quickly - low fish activity"
        }
    }
}

struct DailyWaterData: Identifiable {
    let id = UUID()
    let date: Date
    let levels: [WaterLevel]
    let moonPhase: MoonPhase
    let bestTimeRanges: [TimeRange]
    
    var bestTimeDescription: String {
        if bestTimeRanges.isEmpty {
            return "No optimal fishing times today"
        }
        let ranges = bestTimeRanges.map { "\($0.start)-\($0.end)" }
        return "Best times today: " + ranges.joined(separator: " and ")
    }
}

struct TimeRange {
    let start: String
    let end: String
}
