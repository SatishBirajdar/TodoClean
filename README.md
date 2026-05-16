# CleanTodo

A SwiftUI todo app built with **Clean Architecture** to demonstrate separation of concerns, dependency inversion, and testability in iOS development.

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                   Presentation                      │
│   TodoListView ─► TodoListViewModel                 │
│   TodoRowView                                       │
├─────────────────────────────────────────────────────┤
│                     Domain                          │
│   TodoItem (Entity)     TodoError (Entity)          │
│   FetchTodosUseCase     AddTodoUseCase              │
│   ToggleTodoUseCase     DeleteTodoUseCase            │
│   TodoRepositoryProtocol (abstract)                 │
├─────────────────────────────────────────────────────┤
│                      Data                           │
│   TodoRepository ─► LocalTodoDataSource             │
│   TodoLocalDTO                                      │
├─────────────────────────────────────────────────────┤
│                       DI                            │
│   DIContainer (Composition Root)                    │
└─────────────────────────────────────────────────────┘
```

**Dependency Rule:** Inner layers never depend on outer layers. The Domain layer defines protocols; the Data layer implements them. Dependencies flow inward via constructor injection wired in `DIContainer`.

## Project Structure

```
CleanTodo/
├── CleanTodoApp.swift              # App entry point
├── DI/
│   └── DIContainer.swift           # Composition root — wires all dependencies
├── Domain/
│   ├── Entities/
│   │   ├── TodoItem.swift          # Core domain model
│   │   └── TodoError.swift         # Domain error types
│   ├── Repositories/
│   │   └── TodoRepositoryProtocol.swift  # Abstract persistence contract
│   └── UseCases/
│       ├── FetchTodosUseCase.swift
│       ├── AddTodoUseCase.swift
│       ├── ToggleTodoUseCase.swift
│       └── DeleteTodoUseCase.swift
├── Data/
│   ├── DTOs/
│   │   └── TodoLocalDTO.swift      # Persistence ↔ domain mapper
│   ├── DataSources/
│   │   └── LocalTodoDataSource.swift  # UserDefaults JSON storage
│   └── Repositories/
│       └── TodoRepository.swift    # Concrete repository implementation
└── Presentation/
    ├── ViewModels/
    │   └── TodoListViewModel.swift # @MainActor observable VM
    └── Views/
        ├── TodoListView.swift      # Main screen
        └── TodoRowView.swift       # Single todo row
```

## Features

- **Add** todos with title validation (empty/whitespace rejected)
- **Toggle** completion status with visual strikethrough
- **Delete** via swipe-to-delete
- **Filter** by All / Active / Done (segmented picker)
- **Persistence** via UserDefaults (JSON-encoded, ISO 8601 dates)
- **Error handling** with alert presentation
- **Empty state** with contextual messaging per filter

## Requirements

- iOS 17.0+
- Xcode 16+
- Swift 5.9

## Getting Started

### Option 1: Open the Xcode project directly

```bash
open CleanTodo.xcodeproj
```

### Option 2: Regenerate the project with XcodeGen

```bash
brew install xcodegen   # if not installed
xcodegen generate
open CleanTodo.xcodeproj
```

Build and run on any iOS 17+ simulator.

## Tests

Unit tests cover the Domain layer use cases with a mock repository:

```
CleanTodoTests/
├── Domain/
│   ├── AddTodoUseCaseTests.swift
│   ├── DeleteTodoUseCaseTests.swift
│   └── ToggleTodoUseCaseTests.swift
└── Mocks/
    └── MockTodoRepository.swift
```

Run tests:

```bash
xcodebuild -project CleanTodo.xcodeproj \
  -scheme CleanTodoTests \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  test
```

Or use **Cmd+U** in Xcode.

## Design Decisions

| Decision | Rationale |
|----------|-----------|
| **One use case per operation** | Single Responsibility — each use case encapsulates exactly one business rule |
| **Protocol per use case** | Enables isolated unit testing with mocks |
| **DTO ↔ Domain mapping** | Decouples persistence schema from the domain model |
| **UserDefaults storage** | Simple persistence appropriate for a demo; swap to SwiftData/CoreData by replacing `LocalTodoDataSource` |
| **DIContainer as Composition Root** | All wiring in one place — no service locators or singletons scattered through the code |
| **`@MainActor` ViewModel** | Guarantees UI state mutations happen on the main thread |

## License

This project is for educational and demonstration purposes.
