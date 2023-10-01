
import Foundation

func log(_ text: String) {
    let thread = Thread.isMainThread ? "main thread" : "other thread"
    print("[\(thread)] \(text)")
}
