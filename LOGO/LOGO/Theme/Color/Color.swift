
import SwiftUI

extension Color {
    static let primaryColor = Color(Color.KeyType.primaryColor.rawValue)
    static let lightGreyColor = Color(Color.KeyType.lightGreyColor.rawValue)
    static let darkGrey = Color(Color.KeyType.darkGrey.rawValue)

    enum KeyType: String {
        case primaryColor = "primaryColor"
        case lightGreyColor = "lightGreyColor"
        case darkGrey = "darkGrey"
    }
}
