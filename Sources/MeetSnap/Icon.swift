import Cocoa

enum Icon {
    private static let inactiveImage: NSImage = buildIcon(filled: false)
    private static let activeImage: NSImage = buildIcon(filled: true)

    static func setup(button: NSStatusBarButton) {
        button.title = ""
        button.imagePosition = .imageOnly
        setInactive(button: button)
    }

    static func setActive(button: NSStatusBarButton) {
        button.image = activeImage
        button.alphaValue = 1.0
    }

    static func setInactive(button: NSStatusBarButton) {
        button.image = inactiveImage
        button.alphaValue = 0.45
    }

    private static func buildIcon(filled: Bool) -> NSImage {
        let size = NSSize(width: 22, height: 22)
        let image = NSImage(size: size, flipped: true) { _ in
            NSColor.black.setStroke()
            NSColor.black.setFill()

            let bodyRect = NSRect(x: 1, y: 3, width: 13, height: 10)
            let body = NSBezierPath(roundedRect: bodyRect, xRadius: 2, yRadius: 2)

            let lens = NSBezierPath()
            lens.move(to: NSPoint(x: 15.5, y: 5))
            lens.line(to: NSPoint(x: 19.5, y: 3))
            lens.line(to: NSPoint(x: 19.5, y: 13))
            lens.line(to: NSPoint(x: 15.5, y: 11))
            lens.close()
            lens.lineJoinStyle = .round

            // Return arrow — smooth curved shape
            let arrow = NSBezierPath()
            arrow.lineCapStyle = .round
            arrow.lineJoinStyle = .round

            if filled {
                body.fill()
                lens.fill()

                // Cut out G
                let ctx = NSGraphicsContext.current!
                ctx.compositingOperation = .destinationOut
                drawG(at: NSPoint(x: 1, y: 3), fontSize: 8, weight: .bold)
                ctx.compositingOperation = .sourceOver

                // Filled arrow
                arrow.move(to: NSPoint(x: 8, y: 19))
                arrow.curve(to: NSPoint(x: 20, y: 19),
                           controlPoint1: NSPoint(x: 10, y: 19),
                           controlPoint2: NSPoint(x: 20, y: 19))
                arrow.curve(to: NSPoint(x: 20, y: 14.5),
                           controlPoint1: NSPoint(x: 22, y: 19),
                           controlPoint2: NSPoint(x: 22, y: 14.5))

                arrow.lineWidth = 1.5
                arrow.stroke()

                // Arrowhead
                let head = NSBezierPath()
                head.lineWidth = 1.5
                head.lineCapStyle = .round
                head.lineJoinStyle = .round
                head.move(to: NSPoint(x: 10.5, y: 17))
                head.line(to: NSPoint(x: 8, y: 19))
                head.line(to: NSPoint(x: 10.5, y: 21))
                head.stroke()
            } else {
                body.lineWidth = 1.4
                body.stroke()
                lens.lineWidth = 1.4
                lens.stroke()

                drawG(at: NSPoint(x: 1, y: 3), fontSize: 8, weight: .bold)

                // Outlined arrow — same shape
                arrow.move(to: NSPoint(x: 8, y: 19))
                arrow.curve(to: NSPoint(x: 20, y: 19),
                           controlPoint1: NSPoint(x: 10, y: 19),
                           controlPoint2: NSPoint(x: 20, y: 19))
                arrow.curve(to: NSPoint(x: 20, y: 14.5),
                           controlPoint1: NSPoint(x: 22, y: 19),
                           controlPoint2: NSPoint(x: 22, y: 14.5))

                arrow.lineWidth = 1.4
                arrow.stroke()

                let head = NSBezierPath()
                head.lineWidth = 1.4
                head.lineCapStyle = .round
                head.lineJoinStyle = .round
                head.move(to: NSPoint(x: 10.5, y: 17))
                head.line(to: NSPoint(x: 8, y: 19))
                head.line(to: NSPoint(x: 10.5, y: 21))
                head.stroke()
            }

            return true
        }
        image.isTemplate = true
        return image
    }

    private static func drawG(at origin: NSPoint, fontSize: CGFloat, weight: NSFont.Weight) {
        let font = NSFont.systemFont(ofSize: fontSize, weight: weight)
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: NSColor.black
        ]
        let g = NSAttributedString(string: "G", attributes: attrs)
        let gSize = g.size()
        let gX = origin.x + (13 - gSize.width) / 2
        let gY = origin.y + (10 - gSize.height) / 2
        g.draw(at: NSPoint(x: gX, y: gY))
    }
}
