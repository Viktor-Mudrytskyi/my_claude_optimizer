import 'package:flutter/material.dart';

import 'package:flutter_application/features/items/domain/entities/item.dart';

class ItemCardWidget extends StatelessWidget {
  final Item item;

  const ItemCardWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(item.id.split('_').last),
        ),
        title: Text(item.title),
        subtitle: Text(item.description),
        trailing: Text(
          '${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
