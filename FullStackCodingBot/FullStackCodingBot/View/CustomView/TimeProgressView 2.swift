//
//  TimeProgressView.swift
//  FullStackCodingBot
//
//  Created by Song on 2021/07/09.
//

import UIKit

final class TimeProgressView: UIProgressView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let cornerRadius = self.bounds.height * 0.5
        let maskLayerPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskLayerPath.cgPath
        self.layer.mask = maskLayer
    }
}
