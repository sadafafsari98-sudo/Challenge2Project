//
//  CameraView.swift
//  Challenge2Project
//
//  Created by Sadaf Afsari on 10/11/25.
//

import SwiftUI
import AVFoundation

import SwiftUI
import AVFoundation
import UIKit


// MARK: - SwiftUI Wrapper
struct CameraView: UIViewControllerRepresentable {
    // Callback closure to deliver a new video frame image to SwiftUI
    var onFrameCaptured: ((UIImage) -> Void)?

    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) { }

    func makeCoordinator() -> CameraViewCoordinator {
        CameraViewCoordinator(onFrameCaptured: onFrameCaptured)
    }
}

// MARK: - Coordinator
final class CameraViewCoordinator: NSObject, CameraViewControllerDelegate {
    var onFrameCaptured: ((UIImage) -> Void)?

    init(onFrameCaptured: ((UIImage) -> Void)?) {
        self.onFrameCaptured = onFrameCaptured
    }

    func cameraViewController(_ controller: CameraViewController, didCapture frame: UIImage) {
        onFrameCaptured?(frame)
    }
}

// MARK: - Delegate Protocol
protocol CameraViewControllerDelegate: AnyObject {
    func cameraViewController(_ controller: CameraViewController, didCapture frame: UIImage)
}

// MARK: - UIKit Camera Controller
final class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    weak var delegate: CameraViewControllerDelegate?

    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private let videoOutput = AVCaptureVideoDataOutput()
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    private func setupCamera() {
        captureSession.sessionPreset = .medium

        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: .back),
              let input = try? AVCaptureDeviceInput(device: camera)
        else { return }

        if captureSession.canAddInput(input) { captureSession.addInput(input) }

        // video output to get frames
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
            videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)

        sessionQueue.async {
            self.captureSession.startRunning()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }

    // delegate method called every frame
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {

        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        // Convert CVImageBuffer → UIImage
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext()
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            // Send back to SwiftUI (on main thread)
            DispatchQueue.main.async {
                self.delegate?.cameraViewController(self, didCapture: uiImage)
            }
        }
    }
}
