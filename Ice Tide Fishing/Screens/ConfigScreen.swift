import SwiftUI

struct ConfigScreen: View {
    @Binding var waterBody: WaterBodyKind

    var body: some View {
        ZStack {
            DeepWaveBackground()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    // Water body selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Water Body Type")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(OceanPalette.Ink.gold)

                        ForEach(WaterBodyKind.allCases) { wb in
                            bodyOption(wb)
                        }
                    }

                    // App info
                    VStack(alignment: .leading, spacing: 10) {
                        Text("About")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(OceanPalette.Ink.gold)

                        infoLine("Version", "1.0")
                        infoLine("Timezone", TimeZone.current.identifier)

                        Text("Tide forecasts are simulated from lunar data and water body characteristics. Cross-reference with local observations for best results.")
                            .font(.system(size: 12))
                            .foregroundColor(OceanPalette.Ink.frost.opacity(0.7))
                            .padding(.top, 6)
                    }
                    .padding(14)
                    .deepPanel()

                    Spacer(minLength: 60)
                }
                .padding(.horizontal, OceanPalette.Gap.edge)
                .padding(.top, 16)
            }
        }
        .navigationTitle("Configuration")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func bodyOption(_ wb: WaterBodyKind) -> some View {
        Button(action: {
            waterBody = wb
            Depot.vault.chosenBody = wb
        }) {
            HStack(spacing: 14) {
                bodyGlyph(wb)
                    .frame(width: 36, height: 36)

                VStack(alignment: .leading, spacing: 2) {
                    Text(wb.label)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(OceanPalette.Ink.ivory)
                    Text(wb.detail)
                        .font(.system(size: 11))
                        .foregroundColor(OceanPalette.Ink.frost)
                }

                Spacer()

                if waterBody == wb {
                    GlyphCheck(size: 22, tint: OceanPalette.Ink.gold)
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: OceanPalette.Curve.card)
                    .fill(waterBody == wb ? OceanPalette.Ink.raised : OceanPalette.Ink.panel)
                    .overlay(
                        RoundedRectangle(cornerRadius: OceanPalette.Curve.card)
                            .stroke(waterBody == wb ? OceanPalette.Ink.gold.opacity(0.4) : Color.clear, lineWidth: 1)
                    )
            )
        }
    }

    @ViewBuilder
    private func bodyGlyph(_ wb: WaterBodyKind) -> some View {
        switch wb {
        case .flowingStream:
            GlyphTide(size: 36, tint: OceanPalette.Ink.gold)
        case .managedBasin:
            GlyphCompass(size: 36, tint: OceanPalette.Ink.gold)
        case .fedLake:
            GlyphFish(size: 36, tint: OceanPalette.Ink.gold)
        }
    }

    private func infoLine(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(OceanPalette.Ink.frost)
            Spacer()
            Text(value)
                .font(.system(size: 13))
                .foregroundColor(OceanPalette.Ink.ivory)
        }
    }
}
