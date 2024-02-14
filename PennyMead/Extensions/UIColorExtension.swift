//
//  UIColorExtension.swift
//  PennyMead
//
//  Created by siddappa tambakad on 13/02/24.
//

import Foundation
import UIKit
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIColor {
  struct MyTheme {
    static var headerColor: UIColor  { return UIColor.init(hexString: "#454545") }
      static var whiteColor: UIColor  { return UIColor.init(hexString: "#ffffff") }
      static var brandingColor: UIColor  { return UIColor.init(hexString: "#873900") }
      static var brandingColorGradient: UIColor  { return UIColor.init(hexString: "#B14B00") }
      static var cardBGColor: UIColor { return UIColor.init(hexString: "#FFF8F2")}
  }
}
