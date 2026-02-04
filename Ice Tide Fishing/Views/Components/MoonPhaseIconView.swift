import SwiftUI

struct MoonPhaseIconView: View {
    let phase: MoonPhase
    var size: CGFloat = 32
    var showLabel: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            MoonPhaseIcon(phase: phase, size: size)
            
            if showLabel {
                Text(phase.displayName)
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
        }
    }
}
