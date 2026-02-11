import SwiftUI

struct JournalScreen: View {
    let waterBody: WaterBodyKind
    @State private var trips: [TripRecord] = []
    @State private var showAdd = false

    var body: some View {
        ZStack {
            DeepWaveBackground()

            VStack(spacing: 0) {
                if trips.isEmpty {
                    emptyJournal
                } else {
                    tripList
                }
            }
        }
        .navigationTitle("Trip Journal")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showAdd = true }) {
                    GlyphPlus(size: 22, tint: OceanPalette.Ink.gold)
                }
            }
        }
        .onAppear { refresh() }
        .sheet(isPresented: $showAdd) {
            NewTripSheet(waterBody: waterBody) { refresh() }
        }
    }

    private var emptyJournal: some View {
        VStack(spacing: 16) {
            Spacer()
            GlyphJournal(size: 56, tint: OceanPalette.Ink.frost.opacity(0.4))
            Text("No trips recorded yet")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(OceanPalette.Ink.frost)
            Text("Tap + to log your first outing")
                .font(.system(size: 13))
                .foregroundColor(OceanPalette.Ink.frost.opacity(0.6))
            Spacer()
        }
    }

    private var tripList: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(trips) { trip in
                    TripRow(trip: trip, waterBody: waterBody) {
                        Depot.vault.removeTrip(id: trip.id)
                        refresh()
                    }
                }
            }
            .padding(OceanPalette.Gap.edge)
        }
    }

    private func refresh() { trips = Depot.vault.allTrips() }
}

// MARK: - Trip Row

private struct TripRow: View {
    let trip: TripRecord
    let waterBody: WaterBodyKind
    let onDelete: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(trip.dateLabel)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(OceanPalette.Ink.ivory)
                    HStack(spacing: 6) {
                        LunarDisc(stage: trip.lunar, diameter: 18)
                        Text(trip.lunar.label)
                            .font(.system(size: 11))
                            .foregroundColor(OceanPalette.Ink.frost)
                    }
                    if let loc = trip.locationName, !loc.isEmpty {
                        HStack(spacing: 4) {
                            GlyphPin(size: 12, tint: OceanPalette.Ink.gold)
                            Text(loc)
                                .font(.system(size: 11))
                                .foregroundColor(OceanPalette.Ink.gold)
                        }
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 3) {
                    if trip.gotBite {
                        HStack(spacing: 4) {
                            GlyphCheck(size: 14)
                            Text("Bite")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(OceanPalette.Ink.primeGreen)
                        }
                    } else {
                        Text("No Bite")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(OceanPalette.Ink.mutedSteel)
                    }

                    if let t = trip.peakClock {
                        Text("Peak: \(t)")
                            .font(.system(size: 11))
                            .foregroundColor(OceanPalette.Ink.frost)
                    }
                }
            }

            if let notes = trip.notes, !notes.isEmpty {
                Text(notes)
                    .font(.system(size: 12))
                    .foregroundColor(OceanPalette.Ink.frost.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            HStack {
                NavigationLink(destination: DayInsightScreen(date: trip.date, waterBody: waterBody)) {
                    Text("View Chart")
                        .font(.system(size: 12))
                        .foregroundColor(OceanPalette.Ink.gold)
                }
                Spacer()
                Button(action: onDelete) {
                    GlyphTrash(size: 18)
                }
            }
        }
        .padding(14)
        .deepPanel()
    }
}

// MARK: - New Trip Sheet

struct NewTripSheet: View {
    let waterBody: WaterBodyKind
    let onSave: () -> Void

    @Environment(\.presentationMode) var dismiss
    @State private var date = Date()
    @State private var gotBite = true
    @State private var peakHour = 6
    @State private var peakMinute = 0
    @State private var noPeak = false
    @State private var locationName = ""
    @State private var notes = ""

    var body: some View {
        NavigationView {
            ZStack {
                OceanPalette.Ink.seaGradient.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 22) {
                        // Date
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Date")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(OceanPalette.Ink.ivory)
                            DatePicker("", selection: $date, displayedComponents: .date)
                                .labelsHidden()
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .accentColor(OceanPalette.Ink.gold)
                                .colorScheme(.dark)
                                .padding(8)
                                .background(OceanPalette.Ink.raised)
                                .cornerRadius(OceanPalette.Curve.small)
                        }

                        // Bite toggle
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Did you get a bite?")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(OceanPalette.Ink.ivory)
                            TogglePills(optionA: "Yes", optionB: "No", isA: $gotBite)
                        }

                        // Peak time
                        if gotBite {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("Peak Time")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(OceanPalette.Ink.ivory)
                                    Spacer()
                                    Toggle("Skip", isOn: $noPeak)
                                        .labelsHidden()
                                        .toggleStyle(SwitchToggleStyle(tint: OceanPalette.Ink.gold))
                                }
                                if !noPeak {
                                    HStack {
                                        Picker("H", selection: $peakHour) {
                                            ForEach(0..<24) { h in Text(String(format: "%02d", h)).tag(h) }
                                        }
                                        .pickerStyle(WheelPickerStyle())
                                        .frame(width: 60).clipped()

                                        Text(":")
                                            .foregroundColor(OceanPalette.Ink.ivory)

                                        Picker("M", selection: $peakMinute) {
                                            ForEach([0, 15, 30, 45], id: \.self) { m in Text(String(format: "%02d", m)).tag(m) }
                                        }
                                        .pickerStyle(WheelPickerStyle())
                                        .frame(width: 60).clipped()
                                    }
                                    .padding(8)
                                    .background(OceanPalette.Ink.raised)
                                    .cornerRadius(OceanPalette.Curve.small)
                                }
                            }
                        }

                        // Location
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Location (optional)")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(OceanPalette.Ink.ivory)
                            TextField("e.g. North Bend Reservoir", text: $locationName)
                                .foregroundColor(OceanPalette.Ink.ivory)
                                .padding(12)
                                .background(OceanPalette.Ink.raised)
                                .cornerRadius(OceanPalette.Curve.small)
                        }

                        // Notes
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Notes (optional)")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(OceanPalette.Ink.ivory)
                            TextField("Water conditions, bait used...", text: $notes)
                                .foregroundColor(OceanPalette.Ink.ivory)
                                .padding(12)
                                .background(OceanPalette.Ink.raised)
                                .cornerRadius(OceanPalette.Curve.small)
                        }

                        // Moon preview
                        lunarPreview

                        PillAction(label: "Save Trip") { save() }

                        Spacer(minLength: 40)
                    }
                    .padding(OceanPalette.Gap.edge)
                }
            }
            .navigationTitle("New Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss.wrappedValue.dismiss() }
                        .foregroundColor(OceanPalette.Ink.gold)
                }
            }
        }
    }

    private var lunarPreview: some View {
        let stage = LunarCycle.engine.stage(for: date)
        return HStack(spacing: 12) {
            LunarDisc(stage: stage, diameter: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text("Lunar Phase")
                    .font(.system(size: 11))
                    .foregroundColor(OceanPalette.Ink.frost)
                Text(stage.label)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(OceanPalette.Ink.ivory)
            }
            Spacer()
        }
        .padding(14)
        .deepPanel()
    }

    private func save() {
        let stage = LunarCycle.engine.stage(for: date)
        let trip = TripRecord(
            date: date,
            gotBite: gotBite,
            peakHour: (gotBite && !noPeak) ? peakHour : nil,
            peakMinute: (gotBite && !noPeak) ? peakMinute : nil,
            lunar: stage,
            waterBody: waterBody,
            locationName: locationName.isEmpty ? nil : locationName,
            notes: notes.isEmpty ? nil : notes
        )
        Depot.vault.storeTrip(trip)
        Depot.vault.recordPattern(lunar: stage, body: waterBody, gotBite: gotBite)
        onSave()
        dismiss.wrappedValue.dismiss()
    }
}
