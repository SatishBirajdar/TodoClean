//
//  TodoRepository.swift
//  CleanTodo
//
//  Created by Satish Birajdar on 14/05/26.
//

import Foundation

/// Concrete implementation of `TodoRepositoryProtocol` in the Data layer.
/// Bridges the domain's abstract persistence contract with the local data source.
/// Handles DTO ↔ domain mapping and sorting (newest first).
/// This is the only class the Data layer exposes to the DI container.
final class TodoRepository: TodoRepositoryProtocol {
    private let localDataSource: LocalTodoDataSourceProtocol

    init(localDataSource: LocalTodoDataSourceProtocol) {
        self.localDataSource = localDataSource
    }

    func fetchTodos() async throws -> [TodoItem] {
        let dtos = try localDataSource.loadAll()
        return dtos.map { $0.toDomain() }
            .sorted { $0.createdAt > $1.createdAt }
    }

    func addTodo(_ item: TodoItem) async throws {
        var dtos = try localDataSource.loadAll()
        dtos.append(TodoLocalDTO.fromDomain(item))
        try localDataSource.saveAll(dtos)
    }

    func updateTodo(_ item: TodoItem) async throws {
        var dtos = try localDataSource.loadAll()
        guard let index = dtos.firstIndex(where: { $0.id == item.id }) else {
            throw TodoError.notFound
        }
        dtos[index] = TodoLocalDTO.fromDomain(item)
        try localDataSource.saveAll(dtos)
    }

    func deleteTodo(id: UUID) async throws {
        var dtos = try localDataSource.loadAll()
        guard let index = dtos.firstIndex(where: { $0.id == id }) else {
            throw TodoError.notFound
        }
        dtos.remove(at: index)
        try localDataSource.saveAll(dtos)
    }
}
