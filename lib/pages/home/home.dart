import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String title = 'Fit Sanny';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [Center(child: Text(title))]);
  }
}
