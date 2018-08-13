import 'package:flutter/material.dart';
import 'screens/news_list.dart';
import 'screens/news_detail.dart';
import 'blocs/stories_provider.dart';
import 'blocs/comments_provider.dart';

class App extends StatelessWidget {
  Widget build(context) {
    // add blocs to app
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: 'News',
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          final storiesBloc = StoriesProvider.of(context);
          storiesBloc.fetchTopIds();
          return NewsList();
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          final commentsBloc = CommentsProvider.of(context);
          // name = '/12344'
          final itemId = int.parse(settings.name.replaceFirst('/', ''));

          // fetch data
          commentsBloc.fetchItemWithComments(itemId);

          return NewsDetail(
            itemId: itemId,
          );
        },
      );
    }
  }
}
