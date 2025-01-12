import Foundation
import Combine

protocol PhotoRepositoring {
    func fetchPhotos() -> AnyPublisher<[Photo], Error>
    func uploadPhoto(photo: Photo) -> AnyPublisher<Void, Error>
}

/// The photos repository.
final class PhotoRepository: PhotoRepositoring {
    /// The photos cache.
    private var cache: [Photo] = []

    /// Fetches a photos array.
    ///
    /// - Returns: A `AnyPublisher<[Photo], Error>` instance.
    func fetchPhotos() -> AnyPublisher<[Photo], Error> {
        Just(cache)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    /// Uploads a photo.
    ///
    /// - Parameter photo: The photo to upload.
    ///
    /// - Returns: A `AnyPublisher<Void, Error>` instance.
    func uploadPhoto(photo: Photo) -> AnyPublisher<Void, Error> {
        cache.insert(photo, at: 0)
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
