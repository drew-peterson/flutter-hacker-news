import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';
import 'dart:async';
import 'loading_container.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;

  NewsListTile({this.itemId});

  Widget build(context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer(); // used to represent container size in listBuilder to reduce fetch
        }

        return FutureBuilder(
          future: snapshot.data[itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return LoadingContainer(); // used to represent container size in listBuilder to reduce fetch
            }
            return buildTile(context, itemSnapshot.data);
          },
        );
      },
    );
  }

  Widget buildTile(BuildContext context, ItemModel item) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(item.title),
          subtitle: Text('${item.score} points'),
          trailing: Column(
            children: <Widget>[
              Icon(Icons.comment),
              Text('${item.descendants}'),
            ],
          ),
          onTap: () {
            // redirect to detail page
            Navigator.pushNamed(
                context, '/${item.id}'); // imported from material.dart
          },
        ),
        Divider(height: 8.0), // height above and below
      ],
    );
  }
}
