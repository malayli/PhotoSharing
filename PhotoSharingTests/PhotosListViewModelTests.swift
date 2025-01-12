import Testing
import Foundation
import Combine
@testable import PhotoSharing

struct PhotosViewModelTests {

    @Test func testInit() async throws {
        let photoRepository = PhotoRepository()
        let photoViewModel = PhotosListViewModel(photoRepository: photoRepository)

        #expect(photoViewModel != nil)
    }

    @Test func testUploadPhoto() async throws {
        let mockRepository = PhotoRepository()
        let viewModel = PhotosListViewModel(photoRepository: mockRepository)

        let imageData = Data()
        let description = "Test Photo Description"
        let photo = Photo(imageData: imageData, description: description)

        viewModel.uploadPhoto(photo: photo)

        try await expectEventually {
            viewModel.isUploading == false && viewModel.photoViewModels.count == 1
        }

        #expect(viewModel.isUploading == false, "The photo upload should complete")
        #expect(viewModel.photoViewModels.count == 1, "photos array should contain 1 photo after upload")
        #expect(viewModel.photoViewModels.first?.description == description, "Uploaded photo's description should match")
    }
}
