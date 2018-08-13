// import from outside lib directory dont need relative reference but use package
import 'package:news/src/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  test('fetchTopIds returns list of ids', () async {
    final newsApi = NewsApiProvider();

    newsApi.client = MockClient((request) async {
      return Response(json.encode([1, 2, 3, 4]), 200);
    });

    final ids = await newsApi.fetchTopIds();

    expect(ids, [1, 2, 3, 4]);
  });

  test('fetchItem returns ItemModel', () async {
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      final jsonMap = {'id': 999};
      return Response(json.encode(jsonMap), 200);
    });

    final item = await newsApi.fetchItem(999);

    expect(item.id, 999);
  });
}
