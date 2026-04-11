import 'package:equatable/equatable.dart';

import 'package:flutter_application/core/helper/type_aliases.dart';
import 'package:flutter_application/features/items/domain/entities/item.dart';
import 'package:flutter_application/features/items/domain/entities/paginated_result.dart';
import 'package:flutter_application/features/items/domain/repositories/items_repository.dart';

class LoadItems {
  final ItemsRepository _repository;

  LoadItems(this._repository);

  FutureFailable<PaginatedResult<Item>> call(LoadItemsParams params) {
    return _repository.getItems(
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}

class LoadItemsParams extends Equatable {
  final int page;
  final int pageSize;

  const LoadItemsParams({
    required this.page,
    this.pageSize = 20,
  });

  @override
  List<Object?> get props => [page, pageSize];
}
