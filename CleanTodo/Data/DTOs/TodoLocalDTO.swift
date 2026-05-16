//
//  TodoLocalDTO.swift
//  CleanTodo
//
//  Created by Satish Birajdar on 14/05/26.
//

import Foundation

/// Data Transfer Object for local persistence of todo items.
/// Maps between the domain `TodoItem` and JSON-encoded storage in UserDefaults.
/// Isolates the persistence format from the domain model — if the storage schema changes,
/// only this DTO and its mapping functions need to be updated.
struct TodoLocalDTO: Codable {
    let id: UUID
    let title: String
    let isCompleted: Bool
    let createdAt: Date

    func toDomain() -> TodoItem {
        TodoItem(
            id: id,
            title: title,
            isCompleted: isCompleted,
            createdAt: createdAt
        )
    }

    static func fromDomain(_ item: TodoItem) -> TodoLocalDTO {
        TodoLocalDTO(
            id: item.id,
            title: item.title,
            isCompleted: item.isCompleted,
            createdAt: item.createdAt
        )
    }
}
