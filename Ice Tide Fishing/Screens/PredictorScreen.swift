import SwiftUI

struct PredictorScreen: View {
    let waterBody: WaterBodyKind
    private let cal = Calendar.current

    var body: some View {
        ZStack {
            DeepWaveBackground()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 22) {
                    // Header
                    VStack(spacing: 6) {
                        GlyphFish(size: 48, tint: OceanPalette.Ink.gold)
                        Text("Best Fishing Forecast")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(OceanPalette.Ink.ivory)
                        Text("Next 14 days ranked by predicted success")
                            .font(.system(size: 13))
                            .foregroundColor(OceanPalette.Ink.frost)
                    }
                    .padding(.top, 16)

                    // Pattern learning insight
                    patternInsight

                    // Ranked days
                    rankedDays

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, OceanPalette.Gap.edge)
            }
        }
        .navigationTitle("Predictor")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var patternInsight: some View {
        let trips = Depot.vault.allTrips()
        let biteTrips = trips.filter { $0.gotBite }
        let total = trips.count

        return VStack(alignment: .leading, spacing: 8) {
            Text("Your Pattern Data")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(OceanPalette.Ink.gold)

            if total == 0 {
                Text("Log trips in the Journal to build personal predictions. The more data you enter, the smarter forecasts become.")
                    .font(.system(size: 13))
                    .foregroundColor(OceanPalette.Ink.frost)
            } else {
                Text("\(total) trips logged, \(biteTrips.count) with bites (\(total > 0 ? Int(Double(biteTrips.count) / Double(total) * 100) : 0)% success)")
                    .font(.system(size: 13))
                    .foregroundColor(OceanPalette.Ink.frost)

                // Show best lunar phase from personal data
                if let bestPhase = findBestPhase() {
                    HStack(spacing: 8) {
                        LunarDisc(stage: bestPhase, diameter: 22)
                        Text("Your best phase: \(bestPhase.label)")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(OceanPalette.Ink.primeGreen)
                    }
                }
            }
        }
        .padding(14)
        .deepPanel()
    }

    private var rankedDays: some View {
        let today = cal.startOfDay(for: Date())
        var days: [(Date, Int)] = []
        for i in 0..<14 {
            let d = cal.date(byAdding: .day, value: i, to: today) ?? today
            var score = TideEngine.engine.fishingScore(for: d, body: waterBody)
            // Augment with pattern data
            let lunar = LunarCycle.engine.stage(for: d)
            if let ps = Depot.vault.patternScore(lunar: lunar, body: waterBody) {
                score = Int(Double(score) * 0.6 + ps * 100 * 0.4)
            }
            days.append((d, score))
        }
        days.sort { $0.1 > $1.1 }

        return VStack(spacing: 10) {
            ForEach(Array(days.enumerated()), id: \.offset) { idx, pair in
                let (date, score) = pair
                let lunar = LunarCycle.engine.stage(for: date)

                NavigationLink(destination: DayInsightScreen(date: date, waterBody: waterBody)) {
                    HStack(spacing: 12) {
                        // Rank
                        Text("#\(idx + 1)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(idx < 3 ? OceanPalette.Ink.gold : OceanPalette.Ink.frost)
                            .frame(width: 30)

                        LunarDisc(stage: lunar, diameter: 24)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(formatDate(date))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(OceanPalette.Ink.ivory)
                            Text(lunar.label)
                                .font(.system(size: 11))
                                .foregroundColor(OceanPalette.Ink.frost)
                        }

                        Spacer()

                        ZStack {
                            ScoreArc(progress: 1.0)
                                .stroke(OceanPalette.Ink.slate.opacity(0.3), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                                .frame(width: 38, height: 38)
                            ScoreArc(progress: Double(score) / 100.0)
                                .stroke(scoreColor(score), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                                .frame(width: 38, height: 38)
                            Text("\(score)")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(OceanPalette.Ink.ivory)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: OceanPalette.Curve.card)
                            .fill(idx < 3 ? OceanPalette.Ink.raised : OceanPalette.Ink.panel)
                    )
                }
            }
        }
    }

    private func formatDate(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "EEE, MMM d"
        return f.string(from: d)
    }

    private func scoreColor(_ s: Int) -> Color {
        if s >= 70 { return OceanPalette.Ink.primeGreen }
        if s >= 45 { return OceanPalette.Ink.cautionOrange }
        return OceanPalette.Ink.mutedSteel
    }

    private func findBestPhase() -> LunarStage? {
        var best: LunarStage?
        var bestRate: Double = -1
        for phase in LunarStage.allCases {
            if let rate = Depot.vault.patternScore(lunar: phase, body: waterBody), rate > bestRate {
                bestRate = rate
                best = phase
            }
        }
        return best
    }
}
