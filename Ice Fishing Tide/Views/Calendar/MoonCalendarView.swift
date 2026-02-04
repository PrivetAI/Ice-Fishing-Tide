import SwiftUI

struct MoonCalendarView: View {
    let waterBody: WaterBodyType
    @State private var currentMonth = Date()
    @State private var selectedDate: Date?
    @State private var showChart = false
    
    private let calendar = Calendar.current
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("Moon Calendar")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(AppTheme.Colors.textPrimary)
                .padding(.top, 20)
            
            // Month navigation
            monthNavigation
            
            // Days of week header
            daysOfWeekHeader
            
            // Calendar grid
            calendarGrid
            
            // Legend
            legendView
            
            // Info text
            infoText
            
            Spacer()
        }
        .background(AppTheme.Colors.backgroundGradient.ignoresSafeArea())
        .sheet(isPresented: $showChart) {
            if let date = selectedDate {
                NavigationView {
                    ChartView(date: date, waterBody: waterBody)
                        .navigationBarItems(trailing: Button("Close") {
                            showChart = false
                        })
                }
            }
        }
    }
    
    private var monthNavigation: some View {
        HStack {
            Button(action: previousMonth) {
                ArrowRightIcon(size: 24, color: AppTheme.Colors.textPrimary)
                    .rotationEffect(.degrees(180))
            }
            
            Spacer()
            
            Text(monthYearString)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(AppTheme.Colors.textPrimary)
            
            Spacer()
            
            Button(action: nextMonth) {
                ArrowRightIcon(size: 24, color: AppTheme.Colors.textPrimary)
            }
        }
        .padding(.horizontal)
    }
    
    private var daysOfWeekHeader: some View {
        HStack {
            ForEach(daysOfWeek, id: \.self) { day in
                Text(day)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 8)
    }
    
    private var calendarGrid: some View {
        let days = generateDaysInMonth()
        let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
        
        return LazyVGrid(columns: columns, spacing: 4) {
            ForEach(days, id: \.self) { date in
                if let date = date {
                    let day = calendar.component(.day, from: date)
                    let moonPhase = MoonCalculator.shared.getMoonPhase(for: date)
                    let isToday = calendar.isDateInToday(date)
                    
                    CalendarDayView(
                        day: day,
                        date: date,
                        moonPhase: moonPhase,
                        isCurrentMonth: true,
                        isToday: isToday
                    ) {
                        selectedDate = date
                        showChart = true
                    }
                } else {
                    Color.clear
                        .frame(height: 50)
                }
            }
        }
        .padding(.horizontal, 8)
    }
    
    private var legendView: some View {
        HStack(spacing: 20) {
            legendItem(color: AppTheme.Colors.zoneExcellent, text: "Best")
            legendItem(color: AppTheme.Colors.zoneMedium, text: "Medium")
            legendItem(color: AppTheme.Colors.zonePoor, text: "Poor")
        }
        .font(.system(size: 12))
        .padding(.top, 8)
    }
    
    private func legendItem(color: Color, text: String) -> some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 4)
                .fill(color.opacity(0.3))
                .frame(width: 20, height: 20)
            Text(text)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
    }
    
    private var infoText: some View {
        Text("Fish are most active during new moon and full moon. Tides are stronger during these phases.")
            .font(.system(size: 13))
            .foregroundColor(AppTheme.Colors.textSecondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    private func previousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: currentMonth) {
            currentMonth = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
            currentMonth = newDate
        }
    }
    
    private func generateDaysInMonth() -> [Date?] {
        var days: [Date?] = []
        
        let range = calendar.range(of: .day, in: .month, for: currentMonth)!
        let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        let firstWeekday = calendar.component(.weekday, from: firstDay) - 1
        
        // Add empty cells for days before the first day of month
        for _ in 0..<firstWeekday {
            days.append(nil)
        }
        
        // Add days of month
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(date)
            }
        }
        
        return days
    }
}
