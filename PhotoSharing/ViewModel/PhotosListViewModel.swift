import Foundation
import Combine

/// The photos list view model.
final class PhotosListViewModel: ObservableObject {
    @Published private var photos: [Photo] = [] {
        didSet {
            photoViewModels = photos.map { photo in
                PhotoViewModel(imageData: photo.imageData, description: photo.description)
            }
        }
    }
    @Published var photoViewModels: [PhotoViewModel] = []
    @Published private(set) var isUploading = false
    @Published var errorMessage: AlertMessage? = nil
    private let photoRepository: PhotoRepositoring
    private var cancellables = Set<AnyCancellable>()

    init(photoRepository: PhotoRepositoring) {
        self.photoRepository = photoRepository
        fetchPhotos()
    }

    private func fetchPhotos() {
        photoRepository.fetchPhotos()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = AlertMessage(message: error.localizedDescription)
                case .finished: ()
                }
            }, receiveValue: { [weak self] photos in
                self?.photos = photos
            })
            .store(in: &cancellables)
    }

    func uploadPhoto(photo: Photo) {
        isUploading = true
        photoRepository.uploadPhoto(photo: photo)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isUploading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = AlertMessage(message: error.localizedDescription)
                case .finished: ()
                }
            }, receiveValue: { [weak self] in
                self?.photos.insert(photo, at: 0)
            })
            .store(in: &cancellables)
    }
}
