import 'package:flutter/material.dart';
import 'package:news_app/Utilities/constants.dart';
import 'package:news_app/Service/networking.dart';
import 'package:news_app/Screens/body.dart';
import 'package:news_app/Screens/bookmarkscreen.dart';
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
          backgroundColor: kAppBarColor,
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
  // Used for enabling and disabling Spinner
  bool isLoading = true;

  // API URL to fetch data
  final String apiUrl =
      'https://candidate-test-data-moengage.s3.amazonaws.com/Android/news-api-feed/staticResponse.json';

  String selectedSortOption = 'Latest to Oldest';

  List<NewsItem> newsItems = [];

  //Adding a Bookmark feature in the app
  List<NewsItem> bookmarkedNews = [];

  void _handleBookmark(NewsItem newsItem) {
    setState(() {
      if (bookmarkedNews.contains(newsItem)) {
        bookmarkedNews.remove(newsItem);
      } else {
        bookmarkedNews.add(newsItem);
      }
    });
  }

  //Sorting Functionality
  void _sortNews(String sortOption) {
    if (sortOption == 'Latest to Oldest') {
      newsItems.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    } else {
      newsItems.sort((a, b) => a.publishedAt.compareTo(b.publishedAt));
    }
  }

  //Fetches news using the networking model.
  void fetchNews() async {
    try {
      Networking networking = Networking(apiUrl);
      List<NewsItem> fetchedNews = await networking.getNews();

      setState(() {
        isLoading = false;
        newsItems = fetchedNews;
        _sortNews(selectedSortOption);
      });
    } catch (e) {
      print('Error fetching news: $e');
      setState(() {
        isLoading = false;
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


  //The UI of the main screen
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 220,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20.0),
                  ),

                  //Sorting Container Box
                  child: Row(
                    children: [
                      const Text('Sort:'),
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
                      ),
                    ],
                  ),
                ),
              ),

              //Bookmark Screen Access Icon
              IconButton(
                icon: const Icon(Icons.bookmark),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookmarkedNewsScreen(bookmarkedNews: bookmarkedNews)),
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: isLoading
              ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    const SpinKitFadingGrid(
                      color: Color(0xFF2C3333),
                      size: 50.0,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      'Getting the latest news for you!!',
                    style: kTextStyle.copyWith(
                    fontSize: 18.0,
                    ),
                  ),
                ],
              )

                //Used List View Builder to Create Beautiful News Cards
              : ListView.builder(
                itemCount: newsItems.length,
                itemBuilder: (context, index) {
                return NewsCard(
                  imageUrl: newsItems[index].imageUrl,
                  title: newsItems[index].title,
                  description: newsItems[index].description,
                  author: newsItems[index].author,
                  url: newsItems[index].url,
                  onBookmark: () {
                    _handleBookmark(newsItems[index]);
                  },
              );
            },
          ),
        ),
      ],
    );
  }
}

