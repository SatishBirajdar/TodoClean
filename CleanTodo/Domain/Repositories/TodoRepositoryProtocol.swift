//
//  TodoRepositoryProtocol.swift
//  CleanTodo
//
//  Created by Satish Birajdar on 14/05/26.
//

import Foundation

/// Abstract contract for todo persistence operations, defined in the Domain layer.
/// The Data layer provides the concrete implementation (`TodoRepository`),
/// following the Dependency Inversion Principle — the domain never depends on infrastructure.
protocol TodoRepositoryProtocol {
    func fetchTodos() async throws -> [TodoItem]
    func addTodo(_ item: TodoItem) async throws
    func updateTodo(_ item: TodoItem) async throws
    func deleteTodo(id: UUID) async throws
}
