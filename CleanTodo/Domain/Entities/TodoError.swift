//
//  TodoError.swift
//  CleanTodo
//
//  Created by Satish Birajdar on 14/05/26.
//

import Foundation

/// Domain-level errors that can occur during todo operations.
/// Each case provides a user-facing localized description via `LocalizedError`.
/// Used by use cases and the repository to communicate failures to the presentation layer.
enum TodoError: LocalizedError {
    case emptyTitle
    case notFound
    case persistenceFailed

    var errorDescription: String? {
        switch self {
        case .emptyTitle:
            return "Todo title cannot be empty."
        case .notFound:
            return "Todo item not found."
        case .persistenceFailed:
            return "Failed to save data."
        }
    }
}
