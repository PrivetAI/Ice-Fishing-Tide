import SwiftUI

struct OceanPalette {
    // MARK: - Deep Ocean Colors (Navy/Midnight + Gold/Amber)
    struct Ink {
        static let abyss = Color(rgb: 0x06091A)
        static let deepNavy = Color(rgb: 0x0B1731)
        static let midnightBlue = Color(rgb: 0x122347)
        static let slate = Color(rgb: 0x1B3260)

        static let amber = Color(rgb: 0xD4A530)
        static let gold = Color(rgb: 0xF0C45A)
        static let paleGold = Color(rgb: 0xF5D88E)

        static let primeGreen = Color(rgb: 0x3DAE7E)
        static let cautionOrange = Color(rgb: 0xE8943A)
        static let mutedSteel = Color(rgb: 0x6B778D)

        static let ivory = Color(rgb: 0xECEFF4)
        static let frost = Color(rgb: 0x9BAEC2)

        static let panel = Color(rgb: 0x0E1E3D)
        static let raised = Color(rgb: 0x162B52)

        static var seaGradient: LinearGradient {
            LinearGradient(
                gradient: Gradient(colors: [abyss, midnightBlue]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    // MARK: - Spacing
    struct Gap {
        static let pill: CGFloat = 28
        static let card: CGFloat = 14
        static let edge: CGFloat = 20
        static let tight: CGFloat = 6
        static let wide: CGFloat = 32
    }

    // MARK: - Radii
    struct Curve {
        static let pill: CGFloat = 24
        static let card: CGFloat = 18
        static let small: CGFloat = 10
    }
}

// MARK: - RGB Color Init
extension Color {
    init(rgb: UInt) {
        self.init(
            .sRGB,
            red: Double((rgb >> 16) & 0xFF) / 255.0,
            green: Double((rgb >> 8) & 0xFF) / 255.0,
            blue: Double(rgb & 0xFF) / 255.0,
            opacity: 1.0
        )
    }
}

// MARK: - Deep Panel Modifier
struct DeepPanelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(OceanPalette.Ink.panel)
            .cornerRadius(OceanPalette.Curve.card)
            .shadow(color: Color.black.opacity(0.45), radius: 12, x: 0, y: 6)
    }
}

extension View {
    func deepPanel() -> some View {
        modifier(DeepPanelStyle())
    }
}
