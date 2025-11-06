abstract class TrainingHomeStateEvent {}

class TrainingHomeStateOpenedModalEvent extends TrainingHomeStateEvent {
  final bool isNewTrainingModalOpen;

  TrainingHomeStateOpenedModalEvent({required this.isNewTrainingModalOpen});
}
