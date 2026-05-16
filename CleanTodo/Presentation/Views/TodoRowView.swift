//
//  TodoRowView.swift
//  CleanTodo
//
//  Created by Satish Birajdar on 14/05/26.
//

import SwiftUI

/// Reusable row component that renders a single `TodoItem` inside a list.
/// Displays a tappable completion circle, the title (with strikethrough when done),
/// and a relative timestamp. Delegates toggle actions back to the parent via `onToggle`.
struct TodoRowView: View {
    let item: TodoItem
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Button(action: onToggle) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(item.isCompleted ? .green : .gray)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .strikethrough(item.isCompleted)
                    .foregroundStyle(item.isCompleted ? .secondary : .primary)

                Text(item.createdAt, style: .relative)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture(perform: onToggle)
    }
}
