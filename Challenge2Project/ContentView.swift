//
//  ContentView.swift
//  Challenge2Project
//
//  Created by Sadaf Afsari on 10/11/25.
//

import SwiftUI

// The main screen of our app
struct ContentView: View {
    var body: some View {
        VStack {
            // 1️⃣ Title at the top
            Text("Live Camera View")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)

            Spacer()  // pushes content toward top and bottom

            // 2️⃣ Placeholder for camera preview (we’ll replace this later)
            #if targetEnvironment(simulator)
                // Simulator or preview mode → show a placeholder
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Text("Camera unavailable in Preview")
                            .foregroundColor(.gray)
                    )
                    .aspectRatio(3 / 4, contentMode: .fit)
                    .cornerRadius(16)
                    .padding()
            #else
                // Real device → show live camera
                CameraView()
                    .aspectRatio(3 / 4, contentMode: .fit)
                    .cornerRadius(16)
                    .padding()
            #endif

            Spacer()

            // 3️⃣ Button at the bottom
            Button(action: {
                print("Button tapped!")
            }) {
                Text("Capture Color")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
            }
        }
        .background(Color.white)
        .padding(.bottom, 10)
    }
}

// Preview in Xcode’s canvas
#Preview {
    ContentView()
}
