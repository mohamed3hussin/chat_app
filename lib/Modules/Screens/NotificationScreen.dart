import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Column(
          children:
          [
            Text(
              'Notification Screen',
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