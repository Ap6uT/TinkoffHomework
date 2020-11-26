//
//  EmitterLogoView.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 23.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addEmitter() {
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(touchedScreen(_:)))
        longTap.minimumPressDuration = 0.25
        view.addGestureRecognizer(longTap)
    }
    
    private func startEmitter(in point: CGPoint) {
        if let emitter = getEmitter() {
            emitter.emitterPosition = point
            emitter.lifetime = 1.0
        } else {
            let logoCell = CAEmitterCell()
            logoCell.contents = UIImage(named: "Logo")?.cgImage
            logoCell.scale = 0.009
            logoCell.scaleRange = 0.03
            logoCell.emissionRange = .pi
            logoCell.lifetime = 10.0
            logoCell.birthRate = 2
            logoCell.velocity = 25
            logoCell.velocityRange = 50
            logoCell.yAcceleration = -30
            logoCell.xAcceleration = 12
            logoCell.spin = -0.5
            logoCell.spinRange = 1.0
            
            let logoLayer = CAEmitterLayer()
            logoLayer.emitterPosition = point
            logoLayer.emitterSize = CGSize(width: 0, height: 0)
            logoLayer.emitterShape = CAEmitterLayerEmitterShape.line
            logoLayer.beginTime = CACurrentMediaTime()
            logoLayer.timeOffset = CFTimeInterval(arc4random_uniform(6) + 5)
            logoLayer.emitterCells = [logoCell]
            view.layer.addSublayer(logoLayer)
        }
    }
    
    private func stopEmitter() {
        if let emitter = getEmitter() {
            emitter.lifetime = 0.0
        }
    }
    
    private func getEmitter() -> CAEmitterLayer? {
        if let sublayers = self.view.layer.sublayers {
            for layer in sublayers where layer is CAEmitterLayer {
                return layer as? CAEmitterLayer
            }
        }
        return nil
    }
    
    @objc private func touchedScreen(_ touch: UILongPressGestureRecognizer) {
        if touch.state == .began {
            let touchPoint = touch.location(in: self.view)
            startEmitter(in: touchPoint)
        } else if touch.state == .ended {
            stopEmitter()
        } else if touch.state == .changed {
            let touchPoint = touch.location(in: self.view)
            startEmitter(in: touchPoint)
        }
    }
}
