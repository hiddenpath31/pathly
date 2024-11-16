import Foundation
import AVFoundation
import UIKit

struct WebStatusResponse: Codable {
    var applicationUrl: String
}

struct StatusEmpty: Codable {
    var done: Bool?
}

struct StatusResponse: Codable {
    var success: Bool
    var message: String?
}
