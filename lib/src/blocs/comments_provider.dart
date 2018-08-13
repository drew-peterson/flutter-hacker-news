import 'package:flutter/material.dart';
import 'comments_bloc.dart';
export 'comments_bloc.dart'; // so when we import provider you get stories

class CommentsProvider extends InheritedWidget {
  final CommentsBloc bloc;

  // boilerplate for provider /bloc setup....
  CommentsProvider({Key key, Widget child})
      : bloc = CommentsBloc(),
        super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static CommentsBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(CommentsProvider)
            as CommentsProvider)
        .bloc;
  }
}
