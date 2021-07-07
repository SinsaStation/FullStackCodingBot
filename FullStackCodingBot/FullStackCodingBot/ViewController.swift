//
//  ViewController.swift
//  FullStackCodingBot
//
//  Created by Song on 2021/07/05.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var perspectiveView: UnitPerspectiveView = {
        let view = UnitPerspectiveView()
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
    
    private let unitCount = 8
    private let allUnits = [Unit(image: .swift),
                            Unit(image: .kotlin),
                            Unit(image: .java),
                            Unit(image: .cPlusPlus)]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTempViews()
    }
    
    private func addTempViews() {
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        gameStart()
    }

    private func gameStart() {
        let startingUnits = generateStartingUnits(count: unitCount)
        perspectiveView.configure(with: startingUnits)
        perspectiveView.fillUnits()
    }
    
    @objc private func buttonAction(_ sender: UIButton) {
        perspectiveView.removeFirstUnit()
        perspectiveView.refillLastUnit(with: newRandomUnit())
        perspectiveView.fillUnits()
    }
    
    private func generateStartingUnits(count: Int) -> [Unit] {
        return (0..<count).map { allUnits[$0 % 4] }
    }
    
    private func newRandomUnit() -> Unit {
        return allUnits.randomElement()!
    }
}
