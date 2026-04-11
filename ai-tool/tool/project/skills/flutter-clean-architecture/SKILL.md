---
name: flutter-clean-architecture
description: Comprehensive guide for implementing Clean Architecture in this Flutter CMMS app. Use when creating new features, entities, repositories, use cases, cubits, datasources, or models. Enforces strict layer separation where Domain has ZERO dependencies on Flutter/Drift.
metadata:
  author: cmms-team
  version: "2.0"
  framework: flutter
  dart-version: ">=3.4.0"
  related-skills:
    - flutter-di-getit
    - flutter-changelog-sync
    - flutter-dart3-patterns

tier: 1
triggers:
  - feature
  - entity
  - cubit
  - repository
  - usecase
  - clean architecture
  - domain
  - data layer
summary: |
  Clean Architecture layers, feature scaffolding, barrel exports, layer isolation.
---

# Flutter Clean Architecture implementation

This skill provides comprehensive guidance for implementing Clean Architecture patterns in the CMMS Ship Flutter App.

## Overview

| Aspect | Details |
|--------|---------|
| Architecture | Clean Architecture (Uncle Bob) |
| Layers | Domain, Data, Presentation, Infrastructure |
| State management | flutter_bloc (Cubit pattern) |
| Database | Drift (SQLite) |
| Error handling | dartz Either<Failure, T> |
| DI framework | GetIt |

## Core principle

**Domain layer has ZERO dependencies** on Flutter, Drift, or any framework. This enables:

- Unit testing without Flutter test environment
- Business logic reuse across platforms
- Clear separation of concerns
- Easier refactoring and maintenance

## Layer hierarchy

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  Screens, Widgets, Cubits, Interactors, State Classes       │
│  Dependencies: Flutter, Domain entities, UseCases           │
├─────────────────────────────────────────────────────────────┤
│                      DOMAIN LAYER                            │
│  Entities, Value Objects, Repository Interfaces, UseCases   │
│  Dependencies: NONE (only dartz for Either type)            │
├─────────────────────────────────────────────────────────────┤
│                       DATA LAYER                             │
│  Models, Datasources, Repository Implementations, Mappers   │
│  Dependencies: Domain interfaces, Drift, Changelog          │
├─────────────────────────────────────────────────────────────┤
│                   INFRASTRUCTURE LAYER                       │
│  Database config, Routing, Network, App bootstrap           │
│  Dependencies: Flutter, Drift, External packages            │
└─────────────────────────────────────────────────────────────┘
```

## Feature module structure

Each feature follows this structure:

```
lib/features/<feature>/
├── <feature>.dart                 # Barrel export (optional)
├── di.dart                        # Dependency injection mixin
├── README.md                      # Feature documentation
│
├── domain/                        # ZERO DEPENDENCIES - Pure Dart
│   ├── entities/                  # Business objects with identity
│   │   └── <entity>.dart          # Extends Equatable
│   ├── value_objects/             # Immutable value types
│   │   └── <value_object>.dart    # Extends Equatable
│   ├── repositories/              # Abstract interfaces ONLY
│   │   └── <feature>_repository.dart
│   ├── usecases/                  # Single business operations
│   │   ├── load_<entity>s.dart    # Query use case
│   │   ├── create_<entity>.dart   # Command use case
│   │   ├── update_<entity>.dart   # Command use case
│   │   └── delete_<entity>.dart   # Command use case
│   └── failures/                  # Domain-specific errors
│       └── <feature>_failure.dart
│
├── data/                          # Drift dependencies allowed
│   ├── models/                    # DTOs with conversions
│   │   └── <entity>_model.dart    # Extends Equatable
│   ├── consts/                    # Constants (no magic strings)
│   │   └── <feature>_data_constants.dart
│   ├── datasource/                # Database operations
│   │   ├── <feature>_datasource.dart        # Interface + Impl
│   │   ├── mappers/                          # Data transformations
│   │   │   └── <feature>_mapper.dart
│   │   ├── changelog/                        # Changelog recording
│   │   │   └── <feature>_changelog_recorder.dart
│   │   ├── operations/                       # Separated concerns
│   │   │   ├── <feature>_query_operations.dart
│   │   │   ├── <feature>_write_operations.dart
│   │   │   └── <feature>_delete_operations.dart
│   │   └── factories/                        # Object composition
│   │       └── <feature>_datasource_factory.dart
│   └── repositories/              # Implements domain interfaces
│       └── <feature>_repository_impl.dart
│
└── presentation/                  # Flutter dependencies allowed
    ├── constants/                 # UI constants and keys
    │   ├── <feature>_constants.dart
    │   └── <feature>_keys.dart
    ├── cubit/                     # State management
    │   ├── <feature>_cubit.dart   # Extends BaseCubitImpl
    │   └── <feature>_state.dart   # Sealed state classes
    ├── interactors/               # User action orchestration (dialogs, nav)
    │   └── <feature>_interactor.dart
    ├── services/                  # Multi-cubit business facades
    │   └── <feature>_service.dart
    ├── types/                     # Typedefs and callback signatures
    │   └── <feature>_types.dart
    ├── screens/                   # Full-screen widgets
    │   └── <feature>_screen.dart
    ├── components/                # Smart UI with BlocBuilder
    │   └── <feature>_component.dart
    └── widgets/                   # Dumb UI components (callbacks only)
        ├── <feature>_card_widget.dart
        └── <feature>_list_widget.dart
```

> **Note:** Interactors, Services, and Controllers are optional — use only for complex features with 3+ cubits. See `flutter-presentation-layer` skill for full patterns.

## Dependency rules

| Source Layer | Can Import | Cannot Import |
|--------------|------------|---------------|
| **Domain** | dartz | Flutter, Drift, Data, Presentation |
| **Data** | Domain interfaces, Drift, Changelog | Presentation, Flutter widgets |
| **Presentation** | Domain entities, UseCases, Flutter | Data implementations |
| **Infrastructure** | All layers | - |

### Forbidden patterns

```dart
// ❌ FORBIDDEN: Cubit importing Repository directly
class MyCubit extends BaseCubit<MyState> {
  final MyRepository repository; // WRONG!
}

// ✅ CORRECT: Cubit using UseCase
class MyCubit extends BaseCubit<MyState> {
  final LoadData _loadDataUseCase;
  final CreateData _createDataUseCase;
}

// ❌ FORBIDDEN: Domain importing Flutter
import 'package:flutter/material.dart'; // NEVER in domain!

// ❌ FORBIDDEN: Domain importing Drift
import 'package:drift/drift.dart'; // NEVER in domain!
```

### Private class policy

Private classes (`_ClassName`) are **FORBIDDEN** in `data/` and `domain/` layers. They cannot be independently tested, mocked, or imported.

**Allowed private classes:**
- `_MyWidgetState extends State<MyWidget>` — Flutter framework requirement
- Private helper methods (non-Widget returning) within a class

**Forbidden:**
- Logic classes in `data/` using `part of` to access parent private fields
- Processors, handlers, services with testable business logic
- Any class that should be injectable or mockable

**`part of` directive:** Only permitted for `*_state.dart` files that are `part of` a cubit. Never for logic/service classes.

**Refactoring pattern — Session object:**

When two classes need to share mutable state (e.g., parent handler + child processor), extract a **Session object** instead of using `part of`:

```dart
// Session object — simple data holder for shared mutable state
class MySyncSession {
  String? activeId;
  StreamController<SyncEvent>? eventController;
  bool isStreaming = false;

  void reset() {
    activeId = null;
    eventController = null;
    isStreaming = false;
  }
}

// Processor — public, testable, deps injected via constructor
class MySyncProcessor {
  final MySyncSession _session;
  final SomeService _service;

  MySyncProcessor({required MySyncSession session, required SomeService service})
    : _session = session, _service = service;

  Future<void> process() async {
    _session.isStreaming = true;
    await _service.execute(_session.activeId!);
  }
}

// Handler — creates session + processor, manages lifecycle
class MySyncHandler {
  final SomeService _service;
  final MySyncSession _session = MySyncSession();
  late final MySyncProcessor _processor = MySyncProcessor(
    session: _session,
    service: _service,
  );
  // ...
}
```

## Entity pattern

Entities are domain objects with identity. Always extend Equatable:

```dart
import 'package:equatable/equatable.dart';

/// Node represents a hierarchical element in the maintenance structure.
///
/// Nodes form a tree structure via Relations table.
/// Types: Main (root), Child (intermediate), Component (leaf).
class Node extends Equatable {
  /// Unique identifier (ULID format, 26 characters).
  final NodeId id;
  
  /// Display name of the node.
  final NodeName name;
  
  /// Optional detailed description.
  final String? description;
  
  /// Type determines allowed operations and children.
  final NodeType type;
  
  /// Project this node belongs to.
  final String projectId;
  
  /// Timestamp of creation (UTC).
  final DateTime createdAt;
  
  /// Timestamp of last modification (UTC).
  final DateTime updatedAt;

  const Node({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.projectId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Include ALL properties for correct equality.
  @override
  List<Object?> get props => [
    id, name, description, type, projectId, createdAt, updatedAt,
  ];

  /// Immutability pattern: create new instance with updates.
  Node copyWith({
    NodeName? name,
    String? description,
    NodeType? type,
    DateTime? updatedAt,
  }) => Node(
    id: id,
    name: name ?? this.name,
    description: description ?? this.description,
    type: type ?? this.type,
    projectId: projectId,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

/// Value object for NodeId with validation.
class NodeId extends Equatable {
  final String value;
  
  const NodeId(this.value);
  
  /// Validate ULID format (26 alphanumeric characters).
  factory NodeId.validated(String value) {
    if (value.length != 26) {
      throw ArgumentError('NodeId must be 26 characters');
    }
    return NodeId(value);
  }
  
  @override
  List<Object?> get props => [value];
  
  @override
  String toString() => value;
}
```

## Use case pattern

Use cases encapsulate single business operations:

```dart
import 'package:dartz/dartz.dart';
import 'package:cmms_ship_flutter_app/core/helper/type_aliases.dart';

/// Creates a new node as a child of an existing node.
///
/// Business rules:
/// - Generates unique ID using injected IdGenerator
/// - Sets timestamps using injected Clock
/// - Creates parent-child relation automatically
/// - Records changelog for sync
class CreateNode {
  final GraphRepository _repository;
  final IdGenerator _idGenerator;
  final Clock _clock;

  CreateNode(this._repository, this._idGenerator, this._clock);

  /// Creates node with generated ID and current timestamp.
  ///
  /// Returns created [Node] or [Failure] if creation fails.
  FutureFailable<Node> call(CreateNodeParams params) async {
    final now = _clock.now();
    final node = Node(
      id: NodeId(_idGenerator.generate()),
      name: params.name,
      description: params.description,
      type: params.type,
      projectId: params.projectId,
      createdAt: now,
      updatedAt: now,
    );

    return _repository.createNode(
      node: node,
      parentNodeId: params.parentNodeId,
    );
  }
}

/// Parameters for CreateNode use case.
class CreateNodeParams extends Equatable {
  final NodeName name;
  final String? description;
  final NodeType type;
  final String projectId;
  final NodeId parentNodeId;

  const CreateNodeParams({
    required this.name,
    this.description,
    required this.type,
    required this.projectId,
    required this.parentNodeId,
  });

  @override
  List<Object?> get props => [name, description, type, projectId, parentNodeId];
}
```

### Use case naming conventions

| Pattern | Example | Purpose |
|---------|---------|---------|
| `Load<Entity>s` | `LoadNodes` | Query multiple entities |
| `Get<Entity>` | `GetNodeById` | Query single entity |
| `Create<Entity>` | `CreateNode` | Create new entity |
| `Update<Entity>` | `UpdateNode` | Modify existing entity |
| `Delete<Entity>` | `DeleteNode` | Remove entity |
| `Delete<Entity>Cascade` | `DeleteNodeCascade` | Remove with dependencies |
| `Duplicate<Entity>` | `DuplicateNode` | Copy entity with new ID |

## Repository pattern

### Interface (Domain layer)

```dart
import 'package:dartz/dartz.dart';
import 'package:cmms_ship_flutter_app/core/helper/type_aliases.dart';

/// Abstract interface for node data operations.
///
/// Implementations handle persistence details (Drift, API, etc.).
abstract class GraphRepository {
  /// Loads all nodes for the specified project.
  FutureFailable<List<Node>> getNodesByProjectId(String projectId);

  /// Creates a new node with parent relation.
  FutureFailable<Node> createNode({
    required Node node,
    required NodeId parentNodeId,
  });

  /// Updates node properties.
  FutureFailable<Node> updateNode(Node node);

  /// Deletes node with all descendants and related data.
  FutureFailable<void> deleteNodeCascade(NodeId nodeId);
}
```

### Implementation (Data layer)

```dart
import 'package:cmms_ship_flutter_app/core/error/repository_request_handler.dart';

class GraphRepositoryImpl implements GraphRepository {
  final GraphDatasource _datasource;

  GraphRepositoryImpl(this._datasource);

  @override
  FutureFailable<List<Node>> getNodesByProjectId(String projectId) async {
    return RepositoryRequestHandler<List<Node>>()(
      request: () async {
        final models = await _datasource.getNodesByProjectId(projectId);
        return models.map((m) => m.toEntity()).toList();
      },
      defaultFailure: const Failure(message: 'Failed to load nodes'),
    );
  }

  @override
  FutureFailable<Node> createNode({
    required Node node,
    required NodeId parentNodeId,
  }) async {
    return RepositoryRequestHandler<Node>()(
      request: () async {
        final model = NodeModel.fromEntity(node);
        final created = await _datasource.createNode(
          model: model,
          parentNodeId: parentNodeId.value,
        );
        return created.toEntity();
      },
      defaultFailure: const Failure(message: 'Failed to create node'),
    );
  }
}
```

## Model pattern

Models are DTOs that bridge domain entities and database:

```dart
import 'package:equatable/equatable.dart';
import 'package:drift/drift.dart';

/// Data Transfer Object for Node.
class NodeModel extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String type;
  final String projectId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NodeModel({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.projectId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id, name, description, type, projectId, createdAt, updatedAt,
  ];

  /// Convert domain entity to model.
  factory NodeModel.fromEntity(Node entity) => NodeModel(
    id: entity.id.value,
    name: entity.name.value,
    description: entity.description,
    type: entity.type.name,
    projectId: entity.projectId,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );

  /// Convert model to domain entity.
  Node toEntity() => Node(
    id: NodeId(id),
    name: NodeName(name),
    description: description,
    type: NodeType.values.byName(type),
    projectId: projectId,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  /// Convert Drift record to model.
  factory NodeModel.fromDrift(NodeData drift) => NodeModel(
    id: drift.id,
    name: drift.name,
    description: drift.description,
    type: drift.type,
    projectId: drift.projectId,
    createdAt: drift.createdAt,
    updatedAt: drift.updatedAt,
  );

  /// Convert to Drift companion for INSERT.
  NodesCompanion toInsertCompanion() => NodesCompanion.insert(
    id: id,
    name: name,
    description: Value(description),
    type: type,
    projectId: projectId,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  /// Convert to Map for changelog recording.
  Map<String, dynamic> toMap() => {
    NodeDataConstants.fieldId: id,
    NodeDataConstants.fieldName: name,
    NodeDataConstants.fieldDescription: description,
    NodeDataConstants.fieldType: type,
    NodeDataConstants.fieldProjectId: projectId,
    NodeDataConstants.fieldCreatedAt: createdAt.toIso8601String(),
    NodeDataConstants.fieldUpdatedAt: updatedAt.toIso8601String(),
  };
}
```

## Creating a new feature checklist

### Phase 1: Domain layer (Pure Dart)

1. [ ] Create folder: `lib/features/<name>/domain/`
2. [ ] Define entities in `domain/entities/` (extend Equatable)
3. [ ] Define value objects in `domain/value_objects/` (extend Equatable)
4. [ ] Create repository interface in `domain/repositories/`
5. [ ] Create use cases in `domain/usecases/`
6. [ ] Create failure types in `domain/failures/` (if needed)

### Phase 2: Data layer (Drift allowed)

7. [ ] Create folder: `lib/features/<name>/data/`
8. [ ] Create constants in `data/consts/<feature>_data_constants.dart`
9. [ ] Create models in `data/models/` (extend Equatable)
10. [ ] Create mapper in `data/datasource/mappers/`
11. [ ] Create changelog recorder in `data/datasource/changelog/`
12. [ ] Create operations in `data/datasource/operations/`
13. [ ] Create datasource facade in `data/datasource/`
14. [ ] Create factory in `data/datasource/factories/`
15. [ ] Implement repository in `data/repositories/`

### Phase 3: Presentation layer (Flutter allowed)

16. [ ] Create folder: `lib/features/<name>/presentation/`
17. [ ] Create constants in `presentation/constants/`
18. [ ] Create state classes in `presentation/cubit/` (sealed, Equatable)
19. [ ] Create cubit in `presentation/cubit/` (extend BaseCubit)
20. [ ] Create interactor in `presentation/interactors/`
21. [ ] Create screen in `presentation/screens/`
22. [ ] Create widgets in `presentation/widgets/`

### Phase 4: Integration

23. [ ] Create DI mixin: `lib/features/<name>/di.dart`
24. [ ] Add mixin to `DI` class in `lib/di.dart`
25. [ ] Add routes in `lib/core/infrastructure/routing/`
26. [ ] Create feature README.md

## Related skills

- [flutter-di-getit](../flutter-di-getit/SKILL.md) - Dependency injection registration
- [flutter-changelog-sync](../flutter-changelog-sync/SKILL.md) - Changelog recording in datasources
- [flutter-effective-dart](../flutter-effective-dart/SKILL.md) - Modern Dart patterns and best practices
- [flutter-logging](../flutter-logging/SKILL.md) - Logging with constants
- [flutter-validation](../flutter-validation/SKILL.md) - Input validation patterns

## Reference files

- [CUBIT_PATTERN.md](references/CUBIT_PATTERN.md) - Detailed Cubit implementation
