import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_application/features/items/data/repositories/items_repository_impl.dart';
import 'package:flutter_application/features/items/domain/usecases/load_items.dart';
import 'package:flutter_application/features/items/presentation/cubit/items_cubit.dart';
import 'package:flutter_application/features/items/presentation/screens/items_screen.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/items',
    routes: [
      GoRoute(
        path: '/items',
        name: 'items',
        builder: (context, state) => BlocProvider(
          create: (_) => ItemsCubit(
            loadItems: LoadItems(ItemsRepositoryImpl()),
          ),
          child: const ItemsScreen(),
        ),
      ),
    ],
  );
}
