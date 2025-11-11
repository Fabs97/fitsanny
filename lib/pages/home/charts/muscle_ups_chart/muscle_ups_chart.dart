import 'package:fitsanny/model/log.dart';
import 'package:fitsanny/pages/home/charts/muscle_ups_chart/muscle_up_chart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MuscleUpsChart extends StatefulWidget {
  const MuscleUpsChart({super.key});

  @override
  State<MuscleUpsChart> createState() => _MuscleUpsChartState();
}

class _MuscleUpsChartState extends State<MuscleUpsChart> {
  final int goal = 1;
  Map<String, int> dataPoints = {};

  @override
  void initState() {
    super.initState();
    context.read<MuscleUpChartBloc>().add(
      LoadLogsForMuscleUpChart(onComplete: _onDataCollectionComplete),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MuscleUpChartBloc, MuscleUpChartState>(
      builder: (context, state) {
        if (state is LogsLoaded) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  Text(
                    'Your set goal for muscle ups: $goal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  ...(dataPoints.isNotEmpty
                      ? dataPoints.entries
                            .map(
                              (dataPoint) => RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(text: 'Muscle ups done on '),
                                    TextSpan(
                                      text: dataPoint.key.toString(),
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    TextSpan(text: ': '),
                                    TextSpan(
                                      text: dataPoint.value.toString(),
                                      style: TextStyle(
                                        color: dataPoint.value < goal
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList()
                      : [
                          Text(
                            'No data points, start logging to get some insights!',
                          ),
                        ]),
                ],
              ),
            ),
          );
        } else if (state is LogError) {
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'Home::build - Wrong LogState ${state.runtimeType}',
                  ),
                ),
              ),
            ],
          );
        } else {
          return Expanded(child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  void _onDataCollectionComplete(success, {Object? data}) {
    if (success) {
      setState(() {
        try {
          dataPoints = ((data ?? <Log>[]) as List<Log>).fold({}, (
            previousElement,
            log,
          ) {
            previousElement[DateFormat('d/M/y').format(log.createdAt!)] = log
                .sets
                .fold(0, (previousElement, s) => previousElement += s.reps);

            return previousElement;
          });
        } catch (e, stackTrace) {
          print(e);
          print(stackTrace);
        }
      });
    }
  }
}
