import UIKit

extension UIImage {
    /// Returns the UIColor of the pixel at the given point (in image coordinates)
    func color(at point: CGPoint) -> UIColor? {
        guard let cgImage = self.cgImage,
              let dataProvider = cgImage.dataProvider,
              let pixelData = dataProvider.data else { return nil }

        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let bytesPerPixel = 4
        let bytesPerRow = cgImage.bytesPerRow
        let x = Int(point.x)
        let y = Int(point.y)

        guard x >= 0, y >= 0,
              x < cgImage.width, y < cgImage.height else { return nil }

        let pixelIndex = (y * bytesPerRow) + (x * bytesPerPixel)
        let r = CGFloat(data[pixelIndex]) / 255.0
        let g = CGFloat(data[pixelIndex + 1]) / 255.0
        let b = CGFloat(data[pixelIndex + 2]) / 255.0
        let a = CGFloat(data[pixelIndex + 3]) / 255.0

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
