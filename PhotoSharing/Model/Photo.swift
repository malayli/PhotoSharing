import Foundation

struct Photo: Identifiable {
    let id = UUID()
    let imageData: Data
    let description: String
}
