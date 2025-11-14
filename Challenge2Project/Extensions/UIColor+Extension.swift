//
//  UIColor+Extension.swift
//  Challenge2Project
//
//  Created by Sadaf Afsari on 14/11/25.
//

import UIKit

extension UIColor {
        /// Convert UIColor to a hex string like "#RRGGBB"
        func toHex() -> String? {
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            guard self.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
            let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
            return String(format:"#%06x", rgb)
        }
        
        /// Returns a simple approximate name (red, blue, etc.)
        func basicName() -> String {
            var (r,g,b,a): (CGFloat,CGFloat,CGFloat,CGFloat) = (0,0,0,0)
            self.getRed(&r, green: &g, blue: &b, alpha: &a)
            
            // Simple nearest-color logic
            switch (r,g,b) {
            case let (r,g,b) where r > 0.7 && g < 0.3 && b < 0.3: return "Red"
            case let (r,g,b) where r < 0.3 && g > 0.7 && b < 0.3: return "Green"
            case let (r,g,b) where r < 0.3 && g < 0.3 && b > 0.7: return "Blue"
            case let (r,g,b) where r > 0.7 && g > 0.7 && b < 0.3: return "Yellow"
            case let (r,g,b) where r > 0.7 && g < 0.3 && b > 0.7: return "Magenta"
            case let (r,g,b) where r < 0.3 && g > 0.7 && b > 0.7: return "Cyan"
            case let (r,g,b) where r > 0.6 && g > 0.6 && b > 0.6: return "White"
            case let (r,g,b) where r < 0.4 && g < 0.4 && b < 0.4: return "Black"
            default: return "Unknown"
            }
        }
    }
