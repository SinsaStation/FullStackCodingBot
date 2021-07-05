//
//  UnitPerspectiveView.swift
//  FullStackCodingBot
//
//  Created by Song on 2021/07/05.
//

import UIKit

final class UnitPerspectiveView: UIView {
    
    private var unitLayers = [CALayer]()
    private var unitCount: Int?
    private lazy var maxSize = CGSize(width: frame.width * 0.8, height: frame.width * 0.6)
    private lazy var minSize = CGSize(width: frame.width * 0.1, height: frame.width * 0.075)
    
    func configure(with startingUnits: [Unit]) {
        self.unitCount = startingUnits.count
        
        startingUnits.forEach { unit in
            let imageName = unit.imageName
            self.unitLayers.append(newLayer(with: imageName))
        }
    }
    
    private func newLayer(with imageName: String) -> CALayer {
        let layer = CALayer()
        let logoImage = UIImage(named: imageName)?.cgImage
        layer.contents = logoImage
        layer.contentsGravity = .resizeAspect
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.gray.cgColor
        return layer
    }
    
    func fillUnits() {
        guard let unitCountInt = unitCount else { return }
        let unitCount = CGFloat(unitCountInt)
        
        unitLayers.enumerated().forEach { (order, layer) in
            let order = CGFloat(order)
            let layerSize = CGSize(width: maxSize.width - ((maxSize.width - minSize.width) / unitCount) * order,
                                   height: maxSize.height - ((maxSize.height - minSize.height) / unitCount) * order)
            let layerOrigin = CGPoint(x: (frame.width - layerSize.width) * 0.5,
                                      y: (frame.height / unitCount) * (unitCount-order) - layerSize.height)
            layer.frame = CGRect(origin: layerOrigin, size: layerSize)
            layer.zPosition = -order
            self.layer.addSublayer(layer)
        }
    }
    
    func removeFirstUnit() {
        unitLayers.forEach { layer in
            layer.removeFromSuperlayer()
        }
        unitLayers.remove(at: 0)
    }
    
    func refillLastUnit(with newUnit: Unit) {
        let imageName = newUnit.imageName
        unitLayers.append(newLayer(with: imageName))
    }
}
