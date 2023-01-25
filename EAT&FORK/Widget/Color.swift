//
//  Color.swift
//  EAT&FORK
//
//  Created by MacbookAir M1 FoodStory on 25/1/2566 BE.
//

import Foundation
import UIKit

class HexColor {
    class func color(hex: String) -> UIColor {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbColorValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbColorValue)
        
        let r = (rgbColorValue & 0xff0000) >> 16
        let g = (rgbColorValue & 0xff00) >> 8
        let b = rgbColorValue & 0xff
        
        return UIColor(red: CGFloat(r) / 0xff,
                       green: CGFloat(g) / 0xff,
                       blue: CGFloat(b) / 0xff, alpha: 1)
    }
}
