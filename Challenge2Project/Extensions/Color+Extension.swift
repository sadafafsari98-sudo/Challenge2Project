//
//  Color+Extension.swift
//  Challenge2Project
//
//  Created by Sadaf Afsari on 14/11/25.
//

import SwiftUI

extension Color {
    /// Create a SwiftUI Color from a 6-char hex string like "FF0000" or "#FF0000".
    /// Returns nil if the string isn't exactly 6 hex digits (RGB).
    init?(hex: String) {
        // Remove non-hex characters like "#", spaces, etc.
        let hexSanitized = hex.trimmingCharacters(
            in: CharacterSet.alphanumerics.inverted
        )

        // Accept 6-digit RGB only for simplicity
        guard hexSanitized.count == 6 else { return nil }

        var int: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&int)

        let r = Double((int >> 16) & 0xFF) / 255.0
        let g = Double((int >> 8) & 0xFF) / 255.0
        let b = Double(int & 0xFF) / 255.0

        self = Color(red: r, green: g, blue: b)
    }
}
