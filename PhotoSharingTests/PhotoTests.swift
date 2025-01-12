import Testing
import Foundation
@testable import PhotoSharing

struct PhotoTests {

    @Test("When initializing a photo, it should be created successfully")
    func testInit() async throws {
        let imageData = Data()
        let desc = "A photo description."
        let photo = Photo(imageData: imageData, description: desc)

        #expect(photo != nil)
        #expect(photo.imageData == imageData)
        #expect(photo.description == desc)
    }
}
