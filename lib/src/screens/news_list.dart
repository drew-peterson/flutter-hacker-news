import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';
import '../widgets/news_list_tile.dart';
import '../widgets/refresh.dart';

class NewsList extends StatelessWidget {
  Widget build(BuildContext context) {
    // get access to storiesProvier and share context/location in app
    final bloc = StoriesProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Top News'),
      ),
      body: buildList(bloc),
    );
  }

  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
      stream: bloc.topIds,
      builder: (context, AsyncSnapshot<List<int>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Loading....'),
                Container(height: 10.0),
                CircularProgressIndicator(),
              ],
            ),
          );
        }

        // we call api then cache data, so we call api once..
        // since we cache data we need to clear out the cache and refetch new data
        // pull down to refresh data
        return Refresh(
          child: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, int index) {
              bloc.fetchItem(snapshot.data[index]); // list of ids...
              // intial fetch amount is based off how many items can fit on screen
              // we need to place default loading containers that match data so
              // that loadingContainer is used to count how many fix on screen
              // without loadContainer it will try to fetch 50+ instead of 11

              return NewsListTile(itemId: snapshot.data[index]);
            },
          ),
        );
      },
    );
  }
}
