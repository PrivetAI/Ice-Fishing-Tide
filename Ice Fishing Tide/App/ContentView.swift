import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var selectedWaterBody: WaterBodyType
    @State private var selectedDate = Date()
    @State private var showChart = false
    
    init() {
        let storedWaterBody = StorageService.shared.selectedWaterBody
        _selectedWaterBody = State(initialValue: storedWaterBody)
        
        // Configure tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(AppTheme.Colors.backgroundDark)
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppTheme.Colors.textSecondary)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(AppTheme.Colors.textSecondary)]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppTheme.Colors.secondary)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(AppTheme.Colors.secondary)]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Home
            NavigationView {
                HomeView(
                    selectedWaterBody: $selectedWaterBody,
                    selectedDate: $selectedDate,
                    showChart: $showChart
                )
                .navigationBarHidden(true)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                TabIconHome()
                Text("Home")
            }
            .tag(0)
            
            // Tab 2: Calendar  
            NavigationView {
                MoonCalendarView(waterBody: selectedWaterBody)
                    .navigationBarHidden(true)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                TabIconCalendar()
                Text("Calendar")
            }
            .tag(1)
            
            // Tab 3: Log
            NavigationView {
                LogView(waterBody: selectedWaterBody)
                    .navigationBarHidden(true)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                TabIconLog()
                Text("Log")
            }
            .tag(2)
            
            // Tab 4: Compare
            NavigationView {
                CompareView(waterBody: selectedWaterBody)
                    .navigationBarHidden(true)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                TabIconChart()
                Text("Compare")
            }
            .tag(3)
            
            // Tab 5: Help
            NavigationView {
                HelpView()
                    .navigationBarHidden(true)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(uiImage: createHelpImage())
                    .renderingMode(.template)
                Text("Help")
            }
            .tag(4)
            
            // Tab 6: Settings
            NavigationView {
                SettingsView(selectedWaterBody: $selectedWaterBody)
                    .navigationBarHidden(true)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                TabIconSettings()
                Text("Settings")
            }
            .tag(5)
        }
        .accentColor(AppTheme.Colors.secondary)
        .sheet(isPresented: $showChart) {
            NavigationView {
                ChartView(date: selectedDate, waterBody: selectedWaterBody)
                    .navigationBarItems(trailing: Button("Close") {
                        showChart = false
                    })
            }
        }
    }
    
    private func createHelpImage() -> UIImage {
        let size = CGSize(width: 24, height: 24)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let ctx = context.cgContext
            let color = UIColor.white
            
            ctx.setStrokeColor(color.cgColor)
            ctx.setLineWidth(2)
            ctx.strokeEllipse(in: CGRect(x: 4, y: 4, width: 16, height: 16))
            
            // Question mark
            ctx.setFillColor(color.cgColor)
            let font = UIFont.systemFont(ofSize: 12, weight: .bold)
            let text = "?" as NSString
            let textSize = text.size(withAttributes: [.font: font])
            let textRect = CGRect(
                x: (24 - textSize.width) / 2,
                y: (24 - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            text.draw(in: textRect, withAttributes: [.font: font, .foregroundColor: color])
        }
    }
}
