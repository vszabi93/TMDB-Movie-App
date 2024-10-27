enum TMDBFontName: String {
    case robotoMedium = "Roboto-Medium",
    robotoRegular = "Roboto-Regular",
    robotoBold = "Roboto-Bold"
}

enum TMDBFontSize: Int {
    case small = 14,
         large = 20,
        extraLarge = 30
}

struct TMDBFontStyle {
    public let fontName: TMDBFontName
    public let fontSize: TMDBFontSize
}

enum TMDBFont {
    case
    extraLargeBold,
    large,
    largeBold,
    small,
    smallBold

    public var fontStyle: TMDBFontStyle {
        switch self {
        case .extraLargeBold: return TMDBFontStyle(fontName: .robotoBold, fontSize: .extraLarge)
        case .large: return TMDBFontStyle(fontName: .robotoRegular, fontSize: .large)
        case .largeBold: return TMDBFontStyle(fontName: .robotoBold, fontSize: .large)
        case .small: return TMDBFontStyle(fontName: .robotoRegular, fontSize: .small)
        case .smallBold: return TMDBFontStyle(fontName: .robotoBold, fontSize: .small)
        }
    }
}
