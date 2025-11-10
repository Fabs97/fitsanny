import 'package:flutter/material.dart';

class LoggerHome extends StatelessWidget {
  const LoggerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Have we hit the gym today already?',
        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
      ),
    );
  }
}
