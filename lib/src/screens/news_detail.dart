import 'package:flutter/material.dart';
import '../blocs/comments_provider.dart';
import '../models/item_model.dart';
import 'dart:async';
import '../widgets/comment.dart';

class NewsDetail extends StatelessWidget {
  final int itemId;

  NewsDetail({this.itemId});

  Widget build(context) {
    // adds back button automatically
    final bloc = CommentsProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemWithComments,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Text('loading....');
        }

        final itemFuture = snapshot.data[itemId];

        return FutureBuilder(
          future: itemFuture,
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return Text('loading $itemId');
            }
            return buildList(itemSnapshot.data, snapshot.data);
          },
        );
      },
    );
  }

  Widget buildTitle(ItemModel item) {
    // container by default size to fit the largest widget so center is not centered
    return Container(
      margin: EdgeInsets.all(10.0),
      alignment: Alignment.topCenter, // stretch container and topCenter
      child: Text(
        item.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildList(ItemModel item, Map<int, Future<ItemModel>> itemMap) {
    final children = <Widget>[];
    children.add(buildTitle(item));
    final commentsList = item.kids.map((kidId) {
      return Comment(
        itemId: kidId,
        itemMap: itemMap,
        depth: 1,
      );
    }).toList(); // returns iterable so we have to convert

    children.addAll(commentsList); // how you merge all items into list

    return ListView(children: children);
  }
}
