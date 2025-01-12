import XCTest
import Foundation

func fail(_ message: String, file: StaticString = #file, line: UInt = #line) {
    XCTFail(message, file: file, line: line)
}

func expectEventually(
    timeout: TimeInterval = 5,
    interval: TimeInterval = 0.1,
    condition: @escaping () -> Bool,
    file: StaticString = #file,
    line: UInt = #line
) async throws {
    let startTime = Date()
    while Date().timeIntervalSince(startTime) < timeout {
        if condition() {
            return
        }
        try await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
    }
    fail("Condition not met within \(timeout) seconds", file: file, line: line)
}
