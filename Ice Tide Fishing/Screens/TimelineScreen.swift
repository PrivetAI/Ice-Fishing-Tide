import SwiftUI

struct TimelineScreen: View {
    @Binding var waterBody: WaterBodyKind
    @Binding var chosenDate: Date

    private let cal = Calendar.current

    var body: some View {
        ZStack {
            DeepWaveBackground()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    headerBanner
                    scoreRing
                    sectionNav
                    timelineCards
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, OceanPalette.Gap.edge)
                .padding(.top, 12)
            }
        }
        .navigationTitle("Ice Tide Fishing")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Header

    private var headerBanner: some View {
        VStack(spacing: 6) {
            Text(waterBody.label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(OceanPalette.Ink.gold)

            Text(todayString)
                .font(.system(size: 12))
                .foregroundColor(OceanPalette.Ink.frost)
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(
            Capsule()
                .fill(OceanPalette.Ink.raised.opacity(0.7))
        )
    }

    // MARK: - Score Ring

    private var scoreRing: some View {
        let score = TideEngine.engine.fishingScore(for: Date(), body: waterBody)
        let lunar = LunarCycle.engine.stage(for: Date())

        return VStack(spacing: 8) {
            ZStack {
                ScoreArc(progress: 1.0)
                    .stroke(OceanPalette.Ink.slate.opacity(0.3), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 100, height: 100)

                ScoreArc(progress: Double(score) / 100.0)
                    .stroke(
                        LinearGradient(colors: [OceanPalette.Ink.gold, OceanPalette.Ink.primeGreen],
                                       startPoint: .leading, endPoint: .trailing),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 100, height: 100)

                VStack(spacing: 2) {
                    Text("\(score)")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(OceanPalette.Ink.gold)
                    Text("Today")
                        .font(.system(size: 10))
                        .foregroundColor(OceanPalette.Ink.frost)
                }
            }

            HStack(spacing: 8) {
                LunarDisc(stage: lunar, diameter: 22)
                Text(lunar.label)
                    .font(.system(size: 13))
                    .foregroundColor(OceanPalette.Ink.frost)
            }
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .deepPanel()
    }

    // MARK: - Section Navigation

    private var sectionNav: some View {
        VStack(spacing: 10) {
            navRow(glyph: AnyView(GlyphTide(size: 22)), label: "Day Insight", destination: AnyView(
                DayInsightScreen(date: chosenDate, waterBody: waterBody)
            ))
            navRow(glyph: AnyView(GlyphJournal(size: 22)), label: "Trip Journal", destination: AnyView(
                JournalScreen(waterBody: waterBody)
            ))
            navRow(glyph: AnyView(GlyphPin(size: 22)), label: "Saved Spots", destination: AnyView(
                SpotlightScreen(waterBody: waterBody)
            ))
            navRow(glyph: AnyView(GlyphFish(size: 22)), label: "Fishing Predictor", destination: AnyView(
                PredictorScreen(waterBody: waterBody)
            ))
            navRow(glyph: AnyView(GlyphBook(size: 22)), label: "Almanac", destination: AnyView(
                AlmanacScreen()
            ))
            navRow(glyph: AnyView(GlyphCog(size: 22)), label: "Configuration", destination: AnyView(
                ConfigScreen(waterBody: $waterBody)
            ))
        }
    }

    private func navRow(glyph: AnyView, label: String, destination: AnyView) -> some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 14) {
                glyph
                Text(label)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(OceanPalette.Ink.ivory)
                Spacer()
                GlyphChevron(size: 18, tint: OceanPalette.Ink.gold)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                HexCardShape()
                    .fill(OceanPalette.Ink.panel)
            )
        }
    }

    // MARK: - Timeline Cards (next 7 days)

    private var timelineCards: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("7-Day Tide Outlook")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(OceanPalette.Ink.gold)

            ForEach(0..<7, id: \.self) { offset in
                let date = cal.date(byAdding: .day, value: offset, to: startOfToday) ?? Date()
                let forecast = TideEngine.engine.forecast(for: date, body: waterBody)
                let score = TideEngine.engine.fishingScore(for: date, body: waterBody)

                NavigationLink(destination: DayInsightScreen(date: date, waterBody: waterBody)) {
                    timelineRow(date: date, forecast: forecast, score: score, isToday: offset == 0)
                }
            }
        }
    }

    private func timelineRow(date: Date, forecast: DayForecast, score: Int, isToday: Bool) -> some View {
        HStack(spacing: 14) {
            // Date column
            VStack(spacing: 2) {
                Text(dayName(date))
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(isToday ? OceanPalette.Ink.gold : OceanPalette.Ink.frost)
                Text(dayNum(date))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(OceanPalette.Ink.ivory)
            }
            .frame(width: 42)

            // Moon
            LunarDisc(stage: forecast.lunar, diameter: 28)

            // Info
            VStack(alignment: .leading, spacing: 3) {
                Text(forecast.lunar.label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(OceanPalette.Ink.ivory)

                Text(forecast.windowSummary)
                    .font(.system(size: 11))
                    .foregroundColor(OceanPalette.Ink.frost)
                    .lineLimit(1)
            }

            Spacer()

            // Score badge
            Text("\(score)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(OceanPalette.Ink.abyss)
                .frame(width: 36, height: 36)
                .background(
                    DiamondShape()
                        .fill(scoreColor(score))
                )
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: OceanPalette.Curve.card)
                .fill(isToday ? OceanPalette.Ink.raised : OceanPalette.Ink.panel)
                .overlay(
                    RoundedRectangle(cornerRadius: OceanPalette.Curve.card)
                        .stroke(isToday ? OceanPalette.Ink.gold.opacity(0.5) : Color.clear, lineWidth: 1)
                )
        )
    }

    // MARK: - Helpers

    private var startOfToday: Date {
        cal.startOfDay(for: Date())
    }

    private var todayString: String {
        let f = DateFormatter()
        f.dateStyle = .long
        return f.string(from: Date())
    }

    private func dayName(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "EEE"
        return f.string(from: d)
    }

    private func dayNum(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f.string(from: d)
    }

    private func scoreColor(_ s: Int) -> Color {
        if s >= 70 { return OceanPalette.Ink.primeGreen }
        if s >= 45 { return OceanPalette.Ink.cautionOrange }
        return OceanPalette.Ink.mutedSteel
    }
}
