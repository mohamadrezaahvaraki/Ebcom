//Created for Ebcom in 2024
// Using Swift 5.0

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
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
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

enum FontModel {
    case regular(size: CGFloat)
    
    private var familyName: String { "BYekan" }
    
    private var name: String {
        switch self {
        case .regular: return familyName
        }
    }
    
    private var size: CGFloat {
        switch self {
        case let .regular(size): return size
        }
    }
    
    func evaluate<Result>(_ setup: (String, CGFloat) -> Result) -> Result {
        setup(name, size)
    }
}

public enum AppFont: String {
    case title
    case body
    case buttonTitle
}

extension AppFont {
    
    private var font: FontModel {
        switch self {
        case .title: return .regular(size: 16)
        case .body: return .regular(size: 14)
        case .buttonTitle: return .regular(size: 22)
        }
    }
    
    var suFont: Font {
        font.evaluate(Font.custom(_:size:))
    }
}

extension Font {
    public static func get(_ fontDecor: AppFont) -> Font {
        fontDecor.suFont
    }
}
