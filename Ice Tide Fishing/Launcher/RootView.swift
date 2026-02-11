import SwiftUI

struct RootView: View {
    @State private var waterBody: WaterBodyKind
    @State private var chosenDate = Date()

    init() {
        let wb = Depot.vault.chosenBody
        _waterBody = State(initialValue: wb)

        // Nav bar appearance
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = UIColor(OceanPalette.Ink.abyss)
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor(OceanPalette.Ink.gold)]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(OceanPalette.Ink.gold)]
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
        UINavigationBar.appearance().tintColor = UIColor(OceanPalette.Ink.gold)
    }

    var body: some View {
        NavigationView {
            TimelineScreen(waterBody: $waterBody, chosenDate: $chosenDate)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(OceanPalette.Ink.gold)
    }
}
