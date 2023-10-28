import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children:
          [
            Text(
              'Search Screen',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,

              ),
            ),
          ],
        ),
      ),
    );
  }
}