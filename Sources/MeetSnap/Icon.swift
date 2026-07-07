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

    private static func drawArrow(lineWidth: CGFloat) {
        let shaftY: CGFloat = 19
        let tailY: CGFloat = 15
        let turnX: CGFloat = 18
        let bulge: CGFloat = 3.5

        let arrow = NSBezierPath()
        arrow.lineWidth = lineWidth
        arrow.lineCapStyle = .round
        arrow.lineJoinStyle = .round

        arrow.move(to: NSPoint(x: 10, y: shaftY))
        arrow.line(to: NSPoint(x: turnX, y: shaftY))
        arrow.curve(to: NSPoint(x: turnX, y: tailY),
                   controlPoint1: NSPoint(x: turnX + bulge, y: shaftY),
                   controlPoint2: NSPoint(x: turnX + bulge, y: tailY))
        arrow.line(to: NSPoint(x: 14.5, y: tailY))

        arrow.stroke()

        // Arrowhead
        let head = NSBezierPath()
        head.lineWidth = lineWidth
        head.lineCapStyle = .round
        head.lineJoinStyle = .round
        head.move(to: NSPoint(x: 12.5, y: 17))
        head.line(to: NSPoint(x: 10, y: shaftY))
        head.line(to: NSPoint(x: 12.5, y: 21))
        head.stroke()
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

            if filled {
                body.fill()
                lens.fill()

                let ctx = NSGraphicsContext.current!
                ctx.compositingOperation = .destinationOut
                drawG(at: NSPoint(x: 1, y: 3), fontSize: 8, weight: .bold)
                ctx.compositingOperation = .sourceOver

                drawArrow(lineWidth: 1.5)
            } else {
                body.lineWidth = 1.4
                body.stroke()
                lens.lineWidth = 1.4
                lens.stroke()

                drawG(at: NSPoint(x: 1, y: 3), fontSize: 8, weight: .bold)
                drawArrow(lineWidth: 1.4)
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
