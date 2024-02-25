//
//  UIViewControllerExtension.swift
//  PennyMead
//
//  Created by siddappa tambakad on 13/02/24.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func showToast(message: String, font: UIFont) {
        let toastWidth: CGFloat = 350
        let toastLabel = UILabel(frame: CGRect(x: (self.view.frame.size.width - toastWidth) / 2, y: self.view.frame.size.height - 100, width: toastWidth, height: 50))
        toastLabel.backgroundColor = UIColor.MyTheme.brandingColor
        toastLabel.textColor = UIColor.MyTheme.cardBGColor
        toastLabel.font = font
        toastLabel.textAlignment = .center
        
        // Create attributed string
        let attributedString = NSMutableAttributedString(string: message)
        let range = (message as NSString).range(of: "View Details")
        attributedString.addAttribute(.foregroundColor, value: UIColor.MyTheme.cardBGColor, range: range)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        
        toastLabel.attributedText = attributedString
        
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 5
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        
        // Add tap gesture recognizer to the parent view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDetailsTapped))
        self.view.addGestureRecognizer(tapGesture)
        
        // Animation to hide the toast label
        UIView.animate(withDuration: 6, delay: 0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

    
    @objc func viewDetailsTapped() {
        // Handle tap on "View Details"
        // You can perform any action here, such as navigating to the details view
        print("View Details tapped")
    }
    
}

extension UIView
{
    func setGradient(startColor:UIColor,endColor:UIColor)
    {
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
    func clear() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}
//MARK: Converting html to normal string
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}
extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}

