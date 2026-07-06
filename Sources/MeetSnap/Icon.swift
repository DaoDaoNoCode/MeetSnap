import Cocoa

enum Icon {
    private static let activeImage: NSImage = render(active: true)
    private static let inactiveImage: NSImage = render(active: false)

    static func make(active: Bool) -> NSImage {
        active ? activeImage : inactiveImage
    }

    private static func render(active: Bool) -> NSImage {
        let size = NSSize(width: 18, height: 18)
        let image = NSImage(size: size, flipped: true) { _ in
            NSColor.black.setFill()
            NSColor.black.setStroke()

            let body = NSBezierPath(
                roundedRect: NSRect(x: 1, y: 5, width: 10, height: 8),
                xRadius: 1.5, yRadius: 1.5
            )

            let lens = NSBezierPath()
            lens.move(to: NSPoint(x: 12.5, y: 6.5))
            lens.line(to: NSPoint(x: 16.5, y: 4.5))
            lens.line(to: NSPoint(x: 16.5, y: 13.5))
            lens.line(to: NSPoint(x: 12.5, y: 11.5))
            lens.close()
            lens.lineJoinStyle = .round

            if active {
                body.fill()
                lens.fill()
            } else {
                body.lineWidth = 1.2
                body.stroke()
                lens.lineWidth = 1.2
                lens.stroke()
            }

            return true
        }
        image.isTemplate = true
        return image
    }
}
