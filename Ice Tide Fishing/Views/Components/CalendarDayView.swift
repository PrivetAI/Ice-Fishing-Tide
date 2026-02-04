import SwiftUI

struct CalendarDayView: View {
    let day: Int
    let date: Date
    let moonPhase: MoonPhase
    let isCurrentMonth: Bool
    let isToday: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("\(day)")
                    .font(.system(size: 14, weight: isToday ? .bold : .regular))
                    .foregroundColor(textColor)
                
                MoonPhaseIcon(phase: moonPhase, size: 16)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(backgroundColor)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isToday ? AppTheme.Colors.secondary : Color.clear, lineWidth: 2)
            )
        }
        .disabled(!isCurrentMonth)
    }
    
    private var textColor: Color {
        if !isCurrentMonth {
            return AppTheme.Colors.textSecondary.opacity(0.3)
        }
        return AppTheme.Colors.textPrimary
    }
    
    private var backgroundColor: Color {
        if !isCurrentMonth {
            return Color.clear
        }
        
        switch moonPhase.fishingQuality {
        case .excellent, .good:
            return AppTheme.Colors.zoneExcellent.opacity(0.2)
        case .medium:
            return AppTheme.Colors.zoneMedium.opacity(0.2)
        case .poor:
            return AppTheme.Colors.zonePoor.opacity(0.2)
        }
    }
}
