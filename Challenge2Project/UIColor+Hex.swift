//
//  UIColor+Hex.swift
//  Challenge2Project
//
//  Created by Sadaf Afsari on 11/11/25.
//

import Foundation
import UIKit
import SwiftUI

extension UIColor {

    // Safely extract RGBA components, even from extended color spaces
    fileprivate func rgbaComponents() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0

        // Try the simple method first
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r,g,b,a)
        }

        // Fallback: use CIColor to extract RGB values
        let cgColorSpaceRGB = CGColorSpaceCreateDeviceRGB()
        if let converted = self.cgColor.converted(to: cgColorSpaceRGB, intent: .defaultIntent, options: nil) {
            let ciColor = CIColor(cgColor: converted)
            return (ciColor.red, ciColor.green, ciColor.blue, ciColor.alpha)
        }

        // If everything fails
        return nil
    }

    /// Convert UIColor → "#RRGGBB"
    func toHexString(includeHash: Bool = true) -> String? {
        guard let c = rgbaComponents() else { return nil }
        let r = Int(round(c.r * 255))
        let g = Int(round(c.g * 255))
        let b = Int(round(c.b * 255))
        let prefix = includeHash ? "#" : ""
        return String(format: "\(prefix)%02X%02X%02X", r, g, b)
    }

    /// Convert UIColor → "RGB(255, 0, 0)"
    func rgbString() -> String {
        guard let c = rgbaComponents() else { return "RGB(--,--,--)" }
        let r = Int(round(c.r * 255))
        let g = Int(round(c.g * 255))
        let b = Int(round(c.b * 255))
        return "RGB(\(r), \(g), \(b))"
    }
}
func generatePalette(from base: Color) -> [Color] {
    // Convert SwiftUI Color → UIColor to adjust brightness
    let ui = UIColor(base)

    var hue: CGFloat = 0, sat: CGFloat = 0, bri: CGFloat = 0, alpha: CGFloat = 0
    ui.getHue(&hue, saturation: &sat, brightness: &bri, alpha: &alpha)

    // lighter and darker variants by adjusting brightness
    let lighter = Color(hue: Double(hue),
                        saturation: Double(sat * 0.8),
                        brightness: Double(min(bri * 1.3, 1.0)))

    let darker = Color(hue: Double(hue),
                       saturation: Double(sat * 1.1),
                       brightness: Double(max(bri * 0.7, 0)))

    return [lighter, base, darker]
}
