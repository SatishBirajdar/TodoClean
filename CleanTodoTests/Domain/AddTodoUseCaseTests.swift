//
//  AddTodoUseCaseTests.swift
//  CleanTodoTests
//
//  Created by Satish Birajdar on 14/05/26.
//

import XCTest
@testable import CleanTodo

final class AddTodoUseCaseTests: XCTestCase {

    func test_execute_withValidTitle_addsTodoToRepository() async throws {
        let repo = MockTodoRepository()
        let sut = AddTodoUseCase(repository: repo)

        let item = try await sut.execute(title: "Buy groceries")

        XCTAssertEqual(repo.items.count, 1)
        XCTAssertEqual(repo.items.first?.title, "Buy groceries")
        XCTAssertEqual(item.title, "Buy groceries")
        XCTAssertFalse(item.isCompleted)
    }

    func test_execute_withEmptyTitle_throwsEmptyTitleError() async {
        let repo = MockTodoRepository()
        let sut = AddTodoUseCase(repository: repo)

        do {
            _ = try await sut.execute(title: "   ")
            XCTFail("Expected error to be thrown")
        } catch let error as TodoError {
            XCTAssertEqual(error, .emptyTitle)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

        XCTAssertTrue(repo.items.isEmpty)
    }

    func test_execute_trimsTitleWhitespace() async throws {
        let repo = MockTodoRepository()
        let sut = AddTodoUseCase(repository: repo)

        let item = try await sut.execute(title: "  Clean desk  ")

        XCTAssertEqual(item.title, "Clean desk")
    }
}
