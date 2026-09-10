import SwiftUI
import MapKit

struct TaskDetailView: View {
    
    @Binding var task: Task
    @State private var showingPhotoPicker = false
    
    private let defaultLocation = CLLocationCoordinate2D(
        latitude: 41.8781,
        longitude: -87.6298
    )
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            HStack {
                
                Image(systemName:
                        task.isCompleted
                      ? "checkmark.circle.fill"
                      : "circle"
                )
                .foregroundStyle(
                    task.isCompleted ? .green : .red
                )
                
                Text(task.title)
            }
            
            Text(task.description)
                .foregroundStyle(.secondary)
                .font(.subheadline)
            
            if let latitude = task.latitude,
               let longitude = task.longitude {
                
                let coordinate = CLLocationCoordinate2D(
                    latitude: latitude,
                    longitude: longitude
                )
                
                Map {
                    Marker(
                        task.title,
                        coordinate: coordinate
                    )
                }
                .frame(height: 220)
                
            } else {
                
                Map {
                    Marker(
                        "Location",
                        coordinate: defaultLocation
                    )
                }
                .frame(height: 220)
            }
            
            Button {
                showingPhotoPicker = true
            } label: {
                Text("Attach Photo")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding()
        .navigationTitle(task.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingPhotoPicker) {
            PhotoPicker(
                imageData: $task.imageData,
                latitude: $task.latitude,
                longitude: $task.longitude
            )
        }
        .onChange(of: task.imageData) {
            if task.imageData != nil {
                task.isCompleted = true
            }
        }
    }
}
