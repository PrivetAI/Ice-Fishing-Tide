import SwiftUI

struct WaterLevelChart: View {
    let data: DailyWaterData
    @State private var selectedPoint: WaterLevel?
    @State private var showTooltip = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Moon phase header
            HStack {
                MoonPhaseIcon(phase: data.moonPhase, size: 28)
                Text(data.moonPhase.displayName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppTheme.Colors.textSecondary)
                Spacer()
            }
            
            // Chart
            GeometryReader { geometry in
                ZStack(alignment: .topLeading) {
                    // Background gradient zones
                    chartBackground(in: geometry.size)
                    
                    // Water level line
                    chartLine(in: geometry.size)
                        .stroke(
                            LinearGradient(
                                colors: [AppTheme.Colors.secondary, AppTheme.Colors.accent],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                        )
                    
                    // Zone fills
                    chartFill(in: geometry.size)
                    
                    // Time axis labels
                    timeAxisLabels(in: geometry.size)
                    
                    // Tooltip
                    if showTooltip, let point = selectedPoint {
                        tooltipView(for: point, in: geometry.size)
                    }
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            handleTouch(at: value.location, in: geometry.size)
                        }
                        .onEnded { _ in
                            withAnimation(.easeOut(duration: 0.3)) {
                                showTooltip = false
                            }
                        }
                )
            }
            .frame(height: 200)
            
            // Best time recommendation
            Text(data.bestTimeDescription)
                .font(.system(size: 14))
                .foregroundColor(AppTheme.Colors.zoneExcellent)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Legend
            legendView
        }
        .padding()
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.Dimensions.cardCornerRadius)
    }
    
    private func chartBackground(in size: CGSize) -> some View {
        let chartHeight = size.height - 30
        
        return VStack(spacing: 0) {
            // Level guides
            ForEach([100, 75, 50, 25, 0], id: \.self) { level in
                HStack {
                    Text("\(level)%")
                        .font(.system(size: 10))
                        .foregroundColor(AppTheme.Colors.textSecondary.opacity(0.5))
                        .frame(width: 30, alignment: .trailing)
                    
                    Rectangle()
                        .fill(AppTheme.Colors.textSecondary.opacity(0.1))
                        .frame(height: 1)
                }
                if level > 0 {
                    Spacer()
                }
            }
        }
        .frame(height: chartHeight)
    }
    
    private func chartLine(in size: CGSize) -> Path {
        let chartWidth = size.width - 40
        let chartHeight = size.height - 30
        let offsetX: CGFloat = 35
        
        var path = Path()
        
        guard !data.levels.isEmpty else { return path }
        
        let pointWidth = chartWidth / CGFloat(data.levels.count - 1)
        
        for (index, level) in data.levels.enumerated() {
            let x = offsetX + CGFloat(index) * pointWidth
            let y = chartHeight * (1 - CGFloat(level.level))
            
            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
    
    private func chartFill(in size: CGSize) -> some View {
        let chartWidth = size.width - 40
        let chartHeight = size.height - 30
        let offsetX: CGFloat = 35
        
        return Path { path in
            guard !data.levels.isEmpty else { return }
            
            let pointWidth = chartWidth / CGFloat(data.levels.count - 1)
            
            // Start at bottom left
            path.move(to: CGPoint(x: offsetX, y: chartHeight))
            
            // Draw along levels
            for (index, level) in data.levels.enumerated() {
                let x = offsetX + CGFloat(index) * pointWidth
                let y = chartHeight * (1 - CGFloat(level.level))
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            // Close to bottom right and back
            path.addLine(to: CGPoint(x: offsetX + chartWidth, y: chartHeight))
            path.closeSubpath()
        }
        .fill(
            LinearGradient(
                colors: [AppTheme.Colors.secondary.opacity(0.3), AppTheme.Colors.secondary.opacity(0.05)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    private func timeAxisLabels(in size: CGSize) -> some View {
        let chartWidth = size.width - 40
        let offsetX: CGFloat = 35
        
        return HStack {
            Spacer().frame(width: offsetX)
            ForEach([0, 6, 12, 18, 23], id: \.self) { hour in
                if hour > 0 {
                    Spacer()
                }
                Text(String(format: "%02d:00", hour))
                    .font(.system(size: 10))
                    .foregroundColor(AppTheme.Colors.textSecondary.opacity(0.7))
                if hour < 23 {
                    Spacer()
                }
            }
        }
        .frame(width: size.width)
        .offset(y: size.height - 20)
    }
    
    private func handleTouch(at location: CGPoint, in size: CGSize) {
        let chartWidth = size.width - 40
        let offsetX: CGFloat = 35
        
        let relativeX = location.x - offsetX
        let progress = relativeX / chartWidth
        let index = Int(progress * CGFloat(data.levels.count - 1))
        
        if index >= 0 && index < data.levels.count {
            selectedPoint = data.levels[index]
            withAnimation(.easeOut(duration: 0.15)) {
                showTooltip = true
            }
        }
    }
    
    private func tooltipView(for point: WaterLevel, in size: CGSize) -> some View {
        let chartWidth = size.width - 40
        let chartHeight = size.height - 30
        let offsetX: CGFloat = 35
        let index = data.levels.firstIndex(where: { $0.id == point.id }) ?? 0
        let pointWidth = chartWidth / CGFloat(data.levels.count - 1)
        
        let x = offsetX + CGFloat(index) * pointWidth
        let y = chartHeight * (1 - CGFloat(point.level))
        
        return VStack(spacing: 4) {
            Text(point.timeString)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(AppTheme.Colors.textPrimary)
            
            Text("\(point.levelPercent)%")
                .font(.system(size: 11))
                .foregroundColor(AppTheme.Colors.secondary)
            
            Text(point.zone.description)
                .font(.system(size: 10))
                .foregroundColor(zoneColor(for: point.zone))
                .multilineTextAlignment(.center)
        }
        .padding(8)
        .background(AppTheme.Colors.surface)
        .cornerRadius(8)
        .shadow(radius: 4)
        .position(x: min(max(x, 80), size.width - 80), y: max(y - 50, 40))
    }
    
    private var legendView: some View {
        HStack(spacing: 20) {
            legendItem(color: AppTheme.Colors.zoneExcellent, text: "Rising - Best")
            legendItem(color: AppTheme.Colors.zoneMedium, text: "Peak - Medium")
            legendItem(color: AppTheme.Colors.zonePoor, text: "Falling - Poor")
        }
        .font(.system(size: 11))
    }
    
    private func legendItem(color: Color, text: String) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(text)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
    }
    
    private func zoneColor(for zone: FishingZone) -> Color {
        switch zone {
        case .excellent: return AppTheme.Colors.zoneExcellent
        case .medium: return AppTheme.Colors.zoneMedium
        case .poor: return AppTheme.Colors.zonePoor
        }
    }
}
