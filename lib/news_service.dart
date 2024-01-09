import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  final String apiKey;

  NewsService(this.apiKey);

  Future<List<dynamic>> getNews({
    List<String> category = const [
      'general',
      'business',
      'entertainment',
      'sports',
      'Technology'
    ],
    List<String> country = const ['us', 'in', 'au'],
    String language = 'en',
    int pageSize = 10,
  }) async {
    final Uri uri = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=in&apiKey=12ab8d78fc184ce9a39fe5ac08bbc4fa');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> articles = data['articles'];
      return articles;
    } else {
      throw Exception('Failed to load news');
    }
  }
}
