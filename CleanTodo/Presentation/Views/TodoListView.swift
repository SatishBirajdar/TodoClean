//
//  TodoListView.swift
//  CleanTodo
//
//  Created by Satish Birajdar on 14/05/26.
//

import SwiftUI

/// Main screen of the app — displays the todo list with add, filter, toggle, and delete capabilities.
/// Observes `TodoListViewModel` via `@StateObject` and renders reactive UI.
/// Composed of extracted subviews (`addTodoBar`, `filterPicker`, `todoList`, `emptyState`)
/// to keep the body concise while maintaining a single-file screen definition.
struct TodoListView: View {
    @StateObject var viewModel: TodoListViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                addTodoBar
                filterPicker
                todoList
            }
            .navigationTitle("Clean Todo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    statsLabel
                }
            }
            .alert("Error", isPresented: showErrorBinding) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .onAppear {
                viewModel.loadTodos()
            }
        }
    }

    // MARK: - Subviews

    private var addTodoBar: some View {
        HStack(spacing: 12) {
            TextField("What needs to be done?", text: $viewModel.newTodoTitle)
                .textFieldStyle(.roundedBorder)
                .onSubmit { viewModel.addTodo() }

            Button {
                viewModel.addTodo()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
            }
            .disabled(viewModel.newTodoTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
    }

    private var filterPicker: some View {
        Picker("Filter", selection: $viewModel.filter) {
            ForEach(TodoListViewModel.Filter.allCases, id: \.self) { filter in
                Text(filter.rawValue).tag(filter)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }

    private var todoList: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxHeight: .infinity)
            } else if viewModel.filteredTodos.isEmpty {
                emptyState
            } else {
                List {
                    ForEach(viewModel.filteredTodos) { item in
                        TodoRowView(item: item) {
                            viewModel.toggleTodo(item)
                        }
                    }
                    .onDelete { offsets in
                        viewModel.deleteTodos(at: offsets)
                    }
                }
                .listStyle(.plain)
                .animation(.default, value: viewModel.filteredTodos)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "checkmark.circle")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text(emptyStateMessage)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }

    private var emptyStateMessage: String {
        switch viewModel.filter {
        case .all:       return "No todos yet. Add one above!"
        case .active:    return "All caught up!"
        case .completed: return "Nothing completed yet."
        }
    }

    private var statsLabel: some View {
        Text("\(viewModel.activeCount) active · \(viewModel.completedCount) done")
            .font(.caption)
            .foregroundStyle(.secondary)
    }

    private var showErrorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )
    }
}
