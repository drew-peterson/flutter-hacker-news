import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';

// pull down to refresh widget

class Refresh extends StatelessWidget {
  final Widget child;

  Refresh({this.child});

  Widget build(context) {
    final bloc = StoriesProvider.of(context);

    return RefreshIndicator(
      child: child,
      onRefresh: () async {
        // we await to tell onRefresh to show indicator until finished
        await bloc.clearCache();
        await bloc.fetchTopIds();
      },
    );
  }
}
