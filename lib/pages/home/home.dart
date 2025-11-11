import 'package:fitsanny/pages/home/charts/muscle_ups_chart/muscle_up_chart_bloc.dart';
import 'package:fitsanny/pages/home/charts/muscle_ups_chart/muscle_ups_chart.dart';
import 'package:fitsanny/pages/home/charts/pull_ups_chart/pull_up_chart_bloc.dart';
import 'package:fitsanny/pages/home/charts/pull_ups_chart/pull_ups_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        PullUpChartBlocProvider.provider,
        MuscleUpChartBlocProvider.provider,
      ],
      child: Column(
        spacing: 8.0,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Guten ${_getGreetingForTimeOfDay()}, Sanny 🧚🏼‍♀️',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
          ),
          Text(
            '☀️ Looks like a great moment for a training ☀️',
            style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 10.0,
                children: [PullUpsChart(), MuscleUpsChart()],
              ),
            ),
          ),
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
