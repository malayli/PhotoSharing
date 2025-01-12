import Testing
import Foundation
@testable import PhotoSharing

struct AlertMessageTests {

    @Test func testInit() async throws {
        let message = "An alert message."
        let alertMessage = AlertMessage(message: message)

        #expect(alertMessage != nil)
        #expect(alertMessage.message == message)
    }
}
