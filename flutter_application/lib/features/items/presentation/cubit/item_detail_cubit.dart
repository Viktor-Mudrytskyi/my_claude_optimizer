import 'package:equatable/equatable.dart';

import 'package:flutter_application/core/presentation/cubit/base_cubit.dart';
import 'package:flutter_application/features/items/domain/entities/item.dart';
import 'package:flutter_application/features/items/domain/usecases/get_item.dart';

part 'item_detail_state.dart';

class ItemDetailCubit extends BaseCubit<ItemDetailState> {
  final GetItem _getItem;

  ItemDetailCubit({required GetItem getItem})
      : _getItem = getItem,
        super(const ItemDetailInitial());

  Future<void> loadItem({required String id}) async {
    await executeUseCase(
      useCase: () => _getItem(GetItemParams(id: id)),
      onLoading: () => const ItemDetailLoading(),
      onSuccess: (item) => ItemDetailLoaded(item: item),
      onError: (message) => ItemDetailError(message),
    );
  }
}
