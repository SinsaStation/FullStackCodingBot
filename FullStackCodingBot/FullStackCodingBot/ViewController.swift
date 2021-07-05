//
//  ViewController.swift
//  FullStackCodingBot
//
//  Created by Song on 2021/07/05.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var perspectiveView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tempButton: UIButton = {
        let button = UIButton()
        button.setTitle("넘기기", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var layers = [CALayer]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(perspectiveView)
        NSLayoutConstraint.activate([
            perspectiveView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            perspectiveView.heightAnchor.constraint(equalTo: perspectiveView.widthAnchor, multiplier: 1.5),
            perspectiveView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            perspectiveView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        view.addSubview(tempButton)
        NSLayoutConstraint.activate([
            tempButton.widthAnchor.constraint(equalToConstant: 100),
            tempButton.heightAnchor.constraint(equalToConstant: 50),
            tempButton.topAnchor.constraint(equalTo: perspectiveView.bottomAnchor, constant: 50),
            tempButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        
        
        for _ in 0..<Int(unitCount) {
            layers.append(newLayer())
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fillStartingUnits()
    }
    
    private func newLayer() -> CALayer {
        let layer = CALayer()
        layer.backgroundColor = UIColor.orange.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.gray.cgColor
        return layer
    }
    
    private let unitCount: CGFloat = 8
    private lazy var maxSize = CGSize(width: perspectiveView.frame.width * 0.8, height: perspectiveView.frame.width * 0.6)
    private lazy var minSize = CGSize(width: perspectiveView.frame.width * 0.1, height: perspectiveView.frame.width * 0.075)
    
    private func fillStartingUnits() {
        layers.enumerated().forEach { (order, layer) in
            let order = CGFloat(order)
            let layerSize = CGSize(width: maxSize.width - ((maxSize.width - minSize.width) / unitCount) * order,
                                   height: maxSize.height - ((maxSize.height - minSize.height) / unitCount) * order)
            let layerOrigin = CGPoint(x: (perspectiveView.frame.width - layerSize.width) * 0.5,
                                      y: (perspectiveView.frame.height / unitCount) * (unitCount-order) - layerSize.height)
            layer.frame = CGRect(origin: layerOrigin, size: layerSize)
            layer.zPosition = -order
            perspectiveView.layer.addSublayer(layer)
        }
    }
    
    @objc private func buttonAction(_ sender: UIButton) {
        removeFirstUnit()
        layers.append(newLayer())
        fillStartingUnits()
    }
    
    private func removeFirstUnit() {
        layers.forEach { layer in
            layer.removeFromSuperlayer()
        }
        layers.remove(at: 0)
    }
    
    private func refillLastUnit() {
        layers.append(newLayer())
    }
}
