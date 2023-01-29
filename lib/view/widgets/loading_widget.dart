import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/weather.png',
              width: 50,
              height: 50,
            ),
            const SizedBox(
              height: 20,
            ),
            LinearProgressIndicator(
              backgroundColor: Colors.blue.shade100,
              minHeight: 5,
              color: Colors.blue.shade600,
            ),
          ],
        ),
      ),
    );
  }
}
