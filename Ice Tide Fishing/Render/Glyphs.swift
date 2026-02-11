import SwiftUI

// MARK: - All custom drawn icons (no SF Symbols, no emoji)

struct GlyphTide: View {
    var size: CGFloat = 24
    var tint: Color = OceanPalette.Ink.gold

    var body: some View {
        Canvas { ctx, sz in
            let mid = sz.height / 2
            let amp = sz.height * 0.2
            var wave = Path()
            wave.move(to: CGPoint(x: 0, y: mid))
            for x in stride(from: CGFloat(0), to: sz.width, by: 2) {
                let frac = x / sz.width
                let y = mid + sin(frac * .pi * 3) * amp
                wave.addLine(to: CGPoint(x: x, y: y))
            }
            ctx.stroke(wave, with: .color(tint), lineWidth: 2.5)
        }
        .frame(width: size, height: size)
    }
}

struct GlyphMoonCrescent: View {
    var size: CGFloat = 24
    var tint: Color = OceanPalette.Ink.gold

    var body: some View {
        ZStack {
            Circle()
                .fill(tint)
                .frame(width: size * 0.7, height: size * 0.7)
            Circle()
                .fill(OceanPalette.Ink.abyss)
                .frame(width: size * 0.55, height: size * 0.55)
                .offset(x: size * 0.15)
        }
        .frame(width: size, height: size)
    }
}

struct GlyphFish: View {
    var size: CGFloat = 24
    var tint: Color = OceanPalette.Ink.gold

    var body: some View {
        Canvas { ctx, sz in
            var body = Path()
            let cx = sz.width * 0.45, cy = sz.height / 2
            // Fish body ellipse
            body.addEllipse(in: CGRect(x: cx - sz.width * 0.3, y: cy - sz.height * 0.2, width: sz.width * 0.6, height: sz.height * 0.4))
            ctx.fill(body, with: .color(tint))

            // Tail
            var tail = Path()
            tail.move(to: CGPoint(x: sz.width * 0.7, y: cy))
            tail.addLine(to: CGPoint(x: sz.width * 0.95, y: cy - sz.height * 0.25))
            tail.addLine(to: CGPoint(x: sz.width * 0.95, y: cy + sz.height * 0.25))
            tail.closeSubpath()
            ctx.fill(tail, with: .color(tint))

            // Eye
            var eye = Path()
            eye.addEllipse(in: CGRect(x: cx - sz.width * 0.15, y: cy - sz.height * 0.06, width: sz.width * 0.08, height: sz.height * 0.12))
            ctx.fill(eye, with: .color(OceanPalette.Ink.abyss))
        }
        .frame(width: size, height: size)
    }
}

struct GlyphCompass: View {
    var size: CGFloat = 24
    var tint: Color = OceanPalette.Ink.gold

    var body: some View {
        Canvas { ctx, sz in
            let center = CGPoint(x: sz.width / 2, y: sz.height / 2)
            let r = min(sz.width, sz.height) / 2 - 2

            var ring = Path()
            ring.addEllipse(in: CGRect(x: center.x - r, y: center.y - r, width: r * 2, height: r * 2))
            ctx.stroke(ring, with: .color(tint), lineWidth: 2)

            // North pointer
            var north = Path()
            north.move(to: CGPoint(x: center.x, y: center.y - r * 0.6))
            north.addLine(to: CGPoint(x: center.x - r * 0.15, y: center.y + r * 0.1))
            north.addLine(to: CGPoint(x: center.x + r * 0.15, y: center.y + r * 0.1))
            north.closeSubpath()
            ctx.fill(north, with: .color(tint))

            // South pointer
            var south = Path()
            south.move(to: CGPoint(x: center.x, y: center.y + r * 0.6))
            south.addLine(to: CGPoint(x: center.x - r * 0.12, y: center.y - r * 0.05))
            south.addLine(to: CGPoint(x: center.x + r * 0.12, y: center.y - r * 0.05))
            south.closeSubpath()
            ctx.fill(south, with: .color(tint.opacity(0.4)))
        }
        .frame(width: size, height: size)
    }
}

struct GlyphJournal: View {
    var size: CGFloat = 24
    var tint: Color = OceanPalette.Ink.gold

    var body: some View {
        Canvas { ctx, sz in
            // Book cover
            var cover = Path()
            cover.addRoundedRect(in: CGRect(x: sz.width * 0.15, y: sz.height * 0.1, width: sz.width * 0.7, height: sz.height * 0.8), cornerSize: CGSize(width: 3, height: 3))
            ctx.fill(cover, with: .color(tint.opacity(0.3)))
            ctx.stroke(cover, with: .color(tint), lineWidth: 1.5)

            // Spine
            var spine = Path()
            spine.move(to: CGPoint(x: sz.width * 0.15, y: sz.height * 0.1))
            spine.addLine(to: CGPoint(x: sz.width * 0.15, y: sz.height * 0.9))
            ctx.stroke(spine, with: .color(tint), lineWidth: 2)

            // Lines
            for i in 0..<3 {
                let y = sz.height * (0.3 + Double(i) * 0.15)
                var line = Path()
                line.move(to: CGPoint(x: sz.width * 0.3, y: y))
                line.addLine(to: CGPoint(x: sz.width * 0.7, y: y))
                ctx.stroke(line, with: .color(tint.opacity(0.5)), lineWidth: 1)
            }
        }
        .frame(width: size, height: size)
    }
}

struct GlyphCog: View {
    var size: CGFloat = 24
    var tint: Color = OceanPalette.Ink.gold

    var body: some View {
        Canvas { ctx, sz in
            let center = CGPoint(x: sz.width / 2, y: sz.height / 2)
            let outerR = min(sz.width, sz.height) / 2 - 2
            let innerR = outerR * 0.65
            let holeR = outerR * 0.3
            let teeth = 6

            var gear = Path()
            for i in 0..<(teeth * 2) {
                let angle = Double(i) * .pi / Double(teeth)
                let r: CGFloat = i % 2 == 0 ? outerR : innerR
                let pt = CGPoint(x: center.x + cos(angle) * r, y: center.y + sin(angle) * r)
                if i == 0 { gear.move(to: pt) } else { gear.addLine(to: pt) }
            }
            gear.closeSubpath()
            ctx.fill(gear, with: .color(tint))

            var hole = Path()
            hole.addEllipse(in: CGRect(x: center.x - holeR, y: center.y - holeR, width: holeR * 2, height: holeR * 2))
            ctx.fill(hole, with: .color(OceanPalette.Ink.panel))
        }
        .frame(width: size, height: size)
    }
}

struct GlyphPlus: View {
    var size: CGFloat = 24
    var tint: Color = OceanPalette.Ink.ivory

    var body: some View {
        Canvas { ctx, sz in
            let t: CGFloat = 3
            var h = Path()
            h.addRoundedRect(in: CGRect(x: sz.width * 0.2, y: (sz.height - t) / 2, width: sz.width * 0.6, height: t), cornerSize: CGSize(width: 1, height: 1))
            var v = Path()
            v.addRoundedRect(in: CGRect(x: (sz.width - t) / 2, y: sz.height * 0.2, width: t, height: sz.height * 0.6), cornerSize: CGSize(width: 1, height: 1))
            ctx.fill(h, with: .color(tint))
            ctx.fill(v, with: .color(tint))
        }
        .frame(width: size, height: size)
    }
}

struct GlyphTrash: View {
    var size: CGFloat = 24
    var tint: Color = OceanPalette.Ink.cautionOrange

    var body: some View {
        Canvas { ctx, sz in
            // Lid
            var lid = Path()
            lid.addRect(CGRect(x: sz.width * 0.2, y: sz.height * 0.15, width: sz.width * 0.6, height: sz.height * 0.08))
            ctx.fill(lid, with: .color(tint))

            // Handle
            var handle = Path()
            handle.addRoundedRect(in: CGRect(x: sz.width * 0.35, y: sz.height * 0.05, width: sz.width * 0.3, height: sz.height * 0.12), cornerSize: CGSize(width: 2, height: 2))
            ctx.stroke(handle, with: .color(tint), lineWidth: 1.5)

            // Body
            var body = Path()
            body.move(to: CGPoint(x: sz.width * 0.25, y: sz.height * 0.28))
            body.addLine(to: CGPoint(x: sz.width * 0.3, y: sz.height * 0.85))
            body.addLine(to: CGPoint(x: sz.width * 0.7, y: sz.height * 0.85))
            body.addLine(to: CGPoint(x: sz.width * 0.75, y: sz.height * 0.28))
            body.closeSubpath()
            ctx.fill(body, with: .color(tint.opacity(0.7)))
        }
        .frame(width: size, height: size)
    }
}

struct GlyphChevron: View {
    var size: CGFloat = 24
    var tint: Color = OceanPalette.Ink.frost
    var pointsRight: Bool = true

    var body: some View {
        Canvas { ctx, sz in
            var p = Path()
            if pointsRight {
                p.move(to: CGPoint(x: sz.width * 0.35, y: sz.height * 0.2))
                p.addLine(to: CGPoint(x: sz.width * 0.65, y: sz.height * 0.5))
                p.addLine(to: CGPoint(x: sz.width * 0.35, y: sz.height * 0.8))
            } else {
                p.move(to: CGPoint(x: sz.width * 0.65, y: sz.height * 0.2))
                p.addLine(to: CGPoint(x: sz.width * 0.35, y: sz.height * 0.5))
                p.addLine(to: CGPoint(x: sz.width * 0.65, y: sz.height * 0.8))
            }
            ctx.stroke(p, with: .color(tint), style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
        }
        .frame(width: size, height: size)
    }
}

struct GlyphCheck: View {
    var size: CGFloat = 24
    var tint: Color = OceanPalette.Ink.primeGreen

    var body: some View {
        Canvas { ctx, sz in
            var p = Path()
            p.move(to: CGPoint(x: sz.width * 0.2, y: sz.height * 0.5))
            p.addLine(to: CGPoint(x: sz.width * 0.4, y: sz.height * 0.72))
            p.addLine(to: CGPoint(x: sz.width * 0.8, y: sz.height * 0.28))
            ctx.stroke(p, with: .color(tint), style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
        }
        .frame(width: size, height: size)
    }
}

struct GlyphPin: View {
    var size: CGFloat = 24
    var tint: Color = OceanPalette.Ink.gold

    var body: some View {
        Canvas { ctx, sz in
            let cx = sz.width / 2
            // Pin head
            var head = Path()
            head.addEllipse(in: CGRect(x: cx - sz.width * 0.25, y: sz.height * 0.1, width: sz.width * 0.5, height: sz.height * 0.45))
            ctx.fill(head, with: .color(tint))
            // Pin point
            var point = Path()
            point.move(to: CGPoint(x: cx - sz.width * 0.1, y: sz.height * 0.5))
            point.addLine(to: CGPoint(x: cx, y: sz.height * 0.85))
            point.addLine(to: CGPoint(x: cx + sz.width * 0.1, y: sz.height * 0.5))
            point.closeSubpath()
            ctx.fill(point, with: .color(tint))
            // Inner hole
            var hole = Path()
            hole.addEllipse(in: CGRect(x: cx - sz.width * 0.1, y: sz.height * 0.2, width: sz.width * 0.2, height: sz.height * 0.2))
            ctx.fill(hole, with: .color(OceanPalette.Ink.panel))
        }
        .frame(width: size, height: size)
    }
}

struct GlyphBook: View {
    var size: CGFloat = 24
    var tint: Color = OceanPalette.Ink.gold

    var body: some View {
        Canvas { ctx, sz in
            // Left page
            var left = Path()
            left.move(to: CGPoint(x: sz.width * 0.5, y: sz.height * 0.15))
            left.addLine(to: CGPoint(x: sz.width * 0.1, y: sz.height * 0.2))
            left.addLine(to: CGPoint(x: sz.width * 0.1, y: sz.height * 0.85))
            left.addLine(to: CGPoint(x: sz.width * 0.5, y: sz.height * 0.8))
            left.closeSubpath()
            ctx.fill(left, with: .color(tint.opacity(0.4)))
            ctx.stroke(left, with: .color(tint), lineWidth: 1.5)

            // Right page
            var right = Path()
            right.move(to: CGPoint(x: sz.width * 0.5, y: sz.height * 0.15))
            right.addLine(to: CGPoint(x: sz.width * 0.9, y: sz.height * 0.2))
            right.addLine(to: CGPoint(x: sz.width * 0.9, y: sz.height * 0.85))
            right.addLine(to: CGPoint(x: sz.width * 0.5, y: sz.height * 0.8))
            right.closeSubpath()
            ctx.fill(right, with: .color(tint.opacity(0.3)))
            ctx.stroke(right, with: .color(tint), lineWidth: 1.5)
        }
        .frame(width: size, height: size)
    }
}
