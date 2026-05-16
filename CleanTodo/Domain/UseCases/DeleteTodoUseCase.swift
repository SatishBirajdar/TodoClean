//
//  DeleteTodoUseCase.swift
//  CleanTodo
//
//  Created by Satish Birajdar on 14/05/26.
//

import Foundation

/// Protocol abstracting the delete-todo operation for testability.
protocol DeleteTodoUseCaseProtocol {
    func execute(id: UUID) async throws
}

/// Use case that permanently removes a todo item by its unique identifier.
/// Delegates to the repository; throws `TodoError.notFound` if the ID doesn't exist.
final class DeleteTodoUseCase: DeleteTodoUseCaseProtocol {
    private let repository: TodoRepositoryProtocol

    init(repository: TodoRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: UUID) async throws {
        try await repository.deleteTodo(id: id)
    }
}
