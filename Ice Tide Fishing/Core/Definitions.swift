import Foundation

// MARK: - Water Body Classification

enum WaterBodyKind: String, Codable, CaseIterable, Identifiable {
    case flowingStream = "flowingStream"
    case managedBasin = "managedBasin"
    case fedLake = "fedLake"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .flowingStream: return "Flowing Stream"
        case .managedBasin: return "Managed Basin"
        case .fedLake: return "Fed Lake"
        }
    }

    var detail: String {
        switch self {
        case .flowingStream: return "Current-driven flow with mild lunar pull"
        case .managedBasin: return "Controlled releases with scheduled patterns"
        case .fedLake: return "Blended lunar and tributary influence"
        }
    }

    var lunarWeight: Double {
        switch self {
        case .flowingStream: return 0.3
        case .managedBasin: return 0.2
        case .fedLake: return 0.6
        }
    }
}

// MARK: - Lunar Phase

enum LunarStage: Int, CaseIterable, Identifiable, Codable {
    case dark = 0
    case earlyWax = 1
    case halfWax = 2
    case brightWax = 3
    case full = 4
    case brightWane = 5
    case halfWane = 6
    case earlyWane = 7

    var id: Int { rawValue }

    var label: String {
        switch self {
        case .dark: return "Dark Moon"
        case .earlyWax: return "Early Waxing"
        case .halfWax: return "Half Waxing"
        case .brightWax: return "Bright Waxing"
        case .full: return "Full Moon"
        case .brightWane: return "Bright Waning"
        case .halfWane: return "Half Waning"
        case .earlyWane: return "Early Waning"
        }
    }

    var biteRating: BiteRating {
        switch self {
        case .dark, .full: return .prime
        case .earlyWax, .earlyWane: return .favorable
        case .halfWax, .halfWane: return .moderate
        case .brightWax, .brightWane: return .sluggish
        }
    }

    var pullStrength: Double {
        switch self {
        case .dark, .full: return 1.0
        case .earlyWax, .earlyWane: return 0.7
        case .halfWax, .halfWane: return 0.5
        case .brightWax, .brightWane: return 0.3
        }
    }
}

enum BiteRating: String {
    case prime = "prime"
    case favorable = "favorable"
    case moderate = "moderate"
    case sluggish = "sluggish"
}

// MARK: - Tide Reading

struct TideReading: Identifiable {
    let id = UUID()
    let hour: Int
    let minute: Int
    let amplitude: Double // 0.0 to 1.0
    let climbing: Bool
    let prospect: FeedingProspect

    var clock: String {
        String(format: "%02d:%02d", hour, minute)
    }

    var percent: Int {
        Int(amplitude * 100)
    }
}

enum FeedingProspect: String {
    case hotBite = "hotBite"
    case steadyBite = "steadyBite"
    case coldBite = "coldBite"

    var explanation: String {
        switch self {
        case .hotBite: return "Water climbing - active feeding window"
        case .steadyBite: return "Peak or gradual descent - fair activity"
        case .coldBite: return "Rapid descent - fish holding deep"
        }
    }
}

struct DayForecast: Identifiable {
    let id = UUID()
    let date: Date
    let readings: [TideReading]
    let lunar: LunarStage
    let primeWindows: [ClockWindow]

    var windowSummary: String {
        if primeWindows.isEmpty {
            return "No prime windows forecast today"
        }
        let parts = primeWindows.map { "\($0.open)-\($0.close)" }
        return "Prime windows: " + parts.joined(separator: ", ")
    }
}

struct ClockWindow {
    let open: String
    let close: String
}

// MARK: - Trip Record

struct TripRecord: Identifiable, Codable {
    let id: UUID
    let date: Date
    let gotBite: Bool
    let peakHour: Int?
    let peakMinute: Int?
    let lunarRaw: Int
    let waterBodyRaw: String
    let locationName: String?
    let notes: String?

    init(id: UUID = UUID(), date: Date, gotBite: Bool, peakHour: Int? = nil, peakMinute: Int? = nil, lunar: LunarStage, waterBody: WaterBodyKind, locationName: String? = nil, notes: String? = nil) {
        self.id = id
        self.date = date
        self.gotBite = gotBite
        self.peakHour = peakHour
        self.peakMinute = peakMinute
        self.lunarRaw = lunar.rawValue
        self.waterBodyRaw = waterBody.rawValue
        self.locationName = locationName
        self.notes = notes
    }

    var lunar: LunarStage {
        LunarStage(rawValue: lunarRaw) ?? .dark
    }

    var waterBody: WaterBodyKind {
        WaterBodyKind(rawValue: waterBodyRaw) ?? .flowingStream
    }

    var peakClock: String? {
        guard let h = peakHour, let m = peakMinute else { return nil }
        return String(format: "%02d:%02d", h, m)
    }

    var dateLabel: String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }
}

// MARK: - Saved Spot

struct SavedSpot: Identifiable, Codable {
    let id: UUID
    var name: String
    var waterBody: String
    var memo: String
    var addedDate: Date

    init(id: UUID = UUID(), name: String, waterBody: WaterBodyKind, memo: String = "", addedDate: Date = Date()) {
        self.id = id
        self.name = name
        self.waterBody = waterBody.rawValue
        self.memo = memo
        self.addedDate = addedDate
    }

    var waterBodyKind: WaterBodyKind {
        WaterBodyKind(rawValue: waterBody) ?? .flowingStream
    }
}
