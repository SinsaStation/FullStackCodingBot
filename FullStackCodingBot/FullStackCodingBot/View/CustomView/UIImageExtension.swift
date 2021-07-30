import UIKit

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        
        let extentVector = CIVector(x: inputImage.extent.size.width * 0.1,
                                    y: inputImage.extent.size.height * 0.1,
                                    z: inputImage.extent.size.width * 0.9,
                                    w: inputImage.extent.size.height * 0.9)
        let averageKey = "CIAreaAverage"
        let filterParameters = [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]
        
        guard let filter = CIFilter(name: averageKey, parameters: filterParameters),
              let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)
        
        let rgbs = bitmap.map { CGFloat($0) / 255 }
        let average = rgbs.dropLast().reduce(0, +) / 3
        let brightenedRgbs = average < 0.4 ? rgbs.map { $0 + 0.2 } : rgbs
        let color = UIColor(red: brightenedRgbs[0], green: brightenedRgbs[1], blue: brightenedRgbs[2], alpha: 1)
        return color
    }
}
