import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_application/features/items/presentation/cubit/items_cubit.dart';
import 'package:flutter_application/features/items/presentation/widgets/item_card_widget.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ItemsCubit>().loadInitial();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isNearBottom) {
      context.read<ItemsCubit>().loadMore();
    }
  }

  bool get _isNearBottom {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= maxScroll * 0.9;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Items')),
      body: BlocBuilder<ItemsCubit, ItemsState>(
        builder: (context, state) => switch (state) {
          ItemsInitial() => const SizedBox.shrink(),
          ItemsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          ItemsLoaded(:final items, :final hasMore) =>
            ListView.builder(
              controller: _scrollController,
              itemCount: items.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= items.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return ItemCardWidget(item: items[index]);
              },
            ),
          ItemsError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ItemsCubit>().loadInitial(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
        },
      ),
    );
  }
}
