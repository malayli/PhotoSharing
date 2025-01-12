import Testing
import Foundation
import Combine
@testable import PhotoSharing

struct PhotoRepositoryTests {
    @Test("When initializing a photo repository, it should be created successfully")
    func testInit() async throws {
        let photoRepository = PhotoRepository()

        #expect(photoRepository != nil)
    }

    @Test("When fetching a photo, it should return an empty array")
    func testFetchPhoto() throws {
        let photoRepository = PhotoRepository()
        var cancellables = Set<AnyCancellable>()
        var fetchedPhotos: [Photo] = []

        photoRepository.fetchPhotos()
            .sink(receiveCompletion: { completion in
            }, receiveValue: { photos in
                fetchedPhotos = photos
            })
            .store(in: &cancellables)

        #expect(fetchedPhotos.count == 0, "The repository should not contain photo")
    }

    @Test("When uploading and then fetching photos, it should return a none-empty array")
    func testUploadPhoto() throws {
        let photoRepository = PhotoRepository()
        let imageData = Data()
        let description = "A photo description."
        let photo = Photo(imageData: imageData, description: description)
        var cancellables = Set<AnyCancellable>()
        var uploadComplete = false
        var fetchedPhotos: [Photo] = []

        photoRepository.uploadPhoto(photo: photo)
            .sink(receiveCompletion: { completion in
                if case .finished = completion {
                    uploadComplete = true
                }
            }, receiveValue: {})
            .store(in: &cancellables)

        photoRepository.fetchPhotos()
            .sink(receiveCompletion: { completion in
            }, receiveValue: { photos in
                fetchedPhotos = photos
            })
            .store(in: &cancellables)

        #expect(uploadComplete == true, "Upload should complete successfully")
        #expect(fetchedPhotos.count == 1, "The repository should contain exactly one photo after upload")
        #expect(fetchedPhotos.first?.description == description, "The uploaded photo's description should match")
    }
}
