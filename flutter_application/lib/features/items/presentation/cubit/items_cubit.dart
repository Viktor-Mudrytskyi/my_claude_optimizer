import 'package:equatable/equatable.dart';

import 'package:flutter_application/core/presentation/cubit/base_cubit.dart';
import 'package:flutter_application/features/items/domain/entities/item.dart';
import 'package:flutter_application/features/items/domain/usecases/load_items.dart';

part 'items_state.dart';

class ItemsCubit extends BaseCubit<ItemsState> {
  final LoadItems _loadItems;

  ItemsCubit({required LoadItems loadItems})
      : _loadItems = loadItems,
        super(const ItemsInitial());

  Future<void> loadInitial() async {
    await executeUseCase(
      useCase: () => _loadItems(const LoadItemsParams(page: 0)),
      onLoading: () => const ItemsLoading(),
      onSuccess: (result) => ItemsLoaded(
        items: result.items,
        currentPage: result.currentPage,
        hasMore: result.hasMore,
      ),
      onError: (message) => ItemsError(message),
    );
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! ItemsLoaded ||
        !currentState.hasMore ||
        currentState.isLoadingMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;
    final result = await _loadItems(LoadItemsParams(page: nextPage));

    result.fold(
      (failure) => emit(currentState.copyWith(isLoadingMore: false)),
      (paginatedResult) => emit(ItemsLoaded(
        items: [...currentState.items, ...paginatedResult.items],
        currentPage: paginatedResult.currentPage,
        hasMore: paginatedResult.hasMore,
      )),
    );
  }
}
