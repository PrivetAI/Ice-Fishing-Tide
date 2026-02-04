import SwiftUI

struct WaterBodyCard: View {
    let waterBody: WaterBodyType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                waterBodyIcon
                    .frame(width: 60, height: 60)
                
                VStack(spacing: 4) {
                    Text(waterBody.displayName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    
                    Text(waterBody.description)
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Dimensions.cardCornerRadius)
                    .fill(isSelected ? AppTheme.Colors.surface : AppTheme.Colors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.Dimensions.cardCornerRadius)
                            .stroke(isSelected ? AppTheme.Colors.secondary : Color.clear, lineWidth: 2)
                    )
            )
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
    }
    
    @ViewBuilder
    private var waterBodyIcon: some View {
        switch waterBody {
        case .river:
            RiverIcon(size: 60, color: AppTheme.Colors.secondary)
        case .reservoir:
            ReservoirIcon(size: 60, color: AppTheme.Colors.secondary)
        case .lakeInflow:
            LakeIcon(size: 60, color: AppTheme.Colors.secondary)
        }
    }
}
