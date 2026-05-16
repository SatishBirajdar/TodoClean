//
//  CleanTodoApp.swift
//  CleanTodo
//
//  Created by Satish Birajdar on 14/05/26.
//

import SwiftUI

/// The main entry point of the CleanTodo application.
/// Initializes the dependency injection container and provides the root view
/// with a fully configured `TodoListViewModel` via the composition root pattern.
@main
struct CleanTodoApp: App {
    private let container = DIContainer()

    var body: some Scene {
        WindowGroup {
            TodoListView(viewModel: container.makeTodoListViewModel())
        }
    }
}
