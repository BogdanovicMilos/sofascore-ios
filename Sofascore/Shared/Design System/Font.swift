//
//  Font.swift
//  Sofascore
//
//  Created by Milos Bogdanovic on 10/15/23.
//

import Foundation
import UIKit

enum FontFamily: String, CaseIterable {
    case helvetica = "Helvetica"
}

enum FontStyle: String, CaseIterable {
    case regular = "Regular"
    case light = "Light"
    case extraLight = "ExtraLight"
    case medium = "Medium"
    case bold = "Bold"
    case extraBold = "ExtraBold"
    case black = "Black"
}

enum FontSize: CGFloat, CaseIterable {
    case largeTitle = 34
    case title1 = 28
    case title2 = 22
    case title3 = 20
    case body = 17
    case callout = 16
    case subheadline = 15
    case footnote = 13
    case caption1 = 12
    case caption2 = 11
    case m = 4
}

extension UIFont {
    static func custom(family: FontFamily = .helvetica, style: FontStyle = .regular, ofSize size: FontSize) -> UIFont {
        let name = String(format: "%@-%@", family.rawValue, style.rawValue)
        return UIFont(name: name, size: size.rawValue) ?? .systemFont(ofSize: size.rawValue)
    }
}
