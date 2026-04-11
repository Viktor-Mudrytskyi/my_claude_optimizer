# Cubit pattern reference

This document provides comprehensive guidance for implementing Cubits in the CMMS Ship Flutter App.

## Overview

| Aspect | Details |
|--------|---------|
| Base class | `BaseCubit<S>` from `core/presentation/cubit/` |
| State classes | Sealed classes extending Equatable |
| Dependency | Use cases only (never repositories) |
| Pattern | Dart 3.0+ switch expressions |

## BaseCubit implementation

Always extend `BaseCubit<S>` for consistent patterns:

```dart
import 'package:cmms_ship_flutter_app/core/presentation/cubit/base_cubit.dart';
import 'package:cmms_ship_flutter_app/features/graph/domain/usecases/create_node.dart';
import 'package:cmms_ship_flutter_app/features/graph/presentation/cubit/create_node_state.dart';

/// Cubit for managing node creation flow.
///
/// Responsibilities:
/// - Manages Loading → Success/Error state transitions
/// - Delegates business logic to CreateNode use case
/// - Provides consistent error handling via BaseCubit
class CreateNodeCubit extends BaseCubit<CreateNodeState> {
  CreateNodeCubit({
    required CreateNode createNodeUseCase,
  }) : _createNodeUseCase = createNodeUseCase,
       super(const CreateNodeInitial());

  final CreateNode _createNodeUseCase;

  /// Creates a new node as child of parent.
  ///
  /// Emits: Loading → Success | Error
  Future<void> createNode({
    required Node parent,
    required String name,
    String? description,
  }) async {
    await executeUseCase(
      useCase: () => _createNodeUseCase(CreateNodeParams(
        parentNode: parent,
        name: NodeName(name),
        description: description,
        projectId: parent.projectId,
        type: NodeType.child,
      )),
      onLoading: () => const CreateNodeLoading(),
      onSuccess: (node) => CreateNodeSuccess(node),
      onError: (message) => CreateNodeError(message),
    );
  }
}
```

## BaseCubit methods

### executeUseCase

Standard flow with Loading state:

```dart
/// Loading → Execute → Success/Error
await executeUseCase(
  useCase: () => _loadNodesUseCase(params),
  onLoading: () => const GraphLoading(),
  onSuccess: (nodes) => GraphLoaded(nodes: nodes, relations: []),
  onError: (message) => GraphError(message),
);
```

### executeUseCaseSilent

Without automatic Loading state (for background operations):

```dart
/// Execute silently → callback emits state
await executeUseCaseSilent(
  useCase: () => _refreshDataUseCase(params),
  onSuccess: (data) {
    // Must emit manually
    emit(DataRefreshed(data));
  },
  onError: (message) {
    // Must emit manually
    emit(RefreshError(message));
  },
);
```

### executeUseCasesSequentially

Chain multiple use cases (stops on first error):

```dart
/// Execute in order, stop on first failure
await executeUseCasesSequentially(
  useCases: [
    () => _validateNodeUseCase(validateParams),
    () => _createNodeUseCase(createParams),
    () => _createRelationUseCase(relationParams),
  ],
  onLoading: () => const NodeCreationLoading(),
  onAllSuccess: (results) => NodeCreationSuccess(),
  onError: (message) => NodeCreationError(message),
);
```

### Method comparison

| Method | Loading State | Use Case |
|--------|---------------|----------|
| `executeUseCase` | Automatic | Standard CRUD operations |
| `executeUseCaseSilent` | Manual | Background refresh, silent updates |
| `executeUseCasesSequentially` | Automatic | Multi-step operations |

## State classes with sealed pattern

Use Dart 3.0+ sealed classes for exhaustive handling:

```dart
import 'package:equatable/equatable.dart';

/// Sealed state hierarchy for CreateNode flow.
///
/// Sealed enables exhaustive switch expressions in widgets.
sealed class CreateNodeState extends Equatable {
  const CreateNodeState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state before any action.
class CreateNodeInitial extends CreateNodeState {
  const CreateNodeInitial();
}

/// Loading state during node creation.
class CreateNodeLoading extends CreateNodeState {
  const CreateNodeLoading();
}

/// Success state with created node.
class CreateNodeSuccess extends CreateNodeState {
  final Node node;
  
  const CreateNodeSuccess(this.node);
  
  @override
  List<Object?> get props => [node];
}

/// Error state with message.
class CreateNodeError extends CreateNodeState {
  final String message;
  
  const CreateNodeError(this.message);
  
  @override
  List<Object?> get props => [message];
}
```

## Complex state with preserved fields

For states that need to preserve data across operations:

```dart
/// Loaded state with UI preservation fields.
class GraphLoaded extends GraphState {
  final List<Node> nodes;
  final List<Relation> relations;
  final String? selectedNodeId;  // Preserved across reloads
  final bool isExpanded;         // UI state preservation
  
  const GraphLoaded({
    required this.nodes,
    required this.relations,
    this.selectedNodeId,
    this.isExpanded = true,
  });
  
  @override
  List<Object?> get props => [nodes, relations, selectedNodeId, isExpanded];
  
  /// Create copy preserving UI state.
  GraphLoaded copyWith({
    List<Node>? nodes,
    List<Relation>? relations,
    String? selectedNodeId,
    bool? isExpanded,
  }) => GraphLoaded(
    nodes: nodes ?? this.nodes,
    relations: relations ?? this.relations,
    selectedNodeId: selectedNodeId ?? this.selectedNodeId,
    isExpanded: isExpanded ?? this.isExpanded,
  );
}
```

### Preserving state across reloads

```dart
class GraphCubit extends BaseCubit<GraphState> {
  /// Reloads nodes while preserving selection state.
  Future<void> reloadNodes(String projectId) async {
    // Capture UI state before reload
    final previousState = state;
    final preservedSelection = previousState is GraphLoaded 
        ? previousState.selectedNodeId 
        : null;
    
    await executeUseCase(
      useCase: () => _loadNodesUseCase(LoadNodesParams(projectId: projectId)),
      onLoading: () => const GraphLoading(),
      onSuccess: (data) => GraphLoaded(
        nodes: data.nodes,
        relations: data.relations,
        selectedNodeId: preservedSelection,  // Restore selection
      ),
      onError: (message) => GraphError(message),
    );
  }
}
```

## Widget integration with switch expressions

Use Dart 3.0+ switch expressions for exhaustive handling:

```dart
class CreateNodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateNodeCubit, CreateNodeState>(
      builder: (context, state) => switch (state) {
        CreateNodeInitial() => const CreateNodeForm(),
        CreateNodeLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        CreateNodeSuccess(:final node) => NodeCreatedView(node: node),
        CreateNodeError(:final message) => ErrorView(
          message: message,
          onRetry: () => context.read<CreateNodeCubit>().retry(),
        ),
      },
    );
  }
}
```

## BlocListener for side effects

Use BlocListener for navigation, snackbars, dialogs:

```dart
class CreateNodeListener extends StatelessWidget {
  final Widget child;
  
  const CreateNodeListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateNodeCubit, CreateNodeState>(
      listener: (context, state) => switch (state) {
        CreateNodeSuccess(:final node) => _onSuccess(context, node),
        CreateNodeError(:final message) => _onError(context, message),
        _ => null,  // No action for other states
      },
      child: child,
    );
  }

  void _onSuccess(BuildContext context, Node node) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Created: ${node.name.value}')),
    );
    Navigator.of(context).pop(node);
  }

  void _onError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
```

## Multi-cubit coordination

For screens with multiple cubits:

```dart
class NodeDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<NodeDetailsCubit>()..load(nodeId)),
        BlocProvider(create: (_) => sl<GeneralDataCubit>()..load(nodeId)),
        BlocProvider(create: (_) => sl<MaintenanceDataCubit>()..load(nodeId)),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<NodeDetailsCubit, NodeDetailsState>(
            listener: _handleNodeDetailsState,
          ),
          BlocListener<GeneralDataCubit, GeneralDataState>(
            listener: _handleGeneralDataState,
          ),
        ],
        child: const NodeDetailsView(),
      ),
    );
  }
}
```

## Testing cubits

```dart
void main() {
  late CreateNodeCubit cubit;
  late MockCreateNode mockCreateNode;

  setUp(() {
    mockCreateNode = MockCreateNode();
    cubit = CreateNodeCubit(createNodeUseCase: mockCreateNode);
  });

  tearDown(() => cubit.close());

  blocTest<CreateNodeCubit, CreateNodeState>(
    'emits [Loading, Success] when creation succeeds',
    build: () {
      when(() => mockCreateNode(any())).thenAnswer(
        (_) async => Right(testNode),
      );
      return cubit;
    },
    act: (cubit) => cubit.createNode(
      parent: testParentNode,
      name: 'Test Node',
    ),
    expect: () => [
      const CreateNodeLoading(),
      CreateNodeSuccess(testNode),
    ],
  );

  blocTest<CreateNodeCubit, CreateNodeState>(
    'emits [Loading, Error] when creation fails',
    build: () {
      when(() => mockCreateNode(any())).thenAnswer(
        (_) async => Left(Failure(message: 'Creation failed')),
      );
      return cubit;
    },
    act: (cubit) => cubit.createNode(
      parent: testParentNode,
      name: 'Test Node',
    ),
    expect: () => [
      const CreateNodeLoading(),
      const CreateNodeError('Creation failed'),
    ],
  );
}
```

## Key rules

### Required practices

| Practice | Reason |
|----------|--------|
| Extend `BaseCubit<S>` | Consistent error handling, logging |
| Use `executeUseCase()` | Automatic Loading → Success/Error flow |
| Sealed state classes | Exhaustive switch expressions |
| All states extend Equatable | Smart emission, 40-60% fewer rebuilds |
| Private use case fields | Encapsulation (`_createNodeUseCase`) |
| Switch expressions in widgets | Type-safe exhaustive handling |

### Prohibited practices

| Practice | Reason | Alternative |
|----------|--------|-------------|
| Business logic in Cubit | SRP violation | Move to UseCase |
| Direct repository access | Clean Architecture violation | Inject UseCase |
| Manual `emit()` in `executeUseCase` | Double emission | Use callback return |
| Missing props in Equatable | Broken equality | Include ALL fields |
| if-else chains for state | Not exhaustive | Switch expressions |

## Related skills

- [flutter-clean-architecture](../flutter-clean-architecture/SKILL.md) - Overall architecture
- [flutter-dart3-patterns](../flutter-dart3-patterns/SKILL.md) - Sealed classes, switch expressions
- [flutter-di-getit](../flutter-di-getit/SKILL.md) - Cubit registration
