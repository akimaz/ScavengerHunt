import Foundation

struct Task: Identifiable {
    let id = UUID()
    let title: String
    let description: String

    var isCompleted: Bool = false
    var imageData: Data? = nil
    var latitude: Double? = nil
    var longitude: Double? = nil
}
