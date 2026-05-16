//
//  MockTodoRepository.swift
//  CleanTodoTests
//
//  Created by Satish Birajdar on 14/05/26.
//

import Foundation
@testable import CleanTodo

final class MockTodoRepository: TodoRepositoryProtocol {
    var items: [TodoItem] = []
    var shouldThrow: Error?

    func fetchTodos() async throws -> [TodoItem] {
        if let error = shouldThrow { throw error }
        return items
    }

    func addTodo(_ item: TodoItem) async throws {
        if let error = shouldThrow { throw error }
        items.append(item)
    }

    func updateTodo(_ item: TodoItem) async throws {
        if let error = shouldThrow { throw error }
        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            throw TodoError.notFound
        }
        items[index] = item
    }

    func deleteTodo(id: UUID) async throws {
        if let error = shouldThrow { throw error }
        items.removeAll { $0.id == id }
    }
}
