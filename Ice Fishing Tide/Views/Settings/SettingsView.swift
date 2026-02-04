import SwiftUI

struct SettingsView: View {
    @Binding var selectedWaterBody: WaterBodyType
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                Text("Settings")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .padding(.top, 20)
                
                // Water body selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("Water Body Type")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    
                    ForEach(WaterBodyType.allCases) { waterBody in
                        waterBodyOption(waterBody)
                    }
                }
                .padding(.horizontal)
                
                // App info
                appInfoSection
                    .padding(.horizontal)
                
                Spacer(minLength: 100)
            }
        }
        .background(AppTheme.Colors.backgroundGradient.ignoresSafeArea())
    }
    
    private func waterBodyOption(_ waterBody: WaterBodyType) -> some View {
        Button(action: {
            selectedWaterBody = waterBody
            StorageService.shared.selectedWaterBody = waterBody
        }) {
            HStack(spacing: 16) {
                waterBodyIcon(waterBody)
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(waterBody.displayName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    
                    Text(waterBody.description)
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                
                Spacer()
                
                if selectedWaterBody == waterBody {
                    CheckmarkIcon(size: 24, color: AppTheme.Colors.zoneExcellent)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Dimensions.cornerRadius)
                    .fill(selectedWaterBody == waterBody ? AppTheme.Colors.surface : AppTheme.Colors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.Dimensions.cornerRadius)
                            .stroke(selectedWaterBody == waterBody ? AppTheme.Colors.secondary : Color.clear, lineWidth: 1)
                    )
            )
        }
    }
    
    @ViewBuilder
    private func waterBodyIcon(_ waterBody: WaterBodyType) -> some View {
        switch waterBody {
        case .river:
            RiverIcon(size: 40, color: AppTheme.Colors.secondary)
        case .reservoir:
            ReservoirIcon(size: 40, color: AppTheme.Colors.secondary)
        case .lakeInflow:
            LakeIcon(size: 40, color: AppTheme.Colors.secondary)
        }
    }
    
    private var appInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppTheme.Colors.textPrimary)
            
            VStack(spacing: 8) {
                infoRow(title: "Version", value: "1.0")
                infoRow(title: "Timezone", value: TimeZone.current.identifier)
            }
            .padding()
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.Dimensions.cornerRadius)
            
            Text("Water level predictions are simulated based on moon phases and water body type. For best results, compare predictions with actual observations.")
                .font(.system(size: 12))
                .foregroundColor(AppTheme.Colors.textSecondary)
                .padding(.top, 8)
        }
    }
    
    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(AppTheme.Colors.textSecondary)
            Spacer()
            Text(value)
                .font(.system(size: 14))
                .foregroundColor(AppTheme.Colors.textPrimary)
        }
    }
}
