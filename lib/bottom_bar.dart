import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitsanny/l10n/app_localizations.dart';

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        border: Border(top: BorderSide(color: Colors.grey, width: 1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        child: BottomAppBar(
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.home),
                    tooltip: AppLocalizations.of(context)!.homeTooltip,
                    onPressed: () => context.go('/home'),
                  ),
                  IconButton(
                    icon: Icon(Icons.fitness_center),
                    tooltip: AppLocalizations.of(context)!.trainingTooltip,
                    onPressed: () => context.go('/training'),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit_note),
                    tooltip: AppLocalizations.of(context)!.logTooltip,
                    onPressed: () => context.go('/log'),
                  ),
                  IconButton(
                    icon: Icon(Icons.workspace_premium),
                    tooltip: AppLocalizations.of(context)!.goalsTooltip,
                    onPressed: () => context.go('/goals'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
