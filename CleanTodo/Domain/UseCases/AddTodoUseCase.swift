//
//  AddTodoUseCase.swift
//  CleanTodo
//
//  Created by Satish Birajdar on 14/05/26.
//

import Foundation

/// Protocol abstracting the add-todo operation for testability.
protocol AddTodoUseCaseProtocol {
    func execute(title: String) async throws -> TodoItem
}

/// Use case that creates a new todo item after validating and trimming the title.
/// Contains business logic: rejects empty/whitespace-only titles by throwing `TodoError.emptyTitle`.
/// Returns the newly created `TodoItem` so the presentation layer can update immediately.
final class AddTodoUseCase: AddTodoUseCaseProtocol {
    private let repository: TodoRepositoryProtocol

    init(repository: TodoRepositoryProtocol) {
        self.repository = repository
    }

    func execute(title: String) async throws -> TodoItem {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw TodoError.emptyTitle
        }
        let item = TodoItem(title: trimmed)
        try await repository.addTodo(item)
        return item
    }
}
