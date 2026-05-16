//
//  ToggleTodoUseCase.swift
//  CleanTodo
//
//  Created by Satish Birajdar on 14/05/26.
//

import Foundation

/// Protocol abstracting the toggle-completion operation for testability.
protocol ToggleTodoUseCaseProtocol {
    func execute(_ item: TodoItem) async throws -> TodoItem
}

/// Use case that toggles a todo item's completion status.
/// Flips `isCompleted` and persists the change via the repository.
/// Returns the updated item so the presentation layer can reflect the new state.
final class ToggleTodoUseCase: ToggleTodoUseCaseProtocol {
    private let repository: TodoRepositoryProtocol

    init(repository: TodoRepositoryProtocol) {
        self.repository = repository
    }

    func execute(_ item: TodoItem) async throws -> TodoItem {
        var updated = item
        updated.isCompleted.toggle()
        try await repository.updateTodo(updated)
        return updated
    }
}
