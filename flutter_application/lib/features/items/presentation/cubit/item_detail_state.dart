part of 'item_detail_cubit.dart';

sealed class ItemDetailState extends Equatable {
  const ItemDetailState();

  @override
  List<Object?> get props => [];
}

class ItemDetailInitial extends ItemDetailState {
  const ItemDetailInitial();
}

class ItemDetailLoading extends ItemDetailState {
  const ItemDetailLoading();
}

class ItemDetailLoaded extends ItemDetailState {
  final Item item;

  const ItemDetailLoaded({required this.item});

  @override
  List<Object?> get props => [item];
}

class ItemDetailError extends ItemDetailState {
  final String message;

  const ItemDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
