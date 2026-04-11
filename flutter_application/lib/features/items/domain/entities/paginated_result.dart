import 'package:equatable/equatable.dart';

class PaginatedResult<T> extends Equatable {
  final List<T> items;
  final int currentPage;
  final bool hasMore;

  const PaginatedResult({
    required this.items,
    required this.currentPage,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [items, currentPage, hasMore];
}
