//
//  Pallete.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 6/9/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import Foundation
import SwiftUI

struct Palette {
    /// A flat burnt red color.
    /// The current app theme.
    private static let cinnabar = Color(r: 231, g: 76, b: 60, a: 1)
    private static let black = Color(r: 0, g: 0, b: 0, a: 1)
    private static let white = Color(r: 248, g: 248, b: 248, a: 1)
    
    private static let pastelGreen = Color(r: 61, g: 165, b: 82, a: 1)
    private static let orange = Color(r: 249, g: 168, b: 117, a: 1)
    private static let beige = Color(r: 216, g: 210, b: 199, a: 1)
    
    static let primaryColor = pastelGreen //cinnabar
    static let secondaryColor = pastelGreen //cinnabar
    static var bgColor: Color {
        return Settings.darkMode ? black : white
    }
    static var tintColor: Color {
        return Settings.darkMode ? black : beige
    }
    static var textColor: Color {
        return Settings.darkMode ? white : black
    }
    static var textColorOnPrimaryColor: Color {
        return bgColor
    }
    static var navBarColor: Color {
        return Settings.darkMode ? bgColor : primaryColor
    }
}

extension Color {
    init(r: Double, g: Double, b: Double, a: Double) {
        self.init(.sRGB, red: r/255, green: g/255, blue: b/255, opacity: a)
    }
    
    /*
 
    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: abs(percentage))
    }
    
    /**
     Create a darker color
     */
    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: -abs(percentage))
    }
    
    /**
     Try to increase brightness or decrease saturation
     */
    func adjustBrightness(by percentage: CGFloat = 30.0) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            if b < 1.0 {
                /**
                 Below is the new part, which makes the code work with black as well as colors
                 */
                let newB: CGFloat
                if b == 0.0 {
                    newB = max(min(b + percentage/100, 1.0), 0.0)
                } else {
                    newB = max(min(b + (percentage/100.0)*b, 1.0), 0,0)
                }
                return UIColor(hue: h, saturation: s, brightness: newB, alpha: a)
            } else {
                let newS: CGFloat = min(max(s - (percentage/100.0)*s, 0.0), 1.0)
                return UIColor(hue: h, saturation: newS, brightness: b, alpha: a)
            }
        }
        return self
    }
     */
}
