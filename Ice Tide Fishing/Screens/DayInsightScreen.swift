import SwiftUI

struct DayInsightScreen: View {
    let date: Date
    let waterBody: WaterBodyKind
    @State private var forecast: DayForecast?

    var body: some View {
        ZStack {
            DeepWaveBackground()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Date & body header
                    VStack(spacing: 6) {
                        Text(dateLabel)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(OceanPalette.Ink.ivory)
                        Text(waterBody.label)
                            .font(.system(size: 14))
                            .foregroundColor(OceanPalette.Ink.gold)
                    }
                    .padding(.top, 16)

                    if let fc = forecast {
                        TideGraph(forecast: fc)

                        feedingTips
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: OceanPalette.Ink.gold))
                            .frame(height: 200)
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, OceanPalette.Gap.edge)
            }
        }
        .navigationTitle("Day Insight")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { forecast = TideEngine.engine.forecast(for: date, body: waterBody) }
    }

    private var dateLabel: String {
        let f = DateFormatter()
        f.dateStyle = .long
        return f.string(from: date)
    }

    private var feedingTips: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Feeding Guide")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(OceanPalette.Ink.gold)

            tipLine(OceanPalette.Ink.primeGreen, "Rising water stirs food - peak feeding")
            tipLine(OceanPalette.Ink.cautionOrange, "High water or slow drop - moderate action")
            tipLine(OceanPalette.Ink.mutedSteel, "Falling fast - fish go deep, wait it out")
        }
        .padding(16)
        .deepPanel()
    }

    private func tipLine(_ color: Color, _ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            DiamondShape()
                .fill(color)
                .frame(width: 12, height: 12)
                .padding(.top, 3)
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(OceanPalette.Ink.frost)
        }
    }
}
