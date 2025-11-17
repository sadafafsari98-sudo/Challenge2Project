#  Live Camera Color Picker

A minimal SwiftUI + AVFoundation application that allows you to detect colors in real-time using your iPhone camera, extract precise **RGB & HEX values**, and automatically **generate color palettes**. 
Designed with clean UI principles and built to be simple, fast, and useful for designers, developers, and artists.


##  Features

###  Real-time Color Detection
- Live camera feed using AVFoundation  
- Tap anywhere on the preview to pick a color  
- A visible cursor shows the exact sampled point  
- Instant color detection with:
  - RGB code  
  - HEX code  

###  Color Info Panel
After detecting a color, you instantly see:
- Color swatch  
- RGB values  
- HEX code  

###  Automatic Palette Generation
Press **Save** to generate a palette:
- Base color  
- Lighter variant  
- Darker variant  
- Computed using HSB color adjustments

###  Palette Preview & Modal
- A slim palette bar appears under the camera  
- Tap the palette to open a modal showing:
  - Full palette vertically  
  - Back to Camera button  

---

## Technology Stack

### **SwiftUI**
- UI layout  
- State management  
- Modal sheets  
- Gestures  

### **AVFoundation**
- Camera capture session  
- Pixel buffer processing  
- Real-time frame extraction  

### **UIKit Interop**
- `UIViewControllerRepresentable`  
- `AVCaptureVideoPreviewLayer`  

### **Extensions**
- `UIImage.color(at:)`  
- `UIColor.rgbString()`  
- `UIColor.toHexString()`  
- `Color(hex:)`  

---

## App Architecture

ContentView
├── Title
├── Color Info Bar (RGB + HEX)
├── CameraView (real-time camera feed)
├── Cursor overlay
├── Palette preview bar
└── Generate button → generate palette + open modal

PaletteGeneratedModal
├── Palette swatches
├── RGB codes
└── Back to Camera

---

##  How It Works

1. The camera outputs frames continuously.
2. Frames are converted to `UIImage`.
3. User taps → view coordinates are mapped to image coordinates.
4. Pixel color is extracted.
5. RGB + HEX values update instantly.
6. Pressing **Generate** generates a palette.
7. Palette modal allows:
   - Viewing
   - Returning to camera

---

##  Requirements

- iOS 15+  
- Swift 5.7+  
- Xcode 14+  
- Real device (camera not available in preview)  

---

##  Learning Outcomes From This Project

### **Coding Skills**
- SwiftUI architecture  
- Gesture handling  
- State management  
- UIKit + SwiftUI bridging  
- AVFoundation camera pipeline  
- Working with background threads  
- Pixel color extraction  
- Writing clean helper functions & extensions  

### **Design Skills**
- Minimal UI layout  
- Color theory basics  
- Creating palettes  
- Left-aligned typography & spacing  
- Modal design and user flow  

---

##  Future Enhancements
- Named palette folders  
- Multiple palette types (analogous, triadic, complementary)    
- Full palette library screen  
- Sharing palettes to apps  

---
