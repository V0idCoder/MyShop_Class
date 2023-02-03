import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../screens/add_edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.deleteMethod,
  });

  final String id;
  final String title;
  final String imageUrl;
  final Function(String) deleteMethod;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(imageUrl),
      ),
      title: Text(title),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(AddEditProductScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => deleteMethod(id),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
