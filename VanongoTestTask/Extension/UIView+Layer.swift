//
//  UIView+RoundCorners.swift
//  VanongoTestTask
//
//  Created by Maria Ugorets on 01.09.2021.
//

import UIKit

extension UIView {
    func setRoundCorners() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    func animateBorderColor(toColor: UIColor, duration: Double) {
        let animation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = layer.borderColor
        animation.toValue = toColor.cgColor
        animation.duration = duration
        animation.autoreverses = true
        layer.add(animation, forKey: "borderColor")
    }
}
