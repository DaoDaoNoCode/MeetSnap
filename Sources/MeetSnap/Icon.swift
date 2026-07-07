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

    private static func buildIcon(filled: Bool) -> NSImage {
        let size = NSSize(width: 22, height: 22)
        let image = NSImage(size: size, flipped: true) { _ in
            NSColor.black.setStroke()
            NSColor.black.setFill()

            let bodyRect = NSRect(x: 1, y: 4, width: 13, height: 10)
            let body = NSBezierPath(roundedRect: bodyRect, xRadius: 2, yRadius: 2)

            let lens = NSBezierPath()
            lens.move(to: NSPoint(x: 15.5, y: 6))
            lens.line(to: NSPoint(x: 19.5, y: 4))
            lens.line(to: NSPoint(x: 19.5, y: 14))
            lens.line(to: NSPoint(x: 15.5, y: 12))
            lens.close()
            lens.lineJoinStyle = .round

            if filled {
                body.fill()
                lens.fill()

                // Cut out the G from the filled body
                let ctx = NSGraphicsContext.current!
                ctx.compositingOperation = .destinationOut
                drawG(at: NSPoint(x: 1, y: 4), fontSize: 8, weight: .bold)
                ctx.compositingOperation = .sourceOver

                // Return arrow below the camera
                let arrow = NSBezierPath()
                arrow.lineWidth = 1.2
                arrow.lineCapStyle = .round
                arrow.lineJoinStyle = .round
                arrow.move(to: NSPoint(x: 12, y: 17))
                arrow.line(to: NSPoint(x: 14, y: 15.5))
                arrow.move(to: NSPoint(x: 12, y: 17))
                arrow.line(to: NSPoint(x: 14.5, y: 18))

                arrow.move(to: NSPoint(x: 12, y: 17))
                arrow.line(to: NSPoint(x: 19, y: 17))
                arrow.curve(to: NSPoint(x: 19, y: 14.5),
                           controlPoint1: NSPoint(x: 21.5, y: 17),
                           controlPoint2: NSPoint(x: 21.5, y: 14.5))
                arrow.stroke()
            } else {
                body.lineWidth = 1.4
                body.stroke()
                lens.lineWidth = 1.4
                lens.stroke()

                drawG(at: NSPoint(x: 1, y: 4), fontSize: 8, weight: .semibold)
            }

            return true
        }
        image.isTemplate = true
        return image
    }
}
