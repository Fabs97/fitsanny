import 'package:collection/collection.dart';
import 'package:fitsanny/model/log.dart';
import 'package:fitsanny/pages/home/charts/pull_ups_chart/pull_up_chart_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PullUpsChart extends StatefulWidget {
  const PullUpsChart({super.key});

  @override
  State<PullUpsChart> createState() => _PullUpsChartState();
}

class _PullUpsChartState extends State<PullUpsChart> {
  @override
  void initState() {
    super.initState();
    context.read<PullUpChartBloc>().add(LoadLogsForPullUpChart());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PullUpChartBloc, PullUpChartState>(
      builder: (context, state) {
        if (state is LogsLoaded) {
          // prepare data (groups by date) - keep referenced to avoid unused declaration warning
          final logs = _prepareData(state.logs);
          return LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  color: Colors.purple,
                  barWidth: 8.0,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                  spots: logs.entries.map((entry) {
                    final double date = DateTime.parse(
                      entry.key,
                    ).millisecondsSinceEpoch.toDouble();
                    final sets = entry.value.map((l) => l.sets).flattenedToList;
                    final totalReps = sets.fold<int>(
                      0,
                      (sum, s) => sum + s.reps,
                    );
                    // return FlSpot(x, totalReps.toDouble());
                    return FlSpot(date, totalReps.toDouble());
                  }).toList(),
                ),
              ],
              gridData: FlGridData(
                verticalInterval: 1,
                horizontalInterval: 86400,
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) =>
                        Text(value.toInt().toString()),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => Text(
                      DateFormat('dd MMM').format(
                        DateTime.fromMillisecondsSinceEpoch(value.toInt()),
                      ),
                    ),
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
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
          return Column(
            children: [
              Expanded(child: Center(child: CircularProgressIndicator())),
            ],
          );
        }
      },
    );
  }

  /// Groups logs by a localized short date string (e.g. `8/12/2025`).
  /// Returns a map keyed by the formatted date.
  Map<String, List<Log>> _prepareData(List<Log> logs) {
    final groupedByDate = groupBy<Log, String>(
      logs,
      (l) => DateFormat(
        "y-M-d",
      ).format(l.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)),
    );

    return groupedByDate;
  }
}
