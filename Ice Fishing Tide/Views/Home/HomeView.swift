import SwiftUI

struct HomeView: View {
    @Binding var selectedWaterBody: WaterBodyType
    @Binding var selectedDate: Date
    @Binding var showChart: Bool
    @State private var hasSelection: Bool
    
    init(selectedWaterBody: Binding<WaterBodyType>, selectedDate: Binding<Date>, showChart: Binding<Bool>) {
        self._selectedWaterBody = selectedWaterBody
        self._selectedDate = selectedDate
        self._showChart = showChart
        self._hasSelection = State(initialValue: StorageService.shared.hasSelectedWaterBody)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Ice Fishing Tide")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    
                    Text("Water level predictions for fishing")
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                .padding(.top, 20)
                
                // Water body selection
                VStack(alignment: .leading, spacing: 16) {
                    Text("Select Water Body")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    
                    ForEach(WaterBodyType.allCases) { waterBody in
                        WaterBodyCard(
                            waterBody: waterBody,
                            isSelected: selectedWaterBody == waterBody
                        ) {
                            selectedWaterBody = waterBody
                            hasSelection = true
                            StorageService.shared.selectedWaterBody = waterBody
                        }
                    }
                }
                .padding(.horizontal)
                
                // Date selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Date")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    
                    HStack {
                        Text(formattedDate)
                            .font(.system(size: 18))
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        
                        Spacer()
                        
                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                            .labelsHidden()
                            .accentColor(AppTheme.Colors.secondary)
                            .colorScheme(.dark)
                    }
                    .padding()
                    .background(AppTheme.Colors.surface)
                    .cornerRadius(AppTheme.Dimensions.cornerRadius)
                }
                .padding(.horizontal)
                
                // Show chart button
                PrimaryButton(
                    title: "Show Water Chart",
                    icon: AnyView(WaveIcon(size: 24, color: AppTheme.Colors.textPrimary))
                ) {
                    showChart = true
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Current moon phase info
                currentMoonInfo
                    .padding(.horizontal)
                
                Spacer(minLength: 100)
            }
        }
        .background(AppTheme.Colors.backgroundGradient.ignoresSafeArea())
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: selectedDate)
    }
    
    private var currentMoonInfo: some View {
        let moonPhase = MoonCalculator.shared.getMoonPhase(for: selectedDate)
        
        return HStack(spacing: 16) {
            MoonPhaseIcon(phase: moonPhase, size: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(moonPhase.displayName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.Colors.textPrimary)
                
                Text(qualityText(for: moonPhase))
                    .font(.system(size: 14))
                    .foregroundColor(qualityColor(for: moonPhase))
            }
            
            Spacer()
        }
        .padding()
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.Dimensions.cardCornerRadius)
    }
    
    private func qualityText(for phase: MoonPhase) -> String {
        switch phase.fishingQuality {
        case .excellent:
            return "Excellent fishing conditions"
        case .good:
            return "Good fishing conditions"
        case .medium:
            return "Medium fishing conditions"
        case .poor:
            return "Poor fishing conditions"
        }
    }
    
    private func qualityColor(for phase: MoonPhase) -> Color {
        switch phase.fishingQuality {
        case .excellent, .good:
            return AppTheme.Colors.zoneExcellent
        case .medium:
            return AppTheme.Colors.zoneMedium
        case .poor:
            return AppTheme.Colors.zonePoor
        }
    }
}
