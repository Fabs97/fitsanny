import 'package:fitsanny/pages/home/charts/pull_ups_chart/pull_up_chart_bloc.dart';
import 'package:fitsanny/pages/home/charts/pull_ups_chart/pull_ups_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [PullUpChartBlocProvider.provider],
      child: Column(
        spacing: 32.0,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              'Guten ${_getGreetingForTimeOfDay()}, Sanny',
              style: TextStyle(),
            ),
          ),
          ...[
            PullUpsChart(),
            PullUpsChart(),
          ].map((chart) => Expanded(child: chart)).toList(),
        ],
      ),
    );
  }

  String _getGreetingForTimeOfDay() {
    final now = DateTime.now().hour;
    if (now >= 6 && now < 12) {
      return 'morgen';
    } else if (now >= 12 && now < 18) {
      return 'tag';
    } else if (now >= 18 || now < 6) {
      return 'abend';
    }
    return 'tag';
  }
}
