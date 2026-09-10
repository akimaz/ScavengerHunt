import SwiftUI

struct ContentView: View {
    
    @State private var tasks = [
        Task(
            title: "Your favorite local restaurant",
            description: "Where do you go when you want a good meal?"
        ),
        Task(
            title: "Your favorite local cafe",
            description: "Where do you go to grab coffee or relax?"
        ),
        Task(
            title: "Your go-to brunch place",
            description: "Where is your favorite place to get brunch?"
        ),
        Task(
            title: "Your favorite hiking spot",
            description: "Where do you go to be one with nature?"
        )
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($tasks) { $task in
                    
                    NavigationLink {
                        TaskDetailView(task: $task)
                    } label: {
                        HStack {
                            Text(task.title)
                                .foregroundStyle(.primary)
                            
                            Spacer()
                            
                            Image(systemName:
                                    task.isCompleted
                                  ? "checkmark.circle.fill"
                                  : "circle"
                            )
                            .foregroundStyle(
                                task.isCompleted ? .green : .red
                            )
                        }
                    }
                }
            }
            .navigationTitle("Photo Scavenger Hunt")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
