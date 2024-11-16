// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let accentColor = ColorAsset(name: "AccentColor")
  internal static let backgroundColor = ColorAsset(name: "backgroundColor")
  internal static let gray = ColorAsset(name: "gray")
  internal static let lightGray = ColorAsset(name: "lightGray")
  internal static let separatorColor = ColorAsset(name: "separatorColor")
  internal static let separatorColor2 = ColorAsset(name: "separatorColor2")
  internal static let textGray = ColorAsset(name: "textGray")
  internal static let vpnBackColor = ColorAsset(name: "vpnBackColor")
  internal static let back = ImageAsset(name: "back")
  internal static let chevronRight = ImageAsset(name: "chevron-right")
  internal static let dismiss = ImageAsset(name: "dismiss")
  internal static let logo = ImageAsset(name: "logo")
  internal static let dataCountryCode = ImageAsset(name: "data-country-code")
  internal static let dataIp = ImageAsset(name: "data-ip")
  internal static let dataLocation = ImageAsset(name: "data-location")
  internal static let dataPostalCode = ImageAsset(name: "data-postal-code")
  internal static let ca = ImageAsset(name: "CA")
  internal static let de = ImageAsset(name: "DE")
  internal static let gb = ImageAsset(name: "GB")
  internal static let jp = ImageAsset(name: "JP")
  internal static let mx = ImageAsset(name: "MX")
  internal static let maskGroup3 = ImageAsset(name: "Mask group-3")
  internal static let maskGroup4 = ImageAsset(name: "Mask group-4")
  internal static let maskGroup5 = ImageAsset(name: "Mask group-5")
  internal static let maskGroup6 = ImageAsset(name: "Mask group-6")
  internal static let maskGroup7 = ImageAsset(name: "Mask group-7")
  internal static let maskGroup8 = ImageAsset(name: "Mask group-8")
  internal static let sg = ImageAsset(name: "SG")
  internal static let sw = ImageAsset(name: "SW")
  internal static let us = ImageAsset(name: "US")
  internal static let locationsLock = ImageAsset(name: "locations-lock")
  internal static let locationsRadioEmpty = ImageAsset(name: "locations-radio-empty")
  internal static let locationsRadioSelect = ImageAsset(name: "locations-radio-select")
  internal static let onboardCheck = ImageAsset(name: "onboard-check")
  internal static let onboardChoose = ImageAsset(name: "onboard-choose")
  internal static let onboardProtect = ImageAsset(name: "onboard-protect")
  internal static let paywallCrown = ImageAsset(name: "paywall-crown")
  internal static let paywallIp = ImageAsset(name: "paywall-ip")
  internal static let paywallProtection = ImageAsset(name: "paywall-protection")
  internal static let paywallSecure = ImageAsset(name: "paywall-secure")
  internal static let settingsPrivacy = ImageAsset(name: "settings-privacy")
  internal static let settingsSubscription = ImageAsset(name: "settings-subscription")
  internal static let settingsSupport = ImageAsset(name: "settings-support")
  internal static let settingsTerms = ImageAsset(name: "settings-terms")
  internal static let tabData = ImageAsset(name: "tab-data")
  internal static let tabSettings = ImageAsset(name: "tab-settings")
  internal static let tabVpn = ImageAsset(name: "tab-vpn")
  internal static let power = ImageAsset(name: "Power")
  internal static let vpnPower = ImageAsset(name: "vpn-power")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

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
