import UIKit

extension UIFont {
    private class FontClass {}

    convenience init(tmdbFont: TMDBFont) {
        do {
            try FontLoader.registerFonts(in: Bundle(for: FontClass.self))
        } catch let error {
            fatalError("Failed loading fonts error \(error)")
        }
        let fontStyle = tmdbFont.fontStyle
        let descriptor = UIFontDescriptor(name: fontStyle.fontName.rawValue, size: CGFloat(fontStyle.fontSize.rawValue))
        self.init(descriptor: descriptor, size: CGFloat(fontStyle.fontSize.rawValue))
    }
}
