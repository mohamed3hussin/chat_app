import 'package:flutter/material.dart';

class UsersScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
        [
          Center(
            child: Text(
              'Users Screen',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,

              ),
            ),
          ),
        ],
      ),
    );
  }
}