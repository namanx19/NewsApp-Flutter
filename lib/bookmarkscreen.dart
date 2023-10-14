import 'package:flutter/material.dart';
import 'package:news_app/constants.dart';
import 'package:news_app/body.dart';

import 'networking.dart';

class BookmarkedNewsScreen extends StatelessWidget {
  final List<NewsItem> bookmarkedNews;

  BookmarkedNewsScreen({required this.bookmarkedNews});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF0F0F0),
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        centerTitle: true,
        title: Text(
          'Bookmarked News',
          style: kTextStyle.copyWith(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: bookmarkedNews.isEmpty
          ? const Center(
        child: Text(
          'No current bookmarks',
          style: kTextStyle,
        ),
      )
          : ListView.builder(
        itemCount: bookmarkedNews.length,
        itemBuilder: (context, index) {
          return NewsCard(
            imageUrl: bookmarkedNews[index].imageUrl,
            title: bookmarkedNews[index].title,
            description: bookmarkedNews[index].description,
            author: bookmarkedNews[index].author,
            url: bookmarkedNews[index].url,
            onBookmark: () {}, // Disable bookmarking on this screen
          );
        },
      ),
    );
  }
}
