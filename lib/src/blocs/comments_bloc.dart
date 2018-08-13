import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class CommentsBloc {
  final _repository = Repository();

  final _commentsFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  // Streams
  Observable<Map<int, Future<ItemModel>>> get itemWithComments =>
      _commentsOutput.stream;

  // Sink
  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  //Constructor
  CommentsBloc() {
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  //Transformer
  _commentsTransformer() {
    // id of storie we want to fetch
    //sink > transformer > fetch that child > recurrsively look at that childs kids > repeate
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
      (cache, int id, index) {
        // print('_commentsTransformer $index');
        // fetch data and save to cache
        cache[id] = _repository.fetchItem(id);

        cache[id].then((ItemModel item) {
          item.kids.forEach((kidId) => fetchItemWithComments(kidId));
        });
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }

  dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}
