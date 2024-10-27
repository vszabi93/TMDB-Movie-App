// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Rsc {
  internal enum Error {
    internal enum ErrorView {
      /// Unexpected error occured
      internal static let description = Rsc.tr("Error", "ErrorView.description", fallback: "Unexpected error occured")
      internal enum Button {
        /// OK
        internal static let title = Rsc.tr("Error", "ErrorView.button.title", fallback: "OK")
      }
    }
  }
  internal enum Movie {
    internal enum MovieDetails {
      internal enum Language {
        /// Language
        internal static let title = Rsc.tr("Movie", "MovieDetails.Language.title", fallback: "Language")
      }
      internal enum Rating {
        /// Rating
        internal static let title = Rsc.tr("Movie", "MovieDetails.Rating.title", fallback: "Rating")
      }
      internal enum Runtime {
        /// Runtime
        internal static let title = Rsc.tr("Movie", "MovieDetails.Runtime.title", fallback: "Runtime")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Rsc {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
