import UIKit

public enum FontLoaderError: Error {
    case fontLoadingFailed(fontPath: String)
}

/// Responsible for loading custom fonts
public enum FontLoader {

    private static var loadedBundleURLs = Set<URL>()

    /// All fonts files in the given bundle are loaded (currently ttf and otf)
    ///
    /// - Parameter bundle: The bundle that contains the font resource files
    public static func registerFonts(`in` bundle: Bundle) throws {
        guard !loadedBundleURLs.contains(bundle.bundleURL) else {
            return
        }
        let fontExtensions: [String] = ["ttf", "otf"]

        for fontExtension in fontExtensions {
            let paths = bundle.paths(forResourcesOfType: fontExtension, inDirectory: nil)
            for path in paths {
                let fileURL = URL(fileURLWithPath: path)
                let fontData = NSData(contentsOf: fileURL)!
                if let dataProvider = CGDataProvider(data: fontData), let cgFont = CGFont(dataProvider) {
                    var error: Unmanaged<CFError>?
                    if !CTFontManagerRegisterGraphicsFont(cgFont, &error) {
                        throw FontLoaderError.fontLoadingFailed(fontPath: path)
                    }
                }
            }
            self.loadedBundleURLs.insert(bundle.bundleURL)
        }
    }
}
