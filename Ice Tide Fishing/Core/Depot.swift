import Foundation

final class Depot {
    static let vault = Depot()
    private let bodyKey = "chosenBody_v2"
    private let tripsKey = "tripRecords_v2"
    private let spotsKey = "savedSpots_v2"
    private let patternKey = "patternData_v2"

    private init() {}

    // MARK: - Water Body

    var chosenBody: WaterBodyKind {
        get {
            if let raw = UserDefaults.standard.string(forKey: bodyKey),
               let k = WaterBodyKind(rawValue: raw) { return k }
            return .flowingStream
        }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: bodyKey) }
    }

    var hasChosen: Bool {
        UserDefaults.standard.string(forKey: bodyKey) != nil
    }

    // MARK: - Trip Records

    func allTrips() -> [TripRecord] {
        guard let data = UserDefaults.standard.data(forKey: tripsKey),
              let list = try? JSONDecoder().decode([TripRecord].self, from: data) else { return [] }
        return list.sorted { $0.date > $1.date }
    }

    func storeTrip(_ trip: TripRecord) {
        var list = allTrips()
        list.append(trip)
        persist(trips: list)
    }

    func removeTrip(id: UUID) {
        var list = allTrips()
        list.removeAll { $0.id == id }
        persist(trips: list)
    }

    private func persist(trips: [TripRecord]) {
        if let data = try? JSONEncoder().encode(trips) {
            UserDefaults.standard.set(data, forKey: tripsKey)
        }
    }

    // MARK: - Saved Spots

    func allSpots() -> [SavedSpot] {
        guard let data = UserDefaults.standard.data(forKey: spotsKey),
              let list = try? JSONDecoder().decode([SavedSpot].self, from: data) else { return [] }
        return list.sorted { $0.addedDate > $1.addedDate }
    }

    func storeSpot(_ spot: SavedSpot) {
        var list = allSpots()
        list.append(spot)
        persistSpots(list)
    }

    func removeSpot(id: UUID) {
        var list = allSpots()
        list.removeAll { $0.id == id }
        persistSpots(list)
    }

    func updateSpot(_ spot: SavedSpot) {
        var list = allSpots()
        if let idx = list.firstIndex(where: { $0.id == spot.id }) {
            list[idx] = spot
            persistSpots(list)
        }
    }

    private func persistSpots(_ spots: [SavedSpot]) {
        if let data = try? JSONEncoder().encode(spots) {
            UserDefaults.standard.set(data, forKey: spotsKey)
        }
    }

    // MARK: - Pattern Learning

    func recordPattern(lunar: LunarStage, body: WaterBodyKind, gotBite: Bool) {
        var patterns = loadPatterns()
        let key = "\(lunar.rawValue)_\(body.rawValue)"
        var entry = patterns[key] ?? PatternEntry(bites: 0, total: 0)
        entry.total += 1
        if gotBite { entry.bites += 1 }
        patterns[key] = entry
        savePatterns(patterns)
    }

    func patternScore(lunar: LunarStage, body: WaterBodyKind) -> Double? {
        let patterns = loadPatterns()
        let key = "\(lunar.rawValue)_\(body.rawValue)"
        guard let entry = patterns[key], entry.total >= 3 else { return nil }
        return Double(entry.bites) / Double(entry.total)
    }

    private func loadPatterns() -> [String: PatternEntry] {
        guard let data = UserDefaults.standard.data(forKey: patternKey),
              let dict = try? JSONDecoder().decode([String: PatternEntry].self, from: data) else { return [:] }
        return dict
    }

    private func savePatterns(_ patterns: [String: PatternEntry]) {
        if let data = try? JSONEncoder().encode(patterns) {
            UserDefaults.standard.set(data, forKey: patternKey)
        }
    }

    func wipeAll() {
        UserDefaults.standard.removeObject(forKey: bodyKey)
        UserDefaults.standard.removeObject(forKey: tripsKey)
        UserDefaults.standard.removeObject(forKey: spotsKey)
        UserDefaults.standard.removeObject(forKey: patternKey)
    }
}

private struct PatternEntry: Codable {
    var bites: Int
    var total: Int
}
