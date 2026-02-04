import Foundation

enum WaterBodyType: String, Codable, CaseIterable, Identifiable {
    case river = "river"
    case reservoir = "reservoir"
    case lakeInflow = "lakeInflow"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .river:
            return "River"
        case .reservoir:
            return "Reservoir"
        case .lakeInflow:
            return "Lake with Inflow"
        }
    }
    
    var description: String {
        switch self {
        case .river:
            return "Flow-based currents, weak moon influence"
        case .reservoir:
            return "Artificial water releases, weak moon influence"
        case .lakeInflow:
            return "Mixed regime: moon and inflow effects"
        }
    }
    
    var moonInfluence: Double {
        switch self {
        case .river:
            return 0.3
        case .reservoir:
            return 0.2
        case .lakeInflow:
            return 0.6
        }
    }
}
