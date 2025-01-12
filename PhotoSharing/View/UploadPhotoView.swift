import SwiftUI
import PhotosUI

private enum UploadPhotoViewConstants {
    static let imageMaxHeight: CGFloat = 300
    static let gridMinHeight: CGFloat = 150
}

/// The upload photo view.
struct UploadPhotoView: View {
    @Environment(\EnvironmentValues.presentationMode) var presentationMode
    @ObservedObject var viewModel: PhotosListViewModel
    @State private var photoDescription: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var images: [UIImage] = []
    private let itemWidth = ceil(UIScreen.main.bounds.width / 4)
    private let gridItemsNumber = 4

    var body: some View {
        VStack(spacing: 0) {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: UploadPhotoViewConstants.imageMaxHeight)
                    .clipped()
            }

            Divider()

            ScrollView {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.fixed(itemWidth), spacing: 0), count: gridItemsNumber),
                    spacing: 0
                ) {
                    ForEach(images.indices, id: \..self) { index in
                        Image(uiImage: images[index])
                            .resizable()
                            .scaledToFill()
                            .frame(width: itemWidth, height: itemWidth)
                            .clipped()
                            .background(Color.clear)
                            .overlay(
                                selectedImage == images[index] ?
                                Rectangle().stroke(Color.blue, lineWidth: 2) : nil
                            )
                            .onTapGesture {
                                selectedImage = images[index]
                            }
                    }
                }
                .padding(.horizontal, 0)
                .frame(minHeight: UploadPhotoViewConstants.gridMinHeight)
            }
            .onAppear {
                requestGalleryAccess()
            }

            Divider()

            if let selectedImage = selectedImage,
               let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                Button("upload_photo") {
                    let newPhoto = Photo(imageData: imageData, description: photoDescription)
                    viewModel.uploadPhoto(photo: newPhoto)
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
        .onAppear {
            requestGalleryAccess()
        }
    }
}

// MARK: - Helper extension

private extension UploadPhotoView {
    func requestGalleryAccess() {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized || status == .limited {
                loadGalleryImages(selectLatest: true)
            }
        }
    }

    func loadGalleryImages(selectLatest: Bool = false) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        images.removeAll()

        var uniqueAssetIdentifiers = Set<String>()

        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat

        fetchResult.enumerateObjects { asset, index, _ in
            if uniqueAssetIdentifiers.insert(asset.localIdentifier).inserted {
                imageManager.requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: options) { image, _ in
                    if let image = image {
                        DispatchQueue.main.async {
                            images.append(image)

                            if selectLatest && index == 0 {
                                selectedImage = image
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    UploadPhotoView(viewModel: PhotosListViewModel(photoRepository: PhotoRepository()))
}
