import SwiftUI

private enum PhotoRowConstants {
    static let photoMaxHeight: CGFloat = 200
}

/// The photo row.
struct PhotoRow: View {
    let photo: PhotoViewModel

    var body: some View {
        VStack(alignment: .leading) {
            if let image = UIImage(data: photo.imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: PhotoRowConstants.photoMaxHeight)
                    .clipped()
            }

            Text(photo.description)
                .font(.headline)
        }
        .padding()
    }
}

#Preview {
    PhotoRow(photo: PhotoViewModel(imageData: Data(), description: "An image description."))
}
