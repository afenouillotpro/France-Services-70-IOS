//
//  FontDictionnary.swift
//  FS 70
//
//  Created by antoine fenouillot on 02/10/2024.
//
import UIKit

enum CustomFonts: String {
    //case lato = "Lato"
    //case openSans = "OpenSans"
    //case oswald = "Oswald"
    case roboto = "Roboto"
    //case tiltPrism = "TiltPrism"
}

enum CustomFontStyle: String {
    case bold = "-Bold"
    case light = "-Light"
    case medium = "-Medium"
    case regular = "-Regular"
    //case semiBold = "-SemiBold"
    case thin = "-Thin"
}

enum CustomFontSize: CGFloat {
    case h0 = 36.0
    case h1 = 32.0
    case h2 = 20.0
    case h3 = 16.0
    case h4 = 8.0
}

/*class FontDictionnary{
    var allFont: [String: [String: String]] = [:]
    static let fontDictionnary = FontDictionnary()
    private init(){
        FontDictionnary.fontDictionnary.allFont["robotoNormal1"] = ["name": "Roboto-Normal", "size": "16.0"]
        FontDictionnary.fontDictionnary.allFont["robotoBold1"] = ["name": "Roboto-Bold", "size": "16.0"]
    }
    
    func populate(key: String, customFonts: [String: String]){
        allFont[key]?["name"] = customFonts["name"]
        allFont[key]?["size"] = customFonts["size"]
    }

}
extension UILabel {
    @IBInspectable var style: String {
        set{
            self.font = UIFont(name: (FontDictionnary.fontDictionnary.allFont[newValue]?["name"] ?? "Roboto-Normal"), size: CGFloat(Double(FontDictionnary.fontDictionnary.allFont[newValue]?["size"] ?? "16.0") ?? CGFloat(16.0)))
        }
        get{
            return ""
        }
    }
}*/

extension UIFont {
    
    /// Choose your font to set up
    /// - Parameters:
    ///   - font: Choose one of your font
    ///   - style: Make sure the style is available
    ///   - size: Use prepared sizes for your app
    ///   - isScaled: Check if your app accessibility prepared
    /// - Returns: UIFont ready to show
    static func customFont(
        font: CustomFonts,
        style: CustomFontStyle,
        size: CustomFontSize,
        isScaled: Bool = true) -> UIFont {
            
            let fontName: String = font.rawValue + style.rawValue
            
            guard let font = UIFont(name: fontName, size: size.rawValue) else {
                debugPrint("Font can't be loaded")
                return UIFont.systemFont(ofSize: size.rawValue)
            }
            
            return isScaled ? UIFontMetrics.default.scaledFont(for: font) : font
        }
}
