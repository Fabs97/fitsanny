import 'package:flutter/material.dart';

class LoggerHome extends StatelessWidget {
  const LoggerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Choose a training to create a log',
        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
      ),
    );
  }
}
