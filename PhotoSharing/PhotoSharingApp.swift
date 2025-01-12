import SwiftUI

@main
struct PhotoSharingApp: App {
    private let container = DependenciesContainer(photoRepository: PhotoRepository())

    var body: some Scene {
        WindowGroup {
            PhotosListView(viewModel: PhotosListViewModel(photoRepository: container.photoRepository))
        }
    }
}
