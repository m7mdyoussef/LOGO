
import Foundation

extension Double {
    static let defaultValue = 0.0
}

extension Double {
    var toNSNumber: NSNumber {
        return NSNumber(value: self)
    }
}
