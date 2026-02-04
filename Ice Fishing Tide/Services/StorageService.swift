import Foundation

class StorageService {
    static let shared = StorageService()
    
    private let waterBodyKey = "selectedWaterBody"
    private let logsKey = "fishingLogs"
    
    private init() {}
    
    // MARK: - Water Body Type
    
    var selectedWaterBody: WaterBodyType {
        get {
            if let rawValue = UserDefaults.standard.string(forKey: waterBodyKey),
               let type = WaterBodyType(rawValue: rawValue) {
                return type
            }
            return .river
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: waterBodyKey)
        }
    }
    
    var hasSelectedWaterBody: Bool {
        return UserDefaults.standard.string(forKey: waterBodyKey) != nil
    }
    
    // MARK: - Fishing Logs
    
    func saveLogs(_ logs: [FishingLog]) {
        if let encoded = try? JSONEncoder().encode(logs) {
            UserDefaults.standard.set(encoded, forKey: logsKey)
        }
    }
    
    func loadLogs() -> [FishingLog] {
        guard let data = UserDefaults.standard.data(forKey: logsKey),
              let logs = try? JSONDecoder().decode([FishingLog].self, from: data) else {
            return []
        }
        return logs.sorted { $0.date > $1.date }
    }
    
    func addLog(_ log: FishingLog) {
        var logs = loadLogs()
        logs.append(log)
        saveLogs(logs)
    }
    
    func deleteLog(id: UUID) {
        var logs = loadLogs()
        logs.removeAll { $0.id == id }
        saveLogs(logs)
    }
    
    func clearAllData() {
        UserDefaults.standard.removeObject(forKey: waterBodyKey)
        UserDefaults.standard.removeObject(forKey: logsKey)
    }
}
