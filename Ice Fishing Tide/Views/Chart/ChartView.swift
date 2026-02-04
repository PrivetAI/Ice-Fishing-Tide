import SwiftUI

struct ChartView: View {
    let date: Date
    let waterBody: WaterBodyType
    @State private var waterData: DailyWaterData?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("Water Level Chart")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    
                    Text(formattedDate)
                        .font(.system(size: 16))
                        .foregroundColor(AppTheme.Colors.textSecondary)
                    
                    Text(waterBody.displayName)
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.Colors.secondary)
                }
                .padding(.top, 20)
                
                // Chart
                if let data = waterData {
                    WaterLevelChart(data: data)
                        .padding(.horizontal)
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.secondary))
                        .frame(height: 300)
                }
                
                // Tips section
                tipsSection
                    .padding(.horizontal)
                
                Spacer(minLength: 100)
            }
        }
        .background(AppTheme.Colors.backgroundGradient.ignoresSafeArea())
        .onAppear {
            loadData()
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    private func loadData() {
        waterData = WaterLevelSimulator.shared.generateDailyData(for: date, waterBody: waterBody)
    }
    
    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Fishing Tips")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppTheme.Colors.textPrimary)
            
            VStack(alignment: .leading, spacing: 8) {
                tipRow(color: AppTheme.Colors.zoneExcellent, text: "Green zones: Water rising - fish actively feeding")
                tipRow(color: AppTheme.Colors.zoneMedium, text: "Yellow zones: Peak or slow fall - moderate activity")
                tipRow(color: AppTheme.Colors.zonePoor, text: "Gray zones: Water falling - low activity")
            }
        }
        .padding()
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.Dimensions.cardCornerRadius)
    }
    
    private func tipRow(color: Color, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
                .padding(.top, 4)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
    }
}
