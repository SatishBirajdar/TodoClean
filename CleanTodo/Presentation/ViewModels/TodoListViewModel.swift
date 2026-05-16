//
//  TodoListViewModel.swift
//  CleanTodo
//
//  Created by Satish Birajdar on 14/05/26.
//

import Foundation

/// ViewModel for the main todo list screen, belonging to the Presentation layer.
/// Orchestrates user interactions by delegating to injected use cases (Domain layer)
/// and exposes `@Published` state that SwiftUI views observe.
/// Runs on `@MainActor` to ensure all UI state mutations happen on the main thread.
/// Knows nothing about storage, networking, or view implementation details.
@MainActor
final class TodoListViewModel: ObservableObject {

    // MARK: - Published State

    @Published var todos: [TodoItem] = []
    @Published var newTodoTitle: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var filter: Filter = .all

    enum Filter: String, CaseIterable {
        case all = "All"
        case active = "Active"
        case completed = "Done"
    }

    var filteredTodos: [TodoItem] {
        switch filter {
        case .all:       return todos
        case .active:    return todos.filter { !$0.isCompleted }
        case .completed: return todos.filter { $0.isCompleted }
        }
    }

    var activeCount: Int {
        todos.filter { !$0.isCompleted }.count
    }

    var completedCount: Int {
        todos.filter { $0.isCompleted }.count
    }

    // MARK: - Use Cases (injected)

    private let fetchTodosUseCase: FetchTodosUseCaseProtocol
    private let addTodoUseCase: AddTodoUseCaseProtocol
    private let toggleTodoUseCase: ToggleTodoUseCaseProtocol
    private let deleteTodoUseCase: DeleteTodoUseCaseProtocol

    // MARK: - Init

    init(
        fetchTodosUseCase: FetchTodosUseCaseProtocol,
        addTodoUseCase: AddTodoUseCaseProtocol,
        toggleTodoUseCase: ToggleTodoUseCaseProtocol,
        deleteTodoUseCase: DeleteTodoUseCaseProtocol
    ) {
        self.fetchTodosUseCase = fetchTodosUseCase
        self.addTodoUseCase = addTodoUseCase
        self.toggleTodoUseCase = toggleTodoUseCase
        self.deleteTodoUseCase = deleteTodoUseCase
    }

    // MARK: - Actions

    func loadTodos() {
        Task {
            isLoading = true
            defer { isLoading = false }
            do {
                todos = try await fetchTodosUseCase.execute()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func addTodo() {
        Task {
            do {
                let item = try await addTodoUseCase.execute(title: newTodoTitle)
                todos.insert(item, at: 0)
                newTodoTitle = ""
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func toggleTodo(_ item: TodoItem) {
        Task {
            do {
                let updated = try await toggleTodoUseCase.execute(item)
                if let index = todos.firstIndex(where: { $0.id == item.id }) {
                    todos[index] = updated
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func deleteTodo(_ item: TodoItem) {
        Task {
            do {
                try await deleteTodoUseCase.execute(id: item.id)
                todos.removeAll { $0.id == item.id }
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func deleteTodos(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { filteredTodos[$0] }
        for item in itemsToDelete {
            deleteTodo(item)
        }
    }
}
