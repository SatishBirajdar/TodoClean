//
//  ToggleTodoUseCaseTests.swift
//  CleanTodoTests
//
//  Created by Satish Birajdar on 14/05/26.
//

import XCTest
@testable import CleanTodo

final class ToggleTodoUseCaseTests: XCTestCase {

    func test_execute_togglesCompletionStatus() async throws {
        let repo = MockTodoRepository()
        let item = TodoItem(title: "Test item", isCompleted: false)
        repo.items = [item]
        let sut = ToggleTodoUseCase(repository: repo)

        let updated = try await sut.execute(item)

        XCTAssertTrue(updated.isCompleted)
        XCTAssertTrue(repo.items.first?.isCompleted == true)
    }

    func test_execute_togglesBackToIncomplete() async throws {
        let repo = MockTodoRepository()
        let item = TodoItem(title: "Done item", isCompleted: true)
        repo.items = [item]
        let sut = ToggleTodoUseCase(repository: repo)

        let updated = try await sut.execute(item)

        XCTAssertFalse(updated.isCompleted)
    }
}
