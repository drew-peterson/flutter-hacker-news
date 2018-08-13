import 'package:http/http.dart' show Client;
import 'dart:convert'; // json
import 'dart:async'; // for Future
import '../models/item_model.dart';
import 'repository.dart';

final _root =
    'https://hacker-news.firebaseio.com/v0'; // private to this file only

class NewsApiProvider implements Source {
  Client client =
      Client(); // use client instead of get because we want to override for testing.

  Future<List<int>> fetchTopIds() async {
    final response = await client.get('$_root/topstories.json');
    final ids = json.decode(response.body);

    // dart doesnt know whats inside the decoded list its knows List<dynamic>
    // to get dart to understand we cast the return -- you have to look at type cast methods
    return ids.cast<int>();
  }

  // without Future it will give error about future
  Future<ItemModel> fetchItem(int id) async {
    final response = await client.get('$_root/item/$id.json');
    final parsedJson = json.decode(response.body);
    return ItemModel.fromJson(parsedJson);
  }
}
