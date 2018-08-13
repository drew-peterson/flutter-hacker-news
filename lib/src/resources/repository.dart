import 'dart:async';
import '../models/item_model.dart';
import 'news_api_provider.dart';
import 'news_db_provider.dart';

// switch to see if i need to get more news from api OR we already got it check db
class Repository {
  List<Source> sources = <Source>[
    newsDbProvider,
    NewsApiProvider(),
    //NewsMysterProvider -- add new providers in future
  ];

  List<Cache> caches = <Cache>[
    newsDbProvider,
  ];

  Future<List<int>> fetchTopIds() {
    // todo: iterate over sources when db gets fetchTopIds
    return sources[1].fetchTopIds();
  }

  Future<ItemModel> fetchItem(int id) async {
    ItemModel item;
    // Source source;
    var source; // untyped so cache != sources works.

    for (source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
    }

    for (var cache in caches) {
      if (cache != source) {
        cache.addItem(item);
      }
    }
    return item;
  }

  clearCache() async {
    for (var cache in caches) {
      await cache.clear();
    }
  }
}

// https://www.udemy.com/dart-and-flutter-the-complete-developers-guide/learn/v4/t/lecture/10875234?start=0
abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<int> clear();
}
