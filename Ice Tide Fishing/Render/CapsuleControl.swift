import SwiftUI

// MARK: - Pill Button (Primary)

struct PillAction: View {
    let label: String
    var glyph: AnyView? = nil
    let tap: () -> Void

    var body: some View {
        Button(action: tap) {
            HStack(spacing: 10) {
                if let g = glyph { g }
                Text(label)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(OceanPalette.Ink.abyss)
            .padding(.horizontal, 28)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [OceanPalette.Ink.gold, OceanPalette.Ink.amber],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .shadow(color: OceanPalette.Ink.amber.opacity(0.35), radius: 10, x: 0, y: 5)
        }
    }
}

// MARK: - Pill Button (Ghost/Outline)

struct GhostPill: View {
    let label: String
    let tap: () -> Void

    var body: some View {
        Button(action: tap) {
            Text(label)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(OceanPalette.Ink.gold)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    Capsule()
                        .stroke(OceanPalette.Ink.gold.opacity(0.5), lineWidth: 1.5)
                )
        }
    }
}

// MARK: - Toggle Pill Pair

struct TogglePills: View {
    let optionA: String
    let optionB: String
    @Binding var isA: Bool

    var body: some View {
        HStack(spacing: 0) {
            pillSegment(optionA, active: isA) { isA = true }
            pillSegment(optionB, active: !isA) { isA = false }
        }
        .background(Capsule().fill(OceanPalette.Ink.raised))
    }

    private func pillSegment(_ text: String, active: Bool, tap: @escaping () -> Void) -> some View {
        Button(action: tap) {
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(active ? OceanPalette.Ink.abyss : OceanPalette.Ink.frost)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    active ? Capsule().fill(OceanPalette.Ink.gold).eraseToAnyView() : Capsule().fill(Color.clear).eraseToAnyView()
                )
        }
    }
}

// MARK: - Helpers

private extension View {
    func eraseToAnyView() -> AnyView { AnyView(self) }
}
