//
//  TodoItem.swift
//  CleanTodo
//
//  Created by Satish Birajdar on 14/05/26.
//

import Foundation

/// Core domain entity representing a single todo item.
/// This is the central model of the application — it belongs to the Domain layer
/// and has no dependencies on any framework, UI, or persistence detail.
/// Conforms to `Identifiable` for SwiftUI list rendering and `Equatable` for diffing.
struct TodoItem: Identifiable, Equatable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    let createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        isCompleted: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}
