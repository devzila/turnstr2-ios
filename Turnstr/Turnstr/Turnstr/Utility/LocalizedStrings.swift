// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
enum L10n {
  /// Camera
  case camera
  /// Cancel
  case cancel
  /// Dismiss
  case dismiss
  /// Enter task name
  case enterTaskName
  /// Entered email or mobile is not valid
  case enteredEmailOrMobileIsNotValid
  /// Error
  case error
  /// No record found
  case noRecordFound
  /// Password must be 6 characters long
  case passwordMustBe6CharactersLong
  /// Photo Library
  case photoLibrary
  /// Please enter password
  case pleaseEnterPassword
  /// Please enter username
  case pleaseEnterUsername
  /// Saved Photo Album
  case savedPhotoAlbum
  /// Select Source
  case selectSource
  /// Settings
  case settings
  /// Unable to upload file, try again
  case unableToUploadFileTryAgain
  /// Warning
  case warning
  /// WorkCocoon
  case workCocoon
  /// You have denied the permission to access camera and gallery
  case youHaveDeniedThePermissionToAccessCameraAndGallery
}
// swiftlint:enable type_body_length

extension L10n: CustomStringConvertible {
  var description: String { return self.string }

  var string: String {
    switch self {
      case .camera:
        return L10n.tr(key: "Camera")
      case .cancel:
        return L10n.tr(key: "Cancel")
      case .dismiss:
        return L10n.tr(key: "Dismiss")
      case .enterTaskName:
        return L10n.tr(key: "Enter task name")
      case .enteredEmailOrMobileIsNotValid:
        return L10n.tr(key: "Entered email or mobile is not valid")
      case .error:
        return L10n.tr(key: "Error")
      case .noRecordFound:
        return L10n.tr(key: "No record found")
      case .passwordMustBe6CharactersLong:
        return L10n.tr(key: "Password must be 6 characters long")
      case .photoLibrary:
        return L10n.tr(key: "Photo Library")
      case .pleaseEnterPassword:
        return L10n.tr(key: "Please enter password")
      case .pleaseEnterUsername:
        return L10n.tr(key: "Please enter username")
      case .savedPhotoAlbum:
        return L10n.tr(key: "Saved Photo Album")
      case .selectSource:
        return L10n.tr(key: "Select Source")
      case .settings:
        return L10n.tr(key: "Settings")
      case .unableToUploadFileTryAgain:
        return L10n.tr(key: "Unable to upload file, try again")
      case .warning:
        return L10n.tr(key: "Warning")
      case .workCocoon:
        return L10n.tr(key: "WorkCocoon")
      case .youHaveDeniedThePermissionToAccessCameraAndGallery:
        return L10n.tr(key: "You have denied the permission to access camera and gallery")
    }
  }

  private static func tr(key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

func tr(_ key: L10n) -> String {
  return key.string
}

private final class BundleToken {}
