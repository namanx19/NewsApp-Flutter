import 'package:http/http.dart' as http;
import 'dart:convert'; //Used to parse the json files and extract data from it

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
      throw Exception('Failed to load news'); //Handled all the cases so the app doesn't crashes
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


  //used jsondecode to extract data from the api link and use this data across our app
  factory NewsItem.fromJson(Map<String, dynamic> json) {
    String originalUrl = json['url'];
    String secureUrl = originalUrl.replaceAll('http://', 'https://');
    return NewsItem(
      imageUrl: json['urlToImage'],
      title: json['title'],
      description: json['description'],
      publishedAt: DateTime.parse(json['publishedAt']),
      author: json['author'] ?? 'Unknown', //In some news the author wasn't mentioned so used 'Unknown' so that the app doesn't crash
      url: secureUrl,
    );
  }
}
