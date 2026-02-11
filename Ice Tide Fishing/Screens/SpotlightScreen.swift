import SwiftUI

struct SpotlightScreen: View {
    let waterBody: WaterBodyKind
    @State private var spots: [SavedSpot] = []
    @State private var showAdd = false
    @State private var newName = ""
    @State private var newBody: WaterBodyKind = .flowingStream
    @State private var newMemo = ""

    var body: some View {
        ZStack {
            DeepWaveBackground()

            VStack(spacing: 0) {
                if spots.isEmpty {
                    emptyState
                } else {
                    spotList
                }
            }
        }
        .navigationTitle("Saved Spots")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showAdd = true }) {
                    GlyphPlus(size: 22, tint: OceanPalette.Ink.gold)
                }
            }
        }
        .onAppear { spots = Depot.vault.allSpots(); newBody = waterBody }
        .sheet(isPresented: $showAdd) {
            addSheet
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            GlyphPin(size: 56, tint: OceanPalette.Ink.frost.opacity(0.4))
            Text("No spots saved yet")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(OceanPalette.Ink.frost)
            Text("Pin your favorite fishing locations")
                .font(.system(size: 13))
                .foregroundColor(OceanPalette.Ink.frost.opacity(0.6))
            Spacer()
        }
    }

    private var spotList: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(spots) { spot in
                    spotRow(spot)
                }
            }
            .padding(OceanPalette.Gap.edge)
        }
    }

    private func spotRow(_ spot: SavedSpot) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                GlyphPin(size: 20, tint: OceanPalette.Ink.gold)
                Text(spot.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(OceanPalette.Ink.ivory)
                Spacer()
                Button(action: { Depot.vault.removeSpot(id: spot.id); spots = Depot.vault.allSpots() }) {
                    GlyphTrash(size: 16)
                }
            }

            Text(spot.waterBodyKind.label)
                .font(.system(size: 12))
                .foregroundColor(OceanPalette.Ink.gold)

            if !spot.memo.isEmpty {
                Text(spot.memo)
                    .font(.system(size: 12))
                    .foregroundColor(OceanPalette.Ink.frost.opacity(0.7))
            }
        }
        .padding(14)
        .deepPanel()
    }

    private var addSheet: some View {
        NavigationView {
            ZStack {
                OceanPalette.Ink.seaGradient.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Spot Name")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(OceanPalette.Ink.ivory)
                            TextField("e.g. Cedar Creek Bend", text: $newName)
                                .foregroundColor(OceanPalette.Ink.ivory)
                                .padding(12)
                                .background(OceanPalette.Ink.raised)
                                .cornerRadius(OceanPalette.Curve.small)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Water Body Type")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(OceanPalette.Ink.ivory)
                            ForEach(WaterBodyKind.allCases) { wb in
                                Button(action: { newBody = wb }) {
                                    HStack {
                                        Text(wb.label)
                                            .font(.system(size: 14))
                                            .foregroundColor(newBody == wb ? OceanPalette.Ink.gold : OceanPalette.Ink.frost)
                                        Spacer()
                                        if newBody == wb {
                                            GlyphCheck(size: 18, tint: OceanPalette.Ink.gold)
                                        }
                                    }
                                    .padding(12)
                                    .background(OceanPalette.Ink.raised)
                                    .cornerRadius(OceanPalette.Curve.small)
                                }
                            }
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Memo")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(OceanPalette.Ink.ivory)
                            TextField("Notes about this spot...", text: $newMemo)
                                .foregroundColor(OceanPalette.Ink.ivory)
                                .padding(12)
                                .background(OceanPalette.Ink.raised)
                                .cornerRadius(OceanPalette.Curve.small)
                        }

                        PillAction(label: "Save Spot") {
                            guard !newName.isEmpty else { return }
                            let spot = SavedSpot(name: newName, waterBody: newBody, memo: newMemo)
                            Depot.vault.storeSpot(spot)
                            spots = Depot.vault.allSpots()
                            newName = ""; newMemo = ""
                            showAdd = false
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(OceanPalette.Gap.edge)
                }
            }
            .navigationTitle("New Spot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { showAdd = false }
                        .foregroundColor(OceanPalette.Ink.gold)
                }
            }
        }
    }
}
