import SwiftUI

/// The photos list view.
struct PhotosListView: View {
    @State private var showingUploadView = false
    @ObservedObject var viewModel: PhotosListViewModel

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isUploading {
                    ProgressView("uploading")
                        .padding()
                }
                List {
                    ForEach(viewModel.photoViewModels) { photo in
                        PhotoRow(photo: photo)
                            .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .opacity))
                    }
                }
                .navigationTitle("app_title")
                .toolbar {
                    Button(action: {
                        showingUploadView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                .sheet(isPresented: $showingUploadView) {
                    UploadPhotoView(viewModel: viewModel)
                }
                .alert(item: $viewModel.errorMessage) { alertMessage in
                    Alert(title: Text("standard_error"), message: Text(alertMessage.message), dismissButton: .default(Text("ok")))
                }
            }
        }
    }
}

#Preview {
    PhotosListView(viewModel: PhotosListViewModel(photoRepository: PhotoRepository()))
}
