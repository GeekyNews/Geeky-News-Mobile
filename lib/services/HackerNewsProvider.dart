import 'dart:async';
import 'package:geeky_news_mobile/models/HackerNewsItem.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert' show json, utf8;

class HackerNewsProvider {
  final baseUrl = "https://hacker-news.firebaseio.com/v0";
  final _httpClient= HttpClient();


  /// Fetches and decodes a JSON object represented as a Dart [Map].
  ///
  /// Returns null if the API server is down, or the response is not JSON.
  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try {
      final httpRequest = await _httpClient.getUrl(uri);
      final httpResponse = await httpRequest.close();
      if (httpResponse.statusCode != HttpStatus.OK) {
        return null;
      }
      // The response is sent as a Stream of bytes that we need to convert to a
      // `String`.
      final responseBody = await httpResponse.transform(utf8.decoder).join();
      // Finally, the string is parsed into a JSON object.
      print(responseBody);

      return json.decode(responseBody);
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }

  Future<List> _getList(Uri uri) async {
    try {
      final httpRequest = await _httpClient.getUrl(uri);
      final httpResponse = await httpRequest.close();
      if (httpResponse.statusCode != HttpStatus.OK) {
        return null;
      }
      // The response is sent as a Stream of bytes that we need to convert to a
      // `String`.
      final responseBody = await httpResponse.transform(utf8.decoder).join();
      // Finally, the string is parsed into a JSON object.

      return json.decode(responseBody);
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }


  Future<List<int>> getLatestNews() async {
    var resquestString = "$baseUrl/newstories.json";

    final response = await http.get(resquestString);
    final statusCode = response.statusCode;

    if (statusCode < 200 || statusCode >= 300 || response.body == null) {
//      throw new FetchDataException(
         print("Error while getting stories [StatusCode:$statusCode]");
         return null;
    }
    final List storiesList = json.decode(response.body);
    return storiesList.cast<int>();
  }

  void getBestNews() {
    var resquestString = "$baseUrl/beststories.json";
  }

  void getHotNews() {
    var resquestString = "$baseUrl/topstories.json";
  }

  Future<HackerNewsItem> getItem(int id) async {
    var resquestString = "$baseUrl/item/$id.json";
    final response = await http.get(resquestString);
    final statusCode = response.statusCode;

    if (statusCode < 200 || statusCode >= 300 || response.body == null) {
//      throw new FetchDataException(
      print("Error while getting stories [StatusCode:$statusCode]");
      return null;
    }
    final Map data = json.decode(response.body);
//    print(data);
    final HackerNewsItem item = HackerNewsItem.fromJson(data);
    return item;
  }
}