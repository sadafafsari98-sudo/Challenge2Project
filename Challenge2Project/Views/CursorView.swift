//
//  CursorView.swift
//  Challenge2Project
//
//  Created by Sadaf Afsari on 14/11/25.
//

import SwiftUI

struct CursorView: View {
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [4, 3]))
                .foregroundStyle(.white.opacity(0.9))
                .frame(width: 36, height: 36)

            Circle()
                .fill(.white)
                .frame(width: 6, height: 6)
                .shadow(radius: 1)
        }
    }
}
