import SwiftUI

struct PrimaryButton: View {
    let title: String
    var icon: AnyView? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if let icon = icon {
                    icon
                }
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
            }
            .foregroundColor(AppTheme.Colors.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: AppTheme.Dimensions.buttonHeight)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [AppTheme.Colors.secondary, AppTheme.Colors.primary]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(AppTheme.Dimensions.cornerRadius)
            .shadow(color: AppTheme.Colors.secondary.opacity(0.4), radius: 8, x: 0, y: 4)
        }
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppTheme.Colors.secondary)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(AppTheme.Colors.surface)
                .cornerRadius(AppTheme.Dimensions.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Dimensions.cornerRadius)
                        .stroke(AppTheme.Colors.secondary.opacity(0.5), lineWidth: 1)
                )
        }
    }
}
