import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';
import 'dart:async';

class StoriesBloc {
  // sink: incoming requests to change data
  // stream: outgoing data to be constumed by widgets
  final _repository = Repository();
  // from rxdart - streamController - returns observable rather then stream
  final _topIds = PublishSubject<List<int>>();
  // RxDart streamcontroller, anything new will emit most recent
  // listen to unlimted times
  // new event is broadcasted one at a time and goes streamSubscription > transformer > streambuilder for each NewsListTile
  // bad because our transformer is cacheing and making network request or db request.
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  // add items to itemFetch sink > transform > pipe > itemsOutPut > stream > widget
  // we want to transform only once so have 2 streamControllers and pipe results after transform to listener for widgets
  final _itemsFetcher = PublishSubject<int>(); //

  // getters to streams - expose to app
  Observable<List<int>> get topIds => _topIds.stream;
  Observable<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  // getter to Sinks
  Function(int) get fetchItem => _itemsFetcher.sink.add;

  // contructor...
  StoriesBloc() {
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  clearCache() {
    return _repository.clearCache(); // we return async await which is a future
  }

  _itemsTransformer() {
    return ScanStreamTransformer(
      // invoked whenever new item comes acrossed stream
      // cache is set my intial and remebered
      // id is what we add to stream
      (Map<int, Future<ItemModel>> cache, int id, index) {
        // print(index);
        cache[id] = _repository.fetchItem(id); // look in db or api
        return cache;
      },
      <int, Future<ItemModel>>{}, // intial value
    );
  }

  // have to cleanup...
  dispose() {
    _topIds.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}
