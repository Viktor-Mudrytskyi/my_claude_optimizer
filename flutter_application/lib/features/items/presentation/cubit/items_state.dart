part of 'items_cubit.dart';

sealed class ItemsState extends Equatable {
  const ItemsState();

  @override
  List<Object?> get props => [];
}

class ItemsInitial extends ItemsState {
  const ItemsInitial();
}

class ItemsLoading extends ItemsState {
  const ItemsLoading();
}

class ItemsLoaded extends ItemsState {
  final List<Item> items;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  const ItemsLoaded({
    required this.items,
    required this.currentPage,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [items, currentPage, hasMore, isLoadingMore];

  ItemsLoaded copyWith({
    List<Item>? items,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) =>
      ItemsLoaded(
        items: items ?? this.items,
        currentPage: currentPage ?? this.currentPage,
        hasMore: hasMore ?? this.hasMore,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}

class ItemsError extends ItemsState {
  final String message;

  const ItemsError(this.message);

  @override
  List<Object?> get props => [message];
}
