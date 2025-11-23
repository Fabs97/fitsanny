import 'package:fitsanny/l10n/app_localizations.dart';
import 'package:fitsanny/pages/home/charts/chart_cubit.dart';
import 'package:fitsanny/pages/home/charts/chart_provider.dart';
import 'package:fitsanny/pages/home/charts/chart_state.dart';
import 'package:fitsanny/pages/home/charts/goal_progress_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [ChartProvider.provider],
      child: Builder(
        builder: (context) {
          // Trigger load
          context.read<ChartCubit>().loadCharts();
          return Column(
            spacing: 8.0,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(
                  context,
                )!.homeGreeting(_getGreetingForTimeOfDay(context)),
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
              ),
              Text(
                AppLocalizations.of(context)!.homeSubtitle,
                style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
              ),
              Expanded(
                child: BlocBuilder<ChartCubit, ChartState>(
                  builder: (context, state) {
                    if (state is ChartsLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is ChartsLoaded) {
                      if (state.charts.isEmpty) {
                        return Center(
                          child: Text(AppLocalizations.of(context)!.noGoalsSet),
                        );
                      }
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 10.0,
                          children: state.charts
                              .map((data) => GoalProgressChart(data: data))
                              .toList(),
                        ),
                      );
                    } else if (state is ChartError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    return Container();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getGreetingForTimeOfDay(BuildContext context) {
    final now = DateTime.now().hour;
    if (now >= 6 && now < 12) {
      return AppLocalizations.of(context)!.homeTimeOfDayMorning;
    } else if (now >= 12 && now < 18) {
      return AppLocalizations.of(context)!.homeTimeOfDayAfternoon;
    } else if (now >= 18 || now < 6) {
      return AppLocalizations.of(context)!.homeTimeOfDayEvening;
    }
    return 'tag';
  }
}
