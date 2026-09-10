import SwiftUI
import PhotosUI
import UniformTypeIdentifiers
import ImageIO

struct PhotoPicker: UIViewControllerRepresentable {
    
    @Binding var imageData: Data?
    @Binding var latitude: Double?
    @Binding var longitude: Double?
    
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(
        _ uiViewController: PHPickerViewController,
        context: Context
    ) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(
            _ picker: PHPickerViewController,
            didFinishPicking results: [PHPickerResult]
        ) {
            parent.dismiss()
            
            guard let result = results.first else {
                return
            }
            
            let provider = result.itemProvider
            
            provider.loadDataRepresentation(
                forTypeIdentifier: UTType.image.identifier
            ) { data, error in
                
                guard let data = data else {
                    return
                }
                
                // Save the photo
                DispatchQueue.main.async {
                    self.parent.imageData = data
                }
                
                // Read GPS information from the photo
                guard let source = CGImageSourceCreateWithData(
                    data as CFData,
                    nil
                ),
                let properties = CGImageSourceCopyPropertiesAtIndex(
                    source,
                    0,
                    nil
                ) as? [CFString: Any],
                let gps = properties[kCGImagePropertyGPSDictionary]
                    as? [CFString: Any] else {
                    return
                }
                
                guard var lat = gps[kCGImagePropertyGPSLatitude] as? Double,
                      var lon = gps[kCGImagePropertyGPSLongitude] as? Double else {
                    return
                }
                
                if let latRef = gps[kCGImagePropertyGPSLatitudeRef] as? String,
                   latRef == "S" {
                    lat = -lat
                }
                
                if let lonRef = gps[kCGImagePropertyGPSLongitudeRef] as? String,
                   lonRef == "W" {
                    lon = -lon
                }
                
                DispatchQueue.main.async {
                    self.parent.latitude = lat
                    self.parent.longitude = lon
                }
            }
        }
    }
}
