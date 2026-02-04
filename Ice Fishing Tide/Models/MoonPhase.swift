import Foundation

enum MoonPhase: Int, CaseIterable, Identifiable {
    case newMoon = 0
    case waxingCrescent = 1
    case firstQuarter = 2
    case waxingGibbous = 3
    case fullMoon = 4
    case waningGibbous = 5
    case lastQuarter = 6
    case waningCrescent = 7
    
    var id: Int { rawValue }
    
    var displayName: String {
        switch self {
        case .newMoon: return "New Moon"
        case .waxingCrescent: return "Waxing Crescent"
        case .firstQuarter: return "First Quarter"
        case .waxingGibbous: return "Waxing Gibbous"
        case .fullMoon: return "Full Moon"
        case .waningGibbous: return "Waning Gibbous"
        case .lastQuarter: return "Last Quarter"
        case .waningCrescent: return "Waning Crescent"
        }
    }
    
    var fishingQuality: FishingQuality {
        switch self {
        case .newMoon, .fullMoon:
            return .excellent
        case .waxingCrescent, .waningCrescent:
            return .good
        case .firstQuarter, .lastQuarter:
            return .medium
        case .waxingGibbous, .waningGibbous:
            return .poor
        }
    }
    
    var tidalStrength: Double {
        switch self {
        case .newMoon, .fullMoon:
            return 1.0
        case .waxingCrescent, .waningCrescent:
            return 0.7
        case .firstQuarter, .lastQuarter:
            return 0.5
        case .waxingGibbous, .waningGibbous:
            return 0.3
        }
    }
}

enum FishingQuality: String {
    case excellent = "excellent"
    case good = "good"
    case medium = "medium"
    case poor = "poor"
}
