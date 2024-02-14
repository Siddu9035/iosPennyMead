//
//  GradientButton.swift
//  PennyMead
//
//  Created by siddappa tambakad on 22/01/24.
//

import Foundation
import UIKit

@IBDesignable
class GradientButton: UIButton {
    
    // Define the colors for the gradient
    @IBInspectable var startColor: UIColor = UIColor.red {
        didSet {
            updateGradient()
        }
    }
    @IBInspectable var endColor: UIColor = UIColor.yellow {
        didSet {
            updateGradient()
        }
    }
    // button corner radius
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
           self.layer.cornerRadius = cornerRadius
        }
    }
    // Create gradient layer
    let gradientLayer = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        // Set the gradient frame
        gradientLayer.frame = rect
        
        // Set the colors
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        
        // Gradient is linear from top to bottom
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        // Add gradient layer into the button
        layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

    }
    
    func updateGradient() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        layer.cornerRadius = cornerRadius
    }
}
