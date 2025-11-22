import 'package:fitsanny/bloc/log/log_cubit.dart';
import 'package:fitsanny/pages/logger/logger_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fitsanny/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class LoggerHome extends StatefulWidget {
  const LoggerHome({super.key});

  @override
  State<LoggerHome> createState() => _LoggerHomeState();
}

class _LoggerHomeState extends State<LoggerHome> {
  @override
  void initState() {
    super.initState();
    // Load logs for the last 30 days by default
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(Duration(days: 30));
    context.read<LogCubit>().loadLogsTimeSpan(thirtyDaysAgo, now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.trainingHistoryTitle),
      ),
      body: BlocBuilder<LogCubit, LogState>(
        builder: (context, state) {
          if (state is LogsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is LogsLoaded) {
            if (state.logs.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)!.noLogsFound),
              );
            }
            return ListView.builder(
              itemCount: state.logs.length,
              itemBuilder: (context, index) {
                final log = state.logs[index];
                return ListTile(
                  title: Text(
                    DateFormat(
                      'yyyy-MM-dd HH:mm',
                    ).format(log.createdAt ?? DateTime.now()),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context)!.setsCount(log.sets.length),
                  ),
                  onTap: () {
                    context.go('/log/edit', extra: log);
                  },
                );
              },
            );
          } else if (state is LogError) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.errorPrefix(state.message),
              ),
            );
          }
          return Container();
        },
      ),
      floatingActionButton: BlocBuilder<LoggerCubit, LoggerState>(
        builder: (context, loggerState) {
          return FloatingActionButton(
            onPressed: () {
              if (loggerState.training == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.pleaseChooseTraining,
                    ),
                  ),
                );
              } else {
                context.go('/log/new');
              }
            },
            child: Icon(Icons.add),
          );
        },
      ),
    );
  }
}
