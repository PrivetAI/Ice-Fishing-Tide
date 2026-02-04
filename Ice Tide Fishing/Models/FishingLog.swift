import Foundation

struct FishingLog: Identifiable, Codable {
    let id: UUID
    let date: Date
    let hadBite: Bool
    let bestTimeHour: Int?
    let bestTimeMinute: Int?
    let moonPhaseRaw: Int
    
    init(id: UUID = UUID(), date: Date, hadBite: Bool, bestTimeHour: Int? = nil, bestTimeMinute: Int? = nil, moonPhase: MoonPhase) {
        self.id = id
        self.date = date
        self.hadBite = hadBite
        self.bestTimeHour = bestTimeHour
        self.bestTimeMinute = bestTimeMinute
        self.moonPhaseRaw = moonPhase.rawValue
    }
    
    var moonPhase: MoonPhase {
        MoonPhase(rawValue: moonPhaseRaw) ?? .newMoon
    }
    
    var bestTimeString: String? {
        guard let hour = bestTimeHour, let minute = bestTimeMinute else {
            return nil
        }
        return String(format: "%02d:%02d", hour, minute)
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
