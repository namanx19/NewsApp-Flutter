import 'package:flutter/material.dart';
import 'networking.dart';
import 'body.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2C3333),
          centerTitle: true,
          title: Text('NewsApp'),
        ),
        body: NewsScreen(),
      ),
    );
  }
}

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final String apiUrl = 'https://candidate-test-data-moengage.s3.amazonaws.com/Android/news-api-feed/staticResponse.json';

  String selectedSortOption = 'Latest to Oldest';

  List<NewsItem> newsItems = [];

  void _sortNews(String sortOption) {
    if (sortOption == 'Latest to Oldest') {
      newsItems.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    } else {
      newsItems.sort((a, b) => a.publishedAt.compareTo(b.publishedAt));
    }
  }

  void fetchNews() async {
    try {
      Networking networking = Networking(apiUrl);
      List<NewsItem> fetchedNews = await networking.getNews();

      setState(() {
        newsItems = fetchedNews;
        _sortNews(selectedSortOption); // Call _sortNews with the selected option
      });
    } catch (e) {
      print('Error fetching news: $e');
    }
  }

  void _onChangedSortOption(String newValue) {
    setState(() {
      selectedSortOption = newValue;
      _sortNews(selectedSortOption);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sort dropdown
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sort'),
              SizedBox(width: 10.0),
              DropdownButton<String>(
                value: selectedSortOption,
                items: <String>['Latest to Oldest', 'Oldest to Latest']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    _onChangedSortOption(newValue);
                  }
                },
              ),

            ],
          ),
        ),
        // News list
        Expanded(
          child: ListView.builder(
            itemCount: newsItems.length,
            itemBuilder: (context, index) {
              return NewsCard(
                imageUrl: newsItems[index].imageUrl,
                title: newsItems[index].title,
                description: newsItems[index].description,
              );
            },
          ),
        ),
      ],
    );
  }
}
