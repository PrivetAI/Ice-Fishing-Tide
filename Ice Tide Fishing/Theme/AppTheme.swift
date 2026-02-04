import SwiftUI

struct AppTheme {
    // MARK: - Colors
    struct Colors {
        // Main gradient colors (water theme)
        static let backgroundDark = Color(hex: "0A1628")
        static let backgroundMid = Color(hex: "1A535C")
        static let backgroundLight = Color(hex: "4ECDC4")
        
        // Functional colors
        static let primary = Color(hex: "1A535C")
        static let secondary = Color(hex: "4ECDC4")
        static let accent = Color(hex: "66D9E8")
        
        // Fishing zones
        static let zoneExcellent = Color(hex: "4ECDC4")
        static let zoneMedium = Color(hex: "FFE66D")
        static let zonePoor = Color(hex: "7F8C8D")
        
        // Text
        static let textPrimary = Color.white
        static let textSecondary = Color(hex: "A8DADC")
        
        // Surface
        static let surface = Color(hex: "1A3A4A")
        static let cardBackground = Color(hex: "0D2438")
        
        // Background gradient
        static var backgroundGradient: LinearGradient {
            LinearGradient(
                gradient: Gradient(colors: [backgroundDark, backgroundMid]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    // MARK: - Dimensions
    struct Dimensions {
        static let cornerRadius: CGFloat = 16
        static let cardCornerRadius: CGFloat = 20
        static let buttonHeight: CGFloat = 56
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let largePadding: CGFloat = 24
        static let iconSize: CGFloat = 24
        static let largeIconSize: CGFloat = 48
    }
    
    // MARK: - Shadows
    struct Shadows {
        static let cardShadowRadius: CGFloat = 10
        static let cardShadowY: CGFloat = 4
        static let buttonShadowRadius: CGFloat = 8
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - View Modifiers
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.Dimensions.cardCornerRadius)
            .shadow(
                color: Color.black.opacity(0.3),
                radius: AppTheme.Shadows.cardShadowRadius,
                x: 0,
                y: AppTheme.Shadows.cardShadowY
            )
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}
