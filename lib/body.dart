import 'package:flutter/material.dart';
import 'package:news_app/constants.dart';
import 'package:news_app/webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String author;
  final String url;

  NewsCard({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.author,
    required this.url,
  });

  void _openWebView(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(url: url),
      ),
    );
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
                    image: NetworkImage(imageUrl),
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
                    title,
                    style: kTextStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Author: $author',  // Display author
                    style: kTextStyle.copyWith(
                      fontSize: 10.0,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _openWebView(context, url);
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}