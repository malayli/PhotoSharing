import Foundation
import Combine

struct PhotoViewModel: Identifiable {
    let id = UUID()
    let imageData: Data
    let description: String
}
