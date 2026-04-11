import 'package:flutter_application/core/helper/type_aliases.dart';
import 'package:flutter_application/features/items/domain/entities/item.dart';
import 'package:flutter_application/features/items/domain/entities/paginated_result.dart';

abstract class ItemsRepository {
  FutureFailable<PaginatedResult<Item>> getItems({
    required int page,
    required int pageSize,
  });

  FutureFailable<Item> getItemById({required String id});
}
