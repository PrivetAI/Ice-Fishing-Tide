import SwiftUI

// MARK: - Tab Bar Icons

struct TabIconHome: View {
    var body: some View {
        Image(uiImage: createHomeImage())
            .renderingMode(.template)
    }
    
    private func createHomeImage() -> UIImage {
        let size = CGSize(width: 24, height: 24)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let ctx = context.cgContext
            let color = UIColor.white
            
            ctx.setFillColor(color.cgColor)
            
            // House body
            ctx.move(to: CGPoint(x: 4, y: 12))
            ctx.addLine(to: CGPoint(x: 4, y: 20))
            ctx.addLine(to: CGPoint(x: 20, y: 20))
            ctx.addLine(to: CGPoint(x: 20, y: 12))
            ctx.closePath()
            ctx.fillPath()
            
            // Roof
            ctx.move(to: CGPoint(x: 2, y: 12))
            ctx.addLine(to: CGPoint(x: 12, y: 4))
            ctx.addLine(to: CGPoint(x: 22, y: 12))
            ctx.closePath()
            ctx.fillPath()
        }
    }
}

struct TabIconChart: View {
    var body: some View {
        Image(uiImage: createChartImage())
            .renderingMode(.template)
    }
    
    private func createChartImage() -> UIImage {
        let size = CGSize(width: 24, height: 24)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let ctx = context.cgContext
            let color = UIColor.white
            
            ctx.setStrokeColor(color.cgColor)
            ctx.setLineWidth(2)
            
            // Wave line
            ctx.move(to: CGPoint(x: 2, y: 12))
            ctx.addQuadCurve(to: CGPoint(x: 8, y: 8), control: CGPoint(x: 5, y: 6))
            ctx.addQuadCurve(to: CGPoint(x: 14, y: 16), control: CGPoint(x: 11, y: 12))
            ctx.addQuadCurve(to: CGPoint(x: 22, y: 10), control: CGPoint(x: 18, y: 20))
            ctx.strokePath()
        }
    }
}

struct TabIconCalendar: View {
    var body: some View {
        Image(uiImage: createCalendarImage())
            .renderingMode(.template)
    }
    
    private func createCalendarImage() -> UIImage {
        let size = CGSize(width: 24, height: 24)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let ctx = context.cgContext
            let color = UIColor.white
            
            ctx.setFillColor(color.cgColor)
            ctx.fill(CGRect(x: 3, y: 5, width: 18, height: 16))
            
            // Header
            ctx.setFillColor(UIColor.gray.cgColor)
            ctx.fill(CGRect(x: 3, y: 5, width: 18, height: 4))
            
            // Binding rings
            ctx.setFillColor(color.cgColor)
            ctx.fill(CGRect(x: 7, y: 3, width: 2, height: 4))
            ctx.fill(CGRect(x: 15, y: 3, width: 2, height: 4))
            
            // Days grid
            ctx.setFillColor(UIColor.darkGray.cgColor)
            for row in 0..<3 {
                for col in 0..<4 {
                    ctx.fill(CGRect(x: 5 + col * 4, y: 11 + row * 3, width: 2, height: 2))
                }
            }
        }
    }
}

struct TabIconLog: View {
    var body: some View {
        Image(uiImage: createLogImage())
            .renderingMode(.template)
    }
    
    private func createLogImage() -> UIImage {
        let size = CGSize(width: 24, height: 24)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let ctx = context.cgContext
            let color = UIColor.white
            
            ctx.setFillColor(color.cgColor)
            ctx.fill(CGRect(x: 4, y: 3, width: 16, height: 18))
            
            // Lines
            ctx.setStrokeColor(UIColor.gray.cgColor)
            ctx.setLineWidth(1.5)
            for i in 0..<4 {
                let y = CGFloat(7 + i * 4)
                ctx.move(to: CGPoint(x: 7, y: y))
                ctx.addLine(to: CGPoint(x: 17, y: y))
            }
            ctx.strokePath()
        }
    }
}

struct TabIconSettings: View {
    var body: some View {
        Image(uiImage: createSettingsImage())
            .renderingMode(.template)
    }
    
    private func createSettingsImage() -> UIImage {
        let size = CGSize(width: 24, height: 24)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let ctx = context.cgContext
            let color = UIColor.white
            
            ctx.setFillColor(color.cgColor)
            
            // Outer gear
            let center = CGPoint(x: 12, y: 12)
            let outerRadius: CGFloat = 9
            let innerRadius: CGFloat = 6
            let teeth = 8
            
            for i in 0..<teeth {
                let angle1 = Double(i) * 2 * .pi / Double(teeth)
                let angle2 = angle1 + .pi / Double(teeth)
                
                let x1 = center.x + CGFloat(cos(angle1)) * outerRadius
                let y1 = center.y + CGFloat(sin(angle1)) * outerRadius
                let x2 = center.x + CGFloat(cos(angle2)) * innerRadius
                let y2 = center.y + CGFloat(sin(angle2)) * innerRadius
                
                ctx.fillEllipse(in: CGRect(x: x1 - 2, y: y1 - 2, width: 4, height: 4))
                _ = CGRect(x: x2 - 1.5, y: y2 - 1.5, width: 3, height: 3)
            }
            
            // Center circle
            ctx.fillEllipse(in: CGRect(x: 7, y: 7, width: 10, height: 10))
            
            // Inner hole
            ctx.setFillColor(UIColor.black.cgColor)
            ctx.fillEllipse(in: CGRect(x: 9, y: 9, width: 6, height: 6))
        }
    }
}

// MARK: - Moon Phase Icons

struct MoonPhaseIcon: View {
    let phase: MoonPhase
    var size: CGFloat = 32
    
    var body: some View {
        ZStack {
            Circle()
                .fill(AppTheme.Colors.textSecondary.opacity(0.3))
                .frame(width: size, height: size)
            
            moonShape
                .fill(AppTheme.Colors.accent)
                .frame(width: size, height: size)
        }
    }
    
    @ViewBuilder
    private var moonShape: some View {
        switch phase {
        case .newMoon:
            Circle()
                .stroke(AppTheme.Colors.accent, lineWidth: 2)
        case .fullMoon:
            Circle()
        case .firstQuarter:
            HalfMoon(isLeft: false)
        case .lastQuarter:
            HalfMoon(isLeft: true)
        case .waxingCrescent:
            CrescentMoon(illumination: 0.25, isWaxing: true)
        case .waningCrescent:
            CrescentMoon(illumination: 0.25, isWaxing: false)
        case .waxingGibbous:
            GibbousMoon(illumination: 0.75, isWaxing: true)
        case .waningGibbous:
            GibbousMoon(illumination: 0.75, isWaxing: false)
        }
    }
}

struct HalfMoon: Shape {
    let isLeft: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        let startAngle: Angle = isLeft ? .degrees(-90) : .degrees(90)
        let endAngle: Angle = isLeft ? .degrees(90) : .degrees(270)
        
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closeSubpath()
        
        return path
    }
}

struct CrescentMoon: Shape {
    let illumination: Double
    let isWaxing: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        path.addArc(center: center, radius: radius, 
                    startAngle: .degrees(isWaxing ? -90 : 90), 
                    endAngle: .degrees(isWaxing ? 90 : 270), 
                    clockwise: false)
        
        let offset = radius * CGFloat(1 - illumination * 2)
        let innerCenter = CGPoint(x: center.x + (isWaxing ? -offset : offset), y: center.y)
        
        path.addArc(center: innerCenter, radius: radius, 
                    startAngle: .degrees(isWaxing ? 90 : 270), 
                    endAngle: .degrees(isWaxing ? -90 : 90), 
                    clockwise: false)
        
        return path
    }
}

struct GibbousMoon: Shape {
    let illumination: Double
    let isWaxing: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        path.addArc(center: center, radius: radius, 
                    startAngle: .degrees(-90), 
                    endAngle: .degrees(90), 
                    clockwise: isWaxing)
        
        let offset = radius * CGFloat((illumination - 0.5) * 2)
        let innerCenter = CGPoint(x: center.x + (isWaxing ? offset : -offset), y: center.y)
        
        path.addArc(center: innerCenter, radius: radius, 
                    startAngle: .degrees(90), 
                    endAngle: .degrees(-90), 
                    clockwise: !isWaxing)
        
        return path
    }
}

// MARK: - Inline Icons

struct WaveIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.Colors.secondary
    
    var body: some View {
        WaveShape()
            .stroke(color, lineWidth: size * 0.1)
            .frame(width: size, height: size)
    }
}

struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midY = rect.midY
        let amplitude = rect.height * 0.25
        
        path.move(to: CGPoint(x: 0, y: midY))
        
        for x in stride(from: 0, to: rect.width, by: 2) {
            let relativeX = x / rect.width
            let y = midY + sin(relativeX * .pi * 3) * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        return path
    }
}

struct RiverIcon: View {
    var size: CGFloat = 48
    var color: Color = AppTheme.Colors.secondary
    
    var body: some View {
        ZStack {
            // Water waves
            ForEach(0..<3, id: \.self) { i in
                WaveShape()
                    .stroke(color.opacity(1 - Double(i) * 0.2), lineWidth: 2)
                    .frame(width: size * 0.8, height: size * 0.15)
                    .offset(y: CGFloat(i - 1) * size * 0.2)
            }
        }
        .frame(width: size, height: size)
    }
}

struct ReservoirIcon: View {
    var size: CGFloat = 48
    var color: Color = AppTheme.Colors.secondary
    
    var body: some View {
        ZStack {
            // Dam wall
            RoundedRectangle(cornerRadius: 2)
                .fill(AppTheme.Colors.textSecondary)
                .frame(width: size * 0.15, height: size * 0.6)
                .offset(x: -size * 0.25)
            
            // Water
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: size * 0.5, height: size * 0.4)
                .offset(x: size * 0.1)
            
            // Outflow
            Path { path in
                path.move(to: CGPoint(x: size * 0.25, y: size * 0.5))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.5, y: size * 0.7),
                    control: CGPoint(x: size * 0.35, y: size * 0.6)
                )
            }
            .stroke(color, lineWidth: 2)
        }
        .frame(width: size, height: size)
    }
}

struct LakeIcon: View {
    var size: CGFloat = 48
    var color: Color = AppTheme.Colors.secondary
    
    var body: some View {
        ZStack {
            // Lake body
            Ellipse()
                .fill(color)
                .frame(width: size * 0.7, height: size * 0.5)
            
            // Inflow stream
            Path { path in
                path.move(to: CGPoint(x: size * 0.1, y: size * 0.2))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.35, y: size * 0.4),
                    control: CGPoint(x: size * 0.2, y: size * 0.35)
                )
            }
            .stroke(color.opacity(0.7), lineWidth: 2)
        }
        .frame(width: size, height: size)
    }
}

struct PlusIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.Colors.textPrimary
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(width: size * 0.6, height: size * 0.15)
            
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(width: size * 0.15, height: size * 0.6)
        }
        .frame(width: size, height: size)
    }
}

struct CheckmarkIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.Colors.zoneExcellent
    
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: size * 0.2, y: size * 0.5))
            path.addLine(to: CGPoint(x: size * 0.4, y: size * 0.7))
            path.addLine(to: CGPoint(x: size * 0.8, y: size * 0.3))
        }
        .stroke(color, style: StrokeStyle(lineWidth: size * 0.1, lineCap: .round, lineJoin: .round))
        .frame(width: size, height: size)
    }
}

struct TrashIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.Colors.zoneMedium
    
    var body: some View {
        ZStack {
            // Lid
            RoundedRectangle(cornerRadius: 1)
                .fill(color)
                .frame(width: size * 0.65, height: size * 0.08)
                .offset(y: -size * 0.3)
            
            // Handle
            RoundedRectangle(cornerRadius: 2)
                .stroke(color, lineWidth: size * 0.08)
                .frame(width: size * 0.25, height: size * 0.1)
                .offset(y: -size * 0.38)
            
            // Body
            TrapezoidShape()
                .fill(color)
                .frame(width: size * 0.55, height: size * 0.5)
                .offset(y: size * 0.08)
        }
        .frame(width: size, height: size)
    }
}

struct TrapezoidShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.1, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.1, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.2, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct ArrowRightIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.Colors.textSecondary
    
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: size * 0.35, y: size * 0.25))
            path.addLine(to: CGPoint(x: size * 0.65, y: size * 0.5))
            path.addLine(to: CGPoint(x: size * 0.35, y: size * 0.75))
        }
        .stroke(color, style: StrokeStyle(lineWidth: size * 0.1, lineCap: .round, lineJoin: .round))
        .frame(width: size, height: size)
    }
}

struct CompareIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.Colors.secondary
    
    var body: some View {
        ZStack {
            // Two overlapping waves
            WaveShape()
                .stroke(color, lineWidth: 2)
                .frame(width: size * 0.8, height: size * 0.3)
                .offset(y: -size * 0.1)
            
            WaveShape()
                .stroke(color.opacity(0.5), lineWidth: 2)
                .frame(width: size * 0.8, height: size * 0.3)
                .offset(y: size * 0.1)
        }
        .frame(width: size, height: size)
    }
}

struct HelpIcon: View {
    var size: CGFloat = 24
    var color: Color = AppTheme.Colors.textPrimary
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color, lineWidth: size * 0.08)
                .frame(width: size * 0.8, height: size * 0.8)
            
            Text("?")
                .font(.system(size: size * 0.5, weight: .bold))
                .foregroundColor(color)
        }
        .frame(width: size, height: size)
    }
}
