import 'package:flutter/material.dart';
import 'constants.dart';

class BookmarkedNewsScreen extends StatelessWidget {
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
      body: const Center(
        child: Text(
          'Bookmarked News Screen Content',
          style: kTextStyle,
        ),
      ),
    );
  }
}
