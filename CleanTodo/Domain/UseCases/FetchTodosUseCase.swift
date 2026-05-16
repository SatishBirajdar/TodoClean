//
//  FetchTodosUseCase.swift
//  CleanTodo
//
//  Created by Satish Birajdar on 14/05/26.
//

import Foundation

/// Protocol abstracting the fetch-all-todos operation for testability.
protocol FetchTodosUseCaseProtocol {
    func execute() async throws -> [TodoItem]
}

/// Use case that retrieves all todo items from the repository.
/// Encapsulates a single read operation following the Single Responsibility Principle.
/// The presentation layer calls this on screen load to populate the list.
final class FetchTodosUseCase: FetchTodosUseCaseProtocol {
    private let repository: TodoRepositoryProtocol

    init(repository: TodoRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [TodoItem] {
        try await repository.fetchTodos()
    }
}
