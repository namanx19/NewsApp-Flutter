import 'package:http/http.dart' as http;
import 'dart:convert';

class Networking {
  final String baseUrl;

  Networking(this.baseUrl);

  Future<List<NewsItem>> getNews() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> articles = jsonResponse['articles'];

      List<NewsItem> newsList = articles.map((json) {
        return NewsItem.fromJson(json);
      }).toList();

      return newsList;
    } else {
      throw Exception('Failed to load news');
    }
  }
}

class NewsItem {
  final String imageUrl;
  final String title;
  final String description;
  final DateTime publishedAt;
  final String author;
  final String url;

  NewsItem({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.publishedAt,
    required this.author,
    required this.url,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    String originalUrl = json['url'];
    String secureUrl = originalUrl.replaceAll('http://', 'https://');
    return NewsItem(
      imageUrl: json['urlToImage'],
      title: json['title'],
      description: json['description'],
      publishedAt: DateTime.parse(json['publishedAt']),
      author: json['author'] ?? 'Unknown',
      url: secureUrl,
    );
  }
}
