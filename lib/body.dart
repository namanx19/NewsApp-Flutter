import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news_app/constants.dart';
import 'package:news_app/webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'bookmarkscreen.dart';
import 'networking.dart';

class NewsCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String author;
  final String url;
  final Function onBookmark; // Function to handle bookmarking

  NewsCard({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.author,
    required this.url,
    required this.onBookmark,
  });

  @override
  _NewsCardState createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  bool isBookmarked = false;

  void _openWebView(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(url: url),
      ),
    );
  }

  void _toggleBookmark() {
    setState(() {
      isBookmarked = !isBookmarked;
      widget.onBookmark(); // Call the provided callback to handle bookmarking
    });
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, // Card color
      elevation: 30.0,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Image (Centered)
            Center(
              child: Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.imageUrl),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16.0), // Add some spacing between image and text
            // Title, Author, and Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.title,
                    style: kTextStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Author: ${widget.author}',  // Display author
                    style: kTextStyle.copyWith(
                      fontSize: 10.0,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _openWebView(context, widget.url);
                              },
                              child: Text(
                                'Full Article',
                                style: kTextStyle.copyWith(
                                  color: Colors.blue,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            const Icon(
                              Icons.keyboard_double_arrow_right,
                              color: Colors.blue,
                              size: 20.0,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked ? Colors.blue : Colors.grey,
                        ),
                        onPressed: () {
                          _toggleBookmark();
                          widget.onBookmark(); // Call the provided callback to handle bookmarking
                        },
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  // List to hold bookmarked news
  List<NewsItem> bookmarkedNews = [];

  // Function to handle adding/removing from bookmarks
  void _handleBookmark(NewsItem newsItem) {
    setState(() {
      if (bookmarkedNews.contains(newsItem)) {
        bookmarkedNews.remove(newsItem);
      } else {
        bookmarkedNews.add(newsItem);
      }
    });
  }

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
                color: Color(0xFF2C3333), // Change the color if needed
                size: 50.0, // Adjust size if needed
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
