import SwiftUI

struct HelpView: View {
    @State private var expandedSection: Int?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    HelpIcon(size: 48, color: AppTheme.Colors.secondary)
                    
                    Text("How It Works")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    
                    Text("Understanding water levels and fishing")
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                .padding(.top, 20)
                
                // Sections
                VStack(spacing: 12) {
                    helpSection(
                        index: 0,
                        title: "Tides in Rivers and Lakes",
                        content: tidesContent
                    )
                    
                    helpSection(
                        index: 1,
                        title: "Why Fish Are Active When Water Rises",
                        content: fishActivityContent
                    )
                    
                    helpSection(
                        index: 2,
                        title: "Reservoirs and Dam Releases",
                        content: reservoirContent
                    )
                }
                .padding(.horizontal)
                
                Spacer(minLength: 100)
            }
        }
        .background(AppTheme.Colors.backgroundGradient.ignoresSafeArea())
    }
    
    private func helpSection(index: Int, title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if expandedSection == index {
                        expandedSection = nil
                    } else {
                        expandedSection = index
                    }
                }
            }) {
                HStack {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    ArrowRightIcon(size: 20, color: AppTheme.Colors.textSecondary)
                        .rotationEffect(.degrees(expandedSection == index ? 90 : 0))
                }
                .padding()
                .background(AppTheme.Colors.surface)
            }
            
            if expandedSection == index {
                Text(content)
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .lineSpacing(6)
                    .padding()
                    .background(AppTheme.Colors.cardBackground)
            }
        }
        .cornerRadius(AppTheme.Dimensions.cornerRadius)
        .clipped()
    }
    
    private var tidesContent: String {
        """
        Even in freshwater bodies like rivers and lakes, the moon's gravitational pull creates subtle water level changes. While these effects are much weaker than ocean tides, they can still influence water movement.

        In rivers, the main water level changes come from upstream conditions, rainfall, and dam operations. However, during full and new moons, these natural fluctuations can be amplified.

        Lakes connected to rivers or with significant inflows experience more noticeable changes. The combination of lunar influence and water inflow creates a rhythm that fish respond to.
        """
    }
    
    private var fishActivityContent: String {
        """
        When water levels rise, several things happen that trigger fish to feed actively:

        1. Food sources are stirred up from the bottom, including insects, small crustaceans, and organic matter that fish eat.

        2. Oxygen levels increase as water movement brings fresh, oxygen-rich water into the area.

        3. Fish feel more secure in deeper water and are more willing to move and feed.

        4. Prey fish become active, which in turn attracts predator fish.

        This is why the green zones on the chart indicate the best fishing times - water is rising and fish are naturally more active.
        """
    }
    
    private var reservoirContent: String {
        """
        Reservoirs operate differently from natural water bodies. Water levels are controlled by dam operations based on:

        - Power generation schedules
        - Flood control requirements  
        - Water supply needs
        - Environmental flow requirements

        These releases often follow predictable patterns based on electricity demand (higher in morning and evening) and seasonal needs.

        Unlike natural tides, reservoir levels can change quickly and dramatically. Fish in reservoirs have adapted to these patterns and fishing success often depends on understanding the local release schedule.

        This app simulates general patterns, but for best results, check with local dam operators for specific release schedules.
        """
    }
}
