//
//  DIContainer.swift
//  CleanTodo
//
//  Created by Satish Birajdar on 14/05/26.
//

import Foundation

/// Composition Root — the single place where all dependencies are wired together.
/// Creates and owns the Data layer (data sources, repositories) and provides
/// factory methods for Use Cases and ViewModels.
/// The app entry point (`CleanTodoApp`) holds one instance and uses it
/// to build the initial view hierarchy with fully injected dependencies.
final class DIContainer {

    // MARK: - Data Layer

    private lazy var localDataSource: LocalTodoDataSourceProtocol = {
        LocalTodoDataSource()
    }()

    private lazy var todoRepository: TodoRepositoryProtocol = {
        TodoRepository(localDataSource: localDataSource)
    }()

    // MARK: - Use Cases

    private func makeFetchTodosUseCase() -> FetchTodosUseCaseProtocol {
        FetchTodosUseCase(repository: todoRepository)
    }

    private func makeAddTodoUseCase() -> AddTodoUseCaseProtocol {
        AddTodoUseCase(repository: todoRepository)
    }

    private func makeToggleTodoUseCase() -> ToggleTodoUseCaseProtocol {
        ToggleTodoUseCase(repository: todoRepository)
    }

    private func makeDeleteTodoUseCase() -> DeleteTodoUseCaseProtocol {
        DeleteTodoUseCase(repository: todoRepository)
    }

    // MARK: - View Models

    @MainActor
    func makeTodoListViewModel() -> TodoListViewModel {
        TodoListViewModel(
            fetchTodosUseCase: makeFetchTodosUseCase(),
            addTodoUseCase: makeAddTodoUseCase(),
            toggleTodoUseCase: makeToggleTodoUseCase(),
            deleteTodoUseCase: makeDeleteTodoUseCase()
        )
    }
}
