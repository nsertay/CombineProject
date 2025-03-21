//
//  ContentView.swift
//  CombineProject
//
//  Created by Nurmukhanbet Sertay on 21.03.2025.
//

import SwiftUI
import Combine

// MARK: - Model
struct Todo: Identifiable, Codable {
    let id: Int
    var title: String
    var completed: Bool
}

// MARK: - ViewModel
class TodoViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    private var cancellables = Set<AnyCancellable>()
    
    func fetchTodos() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos?_limit=5")!
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Todo].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { self.todos = $0 })
            .store(in: &cancellables)
    }
    
    func toggleCompletion(for todo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].completed.toggle()
        }
    }
}

// MARK: - View
struct ContentView: View {
    @StateObject private var viewModel = TodoViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.todos) { todo in
                HStack {
                    Text(todo.title)
                    Spacer()
                    Image(systemName: todo.completed ? "checkmark.circle.fill" : "circle")
                        .onTapGesture {
                            viewModel.toggleCompletion(for: todo)
                        }
                }
            }
            .navigationTitle("To-Do List")
            .onAppear { viewModel.fetchTodos() }
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
