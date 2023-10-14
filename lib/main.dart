import 'package:flutter/material.dart';
import 'package:news_app/constants.dart';
import 'networking.dart';
import 'body.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


void main() {
  runApp(NewsAppMain());
}

class NewsAppMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0XFFF0F0F0),
        appBar: AppBar(
          backgroundColor: const Color(0xFF2C3333),
          centerTitle: true,
          title: Text(
              'News App - MoEngage',
            style: kTextStyle.copyWith(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
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
  bool isLoading = true;  // Track loading state
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
        isLoading = false;
        newsItems = fetchedNews;
        _sortNews(selectedSortOption); // Call _sortNews with the selected option
      });
    } catch (e) {
      print('Error fetching news: $e');
      setState(() {
        isLoading = false;  // Set loading state to false in case of an error
      });
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
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 220,  // Adjust width as needed
            height: 40,  // Adjust height as needed
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20.0),  // Adjust border radius
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 6.0,),
                const Text('Sort:'),
                const SizedBox(width: 10.0),
                DropdownButton<String>(
                  value: selectedSortOption,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 12,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _onChangedSortOption(newValue);
                    }
                  },
                  items: <String>['Latest to Oldest', 'Oldest to Latest']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                )

                //Original Sorting Dropdown
                // DropdownButton<String>(
                //   value: selectedSortOption,
                //   items: <String>['Latest to Oldest', 'Oldest to Latest']
                //       .map((String value) {
                //     return DropdownMenuItem<String>(
                //       value: value,
                //       child: Text(value),
                //     );
                //   }).toList(),
                //   onChanged: (String? newValue) {
                //     if (newValue != null) {
                //       _onChangedSortOption(newValue);
                //     }
                //   },
                // ),

              ],
            ),
          ),
        ),
        // News list
        // Loading indicator and text
        isLoading
            ? Center(
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  const SpinKitFadingFour(
                    color: const Color(0xFF2C3333),  // Adjust color as needed
                    size: 70.0,  // Adjust size as needed
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Getting the latest news for you',
                    style: kTextStyle.copyWith(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
            : Expanded(
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