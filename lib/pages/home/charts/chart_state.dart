import 'package:equatable/equatable.dart';
import 'package:fitsanny/pages/home/charts/chart_data.dart';

abstract class ChartState extends Equatable {
  const ChartState();

  @override
  List<Object?> get props => [];
}

class ChartsLoading extends ChartState {}

class ChartsLoaded extends ChartState {
  final List<ChartData> charts;

  const ChartsLoaded(this.charts);

  @override
  List<Object?> get props => [charts];
}

class ChartError extends ChartState {
  final String message;

  const ChartError(this.message);

  @override
  List<Object?> get props => [message];
}
