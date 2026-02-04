import SwiftUI

struct LogView: View {
    @State private var logs: [FishingLog] = []
    @State private var showAddLog = false
    let waterBody: WaterBodyType
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Fishing Log")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppTheme.Colors.textPrimary)
                
                Spacer()
                
                Button(action: { showAddLog = true }) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.Colors.secondary)
                            .frame(width: 40, height: 40)
                        PlusIcon(size: 20, color: AppTheme.Colors.backgroundDark)
                    }
                }
            }
            .padding()
            
            if logs.isEmpty {
                emptyState
            } else {
                logsList
            }
        }
        .background(AppTheme.Colors.backgroundGradient.ignoresSafeArea())
        .onAppear {
            loadLogs()
        }
        .sheet(isPresented: $showAddLog) {
            AddLogView(waterBody: waterBody) {
                loadLogs()
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            
            WaveIcon(size: 60, color: AppTheme.Colors.textSecondary.opacity(0.5))
            
            Text("No fishing records yet")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(AppTheme.Colors.textSecondary)
            
            Text("Tap + to add your first fishing trip")
                .font(.system(size: 14))
                .foregroundColor(AppTheme.Colors.textSecondary.opacity(0.7))
            
            Spacer()
        }
    }
    
    private var logsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(logs) { log in
                    LogRowView(log: log, waterBody: waterBody) {
                        deleteLog(log)
                    }
                }
            }
            .padding()
        }
    }
    
    private func loadLogs() {
        logs = StorageService.shared.loadLogs()
    }
    
    private func deleteLog(_ log: FishingLog) {
        StorageService.shared.deleteLog(id: log.id)
        loadLogs()
    }
}

struct LogRowView: View {
    let log: FishingLog
    let waterBody: WaterBodyType
    let onDelete: () -> Void
    @State private var showChart = false
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(log.dateString)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    
                    HStack(spacing: 8) {
                        MoonPhaseIcon(phase: log.moonPhase, size: 20)
                        Text(log.moonPhase.displayName)
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 6) {
                        if log.hadBite {
                            CheckmarkIcon(size: 16, color: AppTheme.Colors.zoneExcellent)
                            Text("Bite")
                                .foregroundColor(AppTheme.Colors.zoneExcellent)
                        } else {
                            Text("No Bite")
                                .foregroundColor(AppTheme.Colors.zonePoor)
                        }
                    }
                    .font(.system(size: 14, weight: .medium))
                    
                    if let time = log.bestTimeString {
                        Text("Best: \(time)")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                }
            }
            
            HStack {
                Button(action: { showChart = true }) {
                    Text("View Chart")
                        .font(.system(size: 13))
                        .foregroundColor(AppTheme.Colors.secondary)
                }
                
                Spacer()
                
                Button(action: onDelete) {
                    TrashIcon(size: 18, color: AppTheme.Colors.zoneMedium)
                }
            }
        }
        .padding()
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.Dimensions.cardCornerRadius)
        .sheet(isPresented: $showChart) {
            NavigationView {
                ChartView(date: log.date, waterBody: waterBody)
                    .navigationBarItems(trailing: Button("Close") {
                        showChart = false
                    })
            }
        }
    }
}

struct AddLogView: View {
    let waterBody: WaterBodyType
    let onSave: () -> Void
    
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDate = Date()
    @State private var hadBite = true
    @State private var bestHour = 6
    @State private var bestMinute = 0
    @State private var noBestTime = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Date
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        
                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                            .labelsHidden()
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .accentColor(AppTheme.Colors.secondary)
                            .colorScheme(.dark)
                            .background(AppTheme.Colors.surface)
                            .cornerRadius(AppTheme.Dimensions.cornerRadius)
                    }
                    
                    // Bite toggle
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Did you catch fish?")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        
                        HStack(spacing: 16) {
                            biteButton(title: "Yes", isSelected: hadBite) {
                                hadBite = true
                            }
                            biteButton(title: "No", isSelected: !hadBite) {
                                hadBite = false
                            }
                        }
                    }
                    
                    // Best time
                    if hadBite {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Best Fishing Time")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppTheme.Colors.textPrimary)
                                
                                Spacer()
                                
                                Toggle("No specific time", isOn: $noBestTime)
                                    .labelsHidden()
                                    .toggleStyle(SwitchToggleStyle(tint: AppTheme.Colors.secondary))
                            }
                            
                            if !noBestTime {
                                HStack {
                                    Picker("Hour", selection: $bestHour) {
                                        ForEach(0..<24) { hour in
                                            Text(String(format: "%02d", hour)).tag(hour)
                                        }
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                    .frame(width: 60)
                                    .clipped()
                                    
                                    Text(":")
                                        .foregroundColor(AppTheme.Colors.textPrimary)
                                    
                                    Picker("Minute", selection: $bestMinute) {
                                        ForEach([0, 15, 30, 45], id: \.self) { minute in
                                            Text(String(format: "%02d", minute)).tag(minute)
                                        }
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                    .frame(width: 60)
                                    .clipped()
                                }
                                .padding()
                                .background(AppTheme.Colors.surface)
                                .cornerRadius(AppTheme.Dimensions.cornerRadius)
                            }
                        }
                    }
                    
                    // Moon phase preview
                    moonPhasePreview
                    
                    // Save button
                    PrimaryButton(title: "Save Record") {
                        saveLog()
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding()
            }
            .background(AppTheme.Colors.backgroundGradient.ignoresSafeArea())
            .navigationTitle("Add Record")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppTheme.Colors.secondary)
                }
            }
        }
    }
    
    private func biteButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isSelected ? AppTheme.Colors.backgroundDark : AppTheme.Colors.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(isSelected ? AppTheme.Colors.secondary : AppTheme.Colors.surface)
                .cornerRadius(AppTheme.Dimensions.cornerRadius)
        }
    }
    
    private var moonPhasePreview: some View {
        let moonPhase = MoonCalculator.shared.getMoonPhase(for: selectedDate)
        
        return HStack(spacing: 12) {
            MoonPhaseIcon(phase: moonPhase, size: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Moon Phase")
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.Colors.textSecondary)
                Text(moonPhase.displayName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.Colors.textPrimary)
            }
            
            Spacer()
        }
        .padding()
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.Dimensions.cornerRadius)
    }
    
    private func saveLog() {
        let moonPhase = MoonCalculator.shared.getMoonPhase(for: selectedDate)
        let log = FishingLog(
            date: selectedDate,
            hadBite: hadBite,
            bestTimeHour: (hadBite && !noBestTime) ? bestHour : nil,
            bestTimeMinute: (hadBite && !noBestTime) ? bestMinute : nil,
            moonPhase: moonPhase
        )
        
        StorageService.shared.addLog(log)
        onSave()
        presentationMode.wrappedValue.dismiss()
    }
}
