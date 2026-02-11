import SwiftUI

struct AlmanacScreen: View {
    @State private var expanded: Int?

    var body: some View {
        ZStack {
            DeepWaveBackground()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    VStack(spacing: 8) {
                        GlyphBook(size: 48, tint: OceanPalette.Ink.gold)
                        Text("Fishing Almanac")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(OceanPalette.Ink.ivory)
                        Text("Understanding tides, moons and fish behavior")
                            .font(.system(size: 13))
                            .foregroundColor(OceanPalette.Ink.frost)
                    }
                    .padding(.top, 16)

                    chapter(0, "Freshwater Tides",
                        "Even in rivers and lakes, the moon exerts a subtle gravitational pull on water. While far weaker than ocean tides, these micro-tides create gentle water movement that fish detect.\n\nRivers are mainly driven by upstream conditions and rainfall, but lunar phases amplify natural fluctuations during full and dark moons.\n\nLakes with tributaries experience a blend of inflow patterns and lunar influence, creating rhythmic water level changes that fish instinctively follow.")

                    chapter(1, "Why Rising Water Triggers Feeding",
                        "When water levels climb, several biological triggers activate:\n\nFood particles are stirred from the substrate - insects, crustaceans, and organic matter become suspended and accessible.\n\nDissolved oxygen increases as water movement brings fresh supply into shallow zones.\n\nFish feel more secure in deeper water and venture out from cover to feed actively.\n\nPrey species become more active, triggering predator response.\n\nThis is why the prime windows on charts correspond to rising water - it is nature's dinner bell.")

                    chapter(2, "Managed Basins and Dam Releases",
                        "Reservoirs follow human-controlled schedules rather than lunar cycles:\n\nPower generation creates predictable release patterns tied to electricity demand peaks in morning and evening hours.\n\nFlood control and water supply management cause seasonal variations.\n\nFish in managed basins adapt to these artificial rhythms. Success often depends on learning the local release schedule.\n\nThis app simulates general patterns. For precise timing, check with your local dam operator or water authority.")

                    chapter(3, "Using the Predictor",
                        "The Fishing Predictor combines two data sources:\n\nAstronomical data - lunar phase, tidal pull strength, and water body type create a baseline score.\n\nYour personal data - every trip you log in the Journal feeds back into the prediction model. Over time, the app learns which conditions work best for your specific fishing spots.\n\nLog at least 10-15 trips for the pattern engine to produce meaningful personal adjustments. The more data you provide, the smarter it gets.")

                    Spacer(minLength: 60)
                }
                .padding(.horizontal, OceanPalette.Gap.edge)
            }
        }
        .navigationTitle("Almanac")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func chapter(_ idx: Int, _ title: String, _ content: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    expanded = expanded == idx ? nil : idx
                }
            }) {
                HStack {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(OceanPalette.Ink.ivory)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    GlyphChevron(size: 18, tint: OceanPalette.Ink.gold)
                        .rotationEffect(.degrees(expanded == idx ? 90 : 0))
                }
                .padding(14)
                .background(OceanPalette.Ink.raised)
            }

            if expanded == idx {
                Text(content)
                    .font(.system(size: 13))
                    .foregroundColor(OceanPalette.Ink.frost)
                    .lineSpacing(5)
                    .padding(14)
                    .background(OceanPalette.Ink.panel)
            }
        }
        .cornerRadius(OceanPalette.Curve.card)
        .clipped()
    }
}
