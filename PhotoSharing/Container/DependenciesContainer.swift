import Foundation

/// The dependencies container.
final class DependenciesContainer {
    let photoRepository: PhotoRepositoring

    init(photoRepository: PhotoRepositoring) {
        self.photoRepository = photoRepository
    }
}
