//
//  DeleteTodoUseCaseTests.swift
//  CleanTodoTests
//
//  Created by Satish Birajdar on 14/05/26.
//

import XCTest
@testable import CleanTodo

final class DeleteTodoUseCaseTests: XCTestCase {

    func test_execute_removesItemFromRepository() async throws {
        let repo = MockTodoRepository()
        let item = TodoItem(title: "Delete me")
        repo.items = [item]
        let sut = DeleteTodoUseCase(repository: repo)

        try await sut.execute(id: item.id)

        XCTAssertTrue(repo.items.isEmpty)
    }

    func test_execute_withUnknownId_throwsNotFound() async {
        let repo = MockTodoRepository()
        let sut = DeleteTodoUseCase(repository: repo)

        do {
            try await sut.execute(id: UUID())
            XCTFail("Expected notFound error")
        } catch let error as TodoError {
            XCTAssertEqual(error, .notFound)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
