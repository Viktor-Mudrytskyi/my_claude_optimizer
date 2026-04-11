import 'package:equatable/equatable.dart';

import 'package:flutter_application/core/helper/type_aliases.dart';
import 'package:flutter_application/features/items/domain/entities/item.dart';
import 'package:flutter_application/features/items/domain/repositories/items_repository.dart';

class GetItem {
  final ItemsRepository _repository;

  GetItem(this._repository);

  FutureFailable<Item> call(GetItemParams params) {
    return _repository.getItemById(id: params.id);
  }
}

class GetItemParams extends Equatable {
  final String id;

  const GetItemParams({required this.id});

  @override
  List<Object?> get props => [id];
}
