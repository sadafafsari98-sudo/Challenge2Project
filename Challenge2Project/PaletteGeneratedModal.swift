//
//  PaletteGeneratedModal.swift
//  Challenge2Project
//
//  Created by Sadaf Afsari on 13/11/25.
//

import Foundation
import SwiftUI
import UIKit

struct PaletteGeneratedModal: View {
    let palette: [Color]

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 24) {

            Text("Generated Palette")
                .font(.title2)
                .bold()
                .padding(.top, 20)

            ScrollView {
                VStack(spacing: 20) {
                    ForEach(0..<palette.count, id: \.self) { i in
                        let ui = UIColor(palette[i])

                        VStack(spacing: 6) {
                            palette[i]
                                .frame(height: 100)
                                .cornerRadius(12)

                            Text(ui.rgbString())
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        .padding(.horizontal)
                    }
                }
            }

            Spacer()

            // DOWNLOAD BUTTON
            /*Button(action: {
                if let image = paletteToImage(palette: palette) {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
            }) {
                Text("Download Palette")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }*/

            // BACK BUTTON
            Button("Back to Camera") {
                dismiss()
            }
            .font(.headline)
            .padding(.bottom, 20)
        }
        .presentationDetents([.medium, .large])
    }
}
