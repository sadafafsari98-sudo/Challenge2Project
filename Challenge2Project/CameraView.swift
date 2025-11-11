//
//  CameraView.swift
//  Challenge2Project
//
//  Created by Sadaf Afsari on 10/11/25.
//

import SwiftUI
import AVFoundation

// MARK: - SwiftUI Wrapper for UIKit Camera
struct CameraView: UIViewControllerRepresentable {
    
    // This function creates the UIKit camera controller
    func makeUIViewController(context: Context) -> CameraViewController {
        return CameraViewController()
    }

    // This function keeps SwiftUI updated if needed (we don’t need updates now)
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        // Nothing here yet — the camera runs automatically
    }
}

// MARK: - UIKit View Controller for Camera
final class CameraViewController: UIViewController {
    // AVCaptureSession controls camera input/output
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    private func setupCamera() {
        // 1️⃣ Configure the session for video
        captureSession.sessionPreset = .photo

        // 2️⃣ Choose the default back camera
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: .back) else {
            print("⚠️ No camera available")
            return
        }

        // 3️⃣ Create camera input
        guard let input = try? AVCaptureDeviceInput(device: camera) else {
            print("⚠️ Cannot access camera input")
            return
        }

        // 4️⃣ Add input to the session
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }

        // 5️⃣ Create a preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill // fills screen nicely
        previewLayer.frame = view.layer.bounds

        // 6️⃣ Add preview layer to the view
        view.layer.addSublayer(previewLayer)

        // 7️⃣ Start camera
        captureSession.startRunning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update layer size when device rotates
        previewLayer.frame = view.bounds
    }
}
