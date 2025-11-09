import 'package:equatable/equatable.dart';
import 'package:fitsanny/model/training.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Note: navigation should be done in the UI using a BuildContext that has
// GoRouter available. The bloc only holds state.

part 'logger_event.dart';
part 'logger_state.dart';

class LoggerBloc extends Bloc<LoggerEvent, LoggerState> {
  LoggerBloc() : super(UnchosenTraining()) {
    on<ChooseTraining>((event, emit) async {
      // Do not perform navigation from the bloc. Navigation requires a
      // BuildContext that has GoRouter in its widget tree. The UI that
      // dispatches ChooseTraining should also trigger loading logs and
      // perform navigation using its own context.
      emit(ChosenTraining(training: event.training));
    });
  }
}

extension LoggerProvider on LoggerBloc {
  static BlocProvider<LoggerBloc> get provider =>
      BlocProvider<LoggerBloc>(create: (context) => LoggerBloc());
}
