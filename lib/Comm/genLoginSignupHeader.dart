import 'package:flutter/material.dart';

class genLoginSignupHeader extends StatelessWidget {
  String headerName;

  genLoginSignupHeader(this.headerName);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 50.0),
          Text(
            headerName,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigo[300],
                fontSize: 40.0),
          ),
          SizedBox(height: 10.0),
          Image.asset(
            "assets/images/logo.png",
            height: 150.0,
            width: 150.0,
          ),
          SizedBox(height: 10.0),
          Text(
            'Login to enter diary',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigo[300],
                fontSize: 25.0),
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
