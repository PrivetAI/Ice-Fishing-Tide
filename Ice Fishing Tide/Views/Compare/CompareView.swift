import SwiftUI

struct CompareView: View {
    let waterBody: WaterBodyType
    @State private var date1 = Date()
    @State private var date2 = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    @State private var data1: DailyWaterData?
    @State private var data2: DailyWaterData?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                Text("Compare Days")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .padding(.top, 20)
                
                // Date pickers
                HStack(spacing: 16) {
                    datePicker(title: "Day 1", date: $date1, color: AppTheme.Colors.secondary)
                    datePicker(title: "Day 2", date: $date2, color: AppTheme.Colors.accent)
                }
                .padding(.horizontal)
                
                // Compare button
                SecondaryButton(title: "Compare") {
                    loadData()
                }
                .padding(.horizontal)
                
                // Charts
                if let data1 = data1, let data2 = data2 {
                    comparisonCharts(data1: data1, data2: data2)
                        .padding(.horizontal)
                    
                    comparisonSummary(data1: data1, data2: data2)
                        .padding(.horizontal)
                }
                
                Spacer(minLength: 100)
            }
        }
        .background(AppTheme.Colors.backgroundGradient.ignoresSafeArea())
        .onAppear {
            loadData()
        }
    }
    
    private func datePicker(title: String, date: Binding<Date>, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(color)
            
            DatePicker("", selection: date, displayedComponents: .date)
                .labelsHidden()
                .accentColor(color)
                .colorScheme(.dark)
                .padding(8)
                .background(AppTheme.Colors.surface)
                .cornerRadius(AppTheme.Dimensions.cornerRadius)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func comparisonCharts(data1: DailyWaterData, data2: DailyWaterData) -> some View {
        VStack(spacing: 16) {
            // Chart header
            HStack {
                legendDot(color: AppTheme.Colors.secondary, text: formatDate(date1))
                Spacer()
                legendDot(color: AppTheme.Colors.accent, text: formatDate(date2))
            }
            
            // Combined chart
            GeometryReader { geometry in
                ZStack {
                    // Day 1 line
                    chartPath(for: data1.levels, in: geometry.size)
                        .stroke(AppTheme.Colors.secondary, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                    
                    // Day 2 line
                    chartPath(for: data2.levels, in: geometry.size)
                        .stroke(AppTheme.Colors.accent, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, dash: [5, 3]))
                    
                    // Time axis
                    timeAxis(in: geometry.size)
                }
            }
            .frame(height: 180)
        }
        .padding()
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.Dimensions.cardCornerRadius)
    }
    
    private func chartPath(for levels: [WaterLevel], in size: CGSize) -> Path {
        let chartHeight = size.height - 20
        
        var path = Path()
        guard !levels.isEmpty else { return path }
        
        let pointWidth = size.width / CGFloat(levels.count - 1)
        
        for (index, level) in levels.enumerated() {
            let x = CGFloat(index) * pointWidth
            let y = chartHeight * (1 - CGFloat(level.level))
            
            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
    
    private func timeAxis(in size: CGSize) -> some View {
        HStack {
            ForEach([0, 6, 12, 18, 23], id: \.self) { hour in
                if hour > 0 { Spacer() }
                Text("\(hour)")
                    .font(.system(size: 10))
                    .foregroundColor(AppTheme.Colors.textSecondary.opacity(0.6))
                if hour < 23 { Spacer() }
            }
        }
        .offset(y: size.height / 2 - 5)
    }
    
    private func legendDot(color: Color, text: String) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
    }
    
    private func comparisonSummary(data1: DailyWaterData, data2: DailyWaterData) -> some View {
        VStack(spacing: 16) {
            Text("Comparison Summary")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppTheme.Colors.textPrimary)
            
            HStack(spacing: 20) {
                summaryColumn(data: data1, color: AppTheme.Colors.secondary, date: date1)
                
                Rectangle()
                    .fill(AppTheme.Colors.textSecondary.opacity(0.3))
                    .frame(width: 1)
                
                summaryColumn(data: data2, color: AppTheme.Colors.accent, date: date2)
            }
        }
        .padding()
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.Dimensions.cardCornerRadius)
    }
    
    private func summaryColumn(data: DailyWaterData, color: Color, date: Date) -> some View {
        VStack(spacing: 8) {
            Text(formatDate(date))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(color)
            
            MoonPhaseIcon(phase: data.moonPhase, size: 28)
            
            Text(data.moonPhase.displayName)
                .font(.system(size: 12))
                .foregroundColor(AppTheme.Colors.textSecondary)
            
            Text(qualityText(for: data.moonPhase))
                .font(.system(size: 11))
                .foregroundColor(qualityColor(for: data.moonPhase))
        }
        .frame(maxWidth: .infinity)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
    
    private func qualityText(for phase: MoonPhase) -> String {
        switch phase.fishingQuality {
        case .excellent: return "Best"
        case .good: return "Good"
        case .medium: return "Medium"
        case .poor: return "Poor"
        }
    }
    
    private func qualityColor(for phase: MoonPhase) -> Color {
        switch phase.fishingQuality {
        case .excellent, .good: return AppTheme.Colors.zoneExcellent
        case .medium: return AppTheme.Colors.zoneMedium
        case .poor: return AppTheme.Colors.zonePoor
        }
    }
    
    private func loadData() {
        data1 = WaterLevelSimulator.shared.generateDailyData(for: date1, waterBody: waterBody)
        data2 = WaterLevelSimulator.shared.generateDailyData(for: date2, waterBody: waterBody)
    }
}
