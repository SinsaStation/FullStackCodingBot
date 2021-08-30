import UIKit

extension UIColor {
    
    enum Blend {
        case brighten
        case normal
        case darken
        
        var weight: CGFloat {
            switch self {
            case .brighten:
                return 0.35
            case .normal:
                return 0.2
            case .darken:
                return 0
            }
        }
    }
    
    static func average(from image: UIImage?, blend: Blend = .normal) -> UIColor {
        let basicColor = UIColor.white
        
        guard let image = image,
              let inputImage = CIImage(image: image) else { return basicColor }
        
        let extentVector = CIVector(x: inputImage.extent.size.width * 0.1,
                                    y: inputImage.extent.size.height * 0.1,
                                    z: inputImage.extent.size.width * 0.9,
                                    w: inputImage.extent.size.height * 0.9)
        let averageKey = "CIAreaAverage"
        let filterParameters = [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]
        
        guard let filter = CIFilter(name: averageKey, parameters: filterParameters),
              let outputImage = filter.outputImage else { return basicColor }

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
        let brightenedRgbs = average < 0.4 ? rgbs.map { $0 + blend.weight } : rgbs
        let color = UIColor(red: brightenedRgbs[0], green: brightenedRgbs[1], blue: brightenedRgbs[2], alpha: 1)
        return color
    }
}
