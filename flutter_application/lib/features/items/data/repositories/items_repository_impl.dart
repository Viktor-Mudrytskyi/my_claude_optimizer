import 'package:dartz/dartz.dart';

import 'package:flutter_application/core/error/failure.dart';
import 'package:flutter_application/core/helper/type_aliases.dart';
import 'package:flutter_application/features/items/domain/entities/item.dart';
import 'package:flutter_application/features/items/domain/entities/paginated_result.dart';
import 'package:flutter_application/features/items/domain/repositories/items_repository.dart';

class ItemsRepositoryImpl implements ItemsRepository {
  static const int _totalItems = 95;

  @override
  FutureFailable<PaginatedResult<Item>> getItems({
    required int page,
    required int pageSize,
  }) async {
    try {
      // Simulate network delay
      await Future<void>.delayed(const Duration(milliseconds: 800));

      final startIndex = page * pageSize;
      final endIndex = (startIndex + pageSize).clamp(0, _totalItems);
      final hasMore = endIndex < _totalItems;

      final items = List.generate(
        endIndex - startIndex,
        (i) {
          final index = startIndex + i;
          return _createItem(index);
        },
      );

      return Right(PaginatedResult(
        items: items,
        currentPage: page,
        hasMore: hasMore,
      ));
    } catch (e) {
      return const Left(Failure(message: 'Failed to load items'));
    }
  }

  @override
  FutureFailable<Item> getItemById({required String id}) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 400));

      final indexStr = id.split('_').last;
      final index = int.tryParse(indexStr);
      if (index == null || index < 0 || index >= _totalItems) {
        return const Left(Failure(message: 'Item not found'));
      }

      return Right(_createItem(index));
    } catch (e) {
      return const Left(Failure(message: 'Failed to load item'));
    }
  }

  static Item _createItem(int index) {
    return Item(
      id: 'item_$index',
      title: 'Item #${index + 1}',
      description: 'Description for item #${index + 1}',
      createdAt: DateTime(2026, 1, 1).add(Duration(days: index)),
    );
  }
}
