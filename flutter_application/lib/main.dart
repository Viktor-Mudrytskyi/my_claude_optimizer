import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_application/features/items/data/repositories/items_repository_impl.dart';
import 'package:flutter_application/features/items/domain/usecases/load_items.dart';
import 'package:flutter_application/features/items/presentation/cubit/items_cubit.dart';
import 'package:flutter_application/features/items/presentation/screens/items_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => ItemsCubit(
          loadItems: LoadItems(ItemsRepositoryImpl()),
        ),
        child: const ItemsScreen(),
      ),
    );
  }
}
