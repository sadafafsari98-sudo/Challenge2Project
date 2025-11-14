import SwiftUI
import UIKit  // for UIImage type used in @State

struct ContentView: View {
    // MARK: - State
    @State private var tapLocation: CGPoint? = nil
    @State private var showCursor: Bool = false
    @State private var colorHex: String = "--"
    @State private var colorRGB: String = "RGB(--,--,--)"
    @State private var latestFrame: UIImage? = nil  // receives frames from CameraView
    @State private var savedPalettes: [[Color]] = []  // array of 3-color palettes
    @State private var currentPalette: [Color] = []  // preview of the last generated palette
    @State private var showingPaletteModal = false
    
    var body: some View {
        VStack(spacing: 12) {
            // Title
            Text("Live Camera View")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Color info bar (above camera)
            HStack(spacing: 16) {
                // Left color square
                Rectangle()
                    .fill(Color(hex: colorHex) ?? Color.black)
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black.opacity(0.1), lineWidth: 1)
                    )
                
                // Right text
                VStack(alignment: .leading, spacing: 4) {
                    Text(colorRGB)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(colorHex)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                SwiftUICore.Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
            )
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 8)
            .sheet(isPresented: $showingPaletteModal) {
                PaletteGeneratedModal(palette: currentPalette)
                
                SwiftUICore.Spacer()
                
                
            }
            .frame(height: 80)
            .frame(width: 380)
            .cornerRadius(12)
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            // Camera + overlay
            GeometryReader { geo in
                ZStack {
                    // A) Live camera on device; placeholder in preview/simulator
#if targetEnvironment(simulator)
                    Rectangle()
                        .fill(Color.gray.opacity(0.25))
                        .overlay(
                            Text(
                                "Camera unavailable in Simulator/Preview"
                            )
                            .foregroundStyle(.gray)
                            .padding()
                        )
#else
                    CameraView(onFrameCaptured: { image in
                        // Store the latest frame for later color sampling
                        latestFrame = image
                    })
#endif
                    
                    // B) Tap-capture transparent layer
                    Color.clear
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onEnded { value in
                                    // 1️⃣ Get tap position in the view
                                    let local = value.location
                                    
                                    // 2️⃣ Clamp to view bounds to avoid out-of-range coordinates
                                    let clampedPoint = CGPoint(
                                        x: max(
                                            0,
                                            min(local.x, geo.size.width)
                                        ),
                                        y: max(
                                            0,
                                            min(local.y, geo.size.height)
                                        )
                                    )
                                    
                                    // 3️⃣ Update state for cursor
                                    tapLocation = clampedPoint
                                    showCursor = true
                                    
                                    // 4️⃣ Try to get color from the latest camera frame
                                    if let image = latestFrame {
                                        // Convert from SwiftUI view coordinates to image pixel coordinates
                                        let viewSize = geo.size
                                        let imageSize = image.size
                                        let scaleX =
                                        imageSize.width / viewSize.width
                                        let scaleY =
                                        imageSize.height
                                        / viewSize.height
                                        let imagePoint = CGPoint(
                                            x: clampedPoint.x * scaleX,
                                            y: clampedPoint.y * scaleY
                                        )
                                        
                                        // 5️⃣ Read pixel color at that point
                                        if let uiColor = image.color(
                                            at: imagePoint
                                        ) {
                                            colorHex =
                                            uiColor.toHexString()
                                            ?? "--"
                                            colorRGB = uiColor.rgbString()
                                        } else {
                                            colorHex = "--"
                                            colorRGB = "No color"
                                        }
                                    } else {
                                        colorHex = "--"
                                        colorRGB = "No frame"
                                    }
                                }
                        )
                    
                    // C) Cursor
                    if showCursor, let p = tapLocation {
                        CursorView()
                            .position(p)
                            .allowsHitTesting(false)
                            .animation(.easeOut(duration: 0.15), value: p)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .aspectRatio(3 / 4, contentMode: .fit)
            .padding(.horizontal)
            if !currentPalette.isEmpty {
                HStack(spacing: 0) {
                    ForEach(0..<currentPalette.count, id: \.self) { i in
                        currentPalette[i]
                    }
                }
                .frame(height: 60)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom, 8)
                .onTapGesture {
                    showingPaletteModal = true  // 👈 open modal
                }
            }
        }
        
        Spacer()
        
        // Bottom button (placeholder action)
        Button(action: {
            // 1️⃣ Make sure there’s a valid color from the camera
            guard let base = Color(hex: colorHex) else { return }
            
            // 2️⃣ Generate a 3-color palette: lighter, base, darker
            let palette = generatePalette(from: base)
            
            // 3️⃣ Save it to your stored list
            savedPalettes.append(palette)
            currentPalette = palette
            
            print("✅ Palette saved! Total palettes: \(savedPalettes.count)")
        }) {
            Text("Generate!")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom, 20)
            
        }
    }
}

#Preview {
    ContentView()
}
