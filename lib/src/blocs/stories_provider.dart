import 'package:flutter/material.dart';
import 'stories_bloc.dart';
export 'stories_bloc.dart'; // so when we import provider you get stories

class StoriesProvider extends InheritedWidget {
  final StoriesBloc bloc;

  // boilerplate for provider /bloc setup....
  StoriesProvider({Key key, Widget child})
      : bloc = StoriesBloc(),
        super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static StoriesBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(StoriesProvider)
            as StoriesProvider)
        .bloc;
  }
}
