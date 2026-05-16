//
//  LocalTodoDataSource.swift
//  CleanTodo
//
//  Created by Satish Birajdar on 14/05/26.
//

import Foundation

/// Protocol abstracting local storage operations for testability and swappability.
protocol LocalTodoDataSourceProtocol {
    func loadAll() throws -> [TodoLocalDTO]
    func saveAll(_ items: [TodoLocalDTO]) throws
}

/// Concrete data source that persists todo items as JSON in UserDefaults.
/// Uses ISO 8601 date encoding for consistent serialization.
/// Can be replaced with a CoreData, SwiftData, or file-based implementation
/// without affecting the repository or any layer above it.
final class LocalTodoDataSource: LocalTodoDataSourceProtocol {
    private let storageKey = "clean_todo_items"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadAll() throws -> [TodoLocalDTO] {
        guard let data = defaults.data(forKey: storageKey) else {
            return []
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([TodoLocalDTO].self, from: data)
    }

    func saveAll(_ items: [TodoLocalDTO]) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(items)
        defaults.set(data, forKey: storageKey)
    }
}
