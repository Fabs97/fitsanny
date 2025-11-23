import 'package:fitsanny/l10n/app_localizations.dart';
import 'package:fitsanny/model/goal.dart';
import 'package:fitsanny/model/set.dart';
import 'package:fitsanny/pages/home/charts/chart_data.dart';
import 'package:fitsanny/pages/home/charts/goal_progress_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createWidgetUnderTest(GoalProgressChart chart) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en')],
      home: Scaffold(body: chart),
    );
  }

  testWidgets('GoalProgressChart displays weight progress by default', (
    WidgetTester tester,
  ) async {
    final goal = Goal(
      id: 1,
      exerciseId: 1,
      reps: 10,
      kgs: 100.0,
      type: GoalType.weight,
    );
    final set = Set(id: 1, exerciseId: 1, reps: 8, kgs: 80.0, logId: 1);
    final data = ChartData(
      goal: goal,
      latestSet: set,
      exerciseName: 'Bench Press',
    );

    await tester.pumpWidget(
      createWidgetUnderTest(GoalProgressChart(data: data)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bench Press'), findsOneWidget);
    expect(find.text('Current: 80kg'), findsOneWidget);
    expect(find.text('Goal: 100kg'), findsOneWidget);
  });

  testWidgets('GoalProgressChart displays reps progress when type is reps', (
    WidgetTester tester,
  ) async {
    final goal = Goal(
      id: 1,
      exerciseId: 1,
      reps: 12,
      kgs: 100.0,
      type: GoalType.reps,
    );
    final set = Set(id: 1, exerciseId: 1, reps: 6, kgs: 100.0, logId: 1);
    final data = ChartData(
      goal: goal,
      latestSet: set,
      exerciseName: 'Push Ups',
    );

    await tester.pumpWidget(
      createWidgetUnderTest(GoalProgressChart(data: data)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Push Ups'), findsOneWidget);
    expect(find.text('6 reps / 12 reps'), findsOneWidget);
  });
}
