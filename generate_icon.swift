#!/usr/bin/env swift
import Cocoa

let size = 1024
let nsSize = NSSize(width: size, height: size)

let rep = NSBitmapImageRep(
    bitmapDataPlanes: nil,
    pixelsWide: size,
    pixelsHigh: size,
    bitsPerSample: 8,
    samplesPerPixel: 4,
    hasAlpha: true,
    isPlanar: false,
    colorSpaceName: .deviceRGB,
    bytesPerRow: 0,
    bitsPerPixel: 0
)!

NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)!

// --- Rice paper background ---
let paperLight = NSColor(red: 0.953, green: 0.937, blue: 0.910, alpha: 1.0)
let paperWarm = NSColor(red: 0.925, green: 0.902, blue: 0.867, alpha: 1.0)
NSGradient(starting: paperLight, ending: paperWarm)!
    .draw(in: NSRect(origin: .zero, size: nsSize), angle: 90)

// --- Distant mountains (faint, upper area) ---
let distantMist = NSColor(red: 0.65, green: 0.63, blue: 0.60, alpha: 0.10)
let distant = NSBezierPath()
distant.move(to: NSPoint(x: 0, y: 500))
distant.curve(to: NSPoint(x: 250, y: 720),
              controlPoint1: NSPoint(x: 60, y: 550),
              controlPoint2: NSPoint(x: 150, y: 740))
distant.curve(to: NSPoint(x: 500, y: 640),
              controlPoint1: NSPoint(x: 350, y: 700),
              controlPoint2: NSPoint(x: 430, y: 630))
distant.curve(to: NSPoint(x: 750, y: 760),
              controlPoint1: NSPoint(x: 580, y: 650),
              controlPoint2: NSPoint(x: 680, y: 780))
distant.curve(to: NSPoint(x: 1024, y: 600),
              controlPoint1: NSPoint(x: 850, y: 730),
              controlPoint2: NSPoint(x: 960, y: 620))
distant.line(to: NSPoint(x: 1024, y: 1024))
distant.line(to: NSPoint(x: 0, y: 1024))
distant.close()
distantMist.setFill()
distant.fill()

// --- Mid mountains (slightly more visible) ---
let midMist = NSColor(red: 0.58, green: 0.56, blue: 0.53, alpha: 0.10)
let mid = NSBezierPath()
mid.move(to: NSPoint(x: 0, y: 420))
mid.curve(to: NSPoint(x: 300, y: 580),
          controlPoint1: NSPoint(x: 80, y: 440),
          controlPoint2: NSPoint(x: 180, y: 600))
mid.curve(to: NSPoint(x: 550, y: 510),
          controlPoint1: NSPoint(x: 390, y: 560),
          controlPoint2: NSPoint(x: 470, y: 500))
mid.curve(to: NSPoint(x: 800, y: 620),
          controlPoint1: NSPoint(x: 640, y: 520),
          controlPoint2: NSPoint(x: 740, y: 640))
mid.curve(to: NSPoint(x: 1024, y: 480),
          controlPoint1: NSPoint(x: 880, y: 600),
          controlPoint2: NSPoint(x: 970, y: 500))
mid.line(to: NSPoint(x: 1024, y: 1024))
mid.line(to: NSPoint(x: 0, y: 1024))
mid.close()
midMist.setFill()
mid.fill()

// --- Near mountains (foreground, bottom area) ---
let nearMist = NSColor(red: 0.50, green: 0.48, blue: 0.45, alpha: 0.09)
let near = NSBezierPath()
near.move(to: NSPoint(x: 0, y: 280))
near.curve(to: NSPoint(x: 200, y: 400),
           controlPoint1: NSPoint(x: 50, y: 300),
           controlPoint2: NSPoint(x: 120, y: 420))
near.curve(to: NSPoint(x: 450, y: 340),
           controlPoint1: NSPoint(x: 280, y: 380),
           controlPoint2: NSPoint(x: 370, y: 330))
near.curve(to: NSPoint(x: 700, y: 430),
           controlPoint1: NSPoint(x: 530, y: 350),
           controlPoint2: NSPoint(x: 640, y: 450))
near.curve(to: NSPoint(x: 1024, y: 320),
           controlPoint1: NSPoint(x: 800, y: 410),
           controlPoint2: NSPoint(x: 930, y: 340))
near.line(to: NSPoint(x: 1024, y: 1024))
near.line(to: NSPoint(x: 0, y: 1024))
near.close()
nearMist.setFill()
near.fill()

// --- Camera shape in ink ---
let shadow = NSShadow()
shadow.shadowOffset = NSSize(width: 0, height: -3)
shadow.shadowBlurRadius = 20
shadow.shadowColor = NSColor(red: 0.1, green: 0.1, blue: 0.08, alpha: 0.25)
shadow.set()

let ink = NSColor(red: 0.14, green: 0.13, blue: 0.12, alpha: 0.85)
ink.setFill()

let body = NSBezierPath(
    roundedRect: NSRect(x: 187, y: 344, width: 420, height: 336),
    xRadius: 63, yRadius: 63
)
body.fill()

let lens = NSBezierPath()
lens.move(to: NSPoint(x: 670, y: 407))
lens.line(to: NSPoint(x: 838, y: 323))
lens.line(to: NSPoint(x: 838, y: 701))
lens.line(to: NSPoint(x: 670, y: 617))
lens.close()
lens.fill()

NSGraphicsContext.restoreGraphicsState()

let outputDir = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "."
let pngData = rep.representation(using: .png, properties: [:])!
try! pngData.write(to: URL(fileURLWithPath: "\(outputDir)/icon_1024.png"))
print("Generated icon_1024.png")
