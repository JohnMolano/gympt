part of 'workouts_bloc.dart';

@immutable
abstract class WorkoutsEvent {
  get workout => null;
}

class CardTappedEvent extends WorkoutsEvent {
  final WorkoutData workout;

  CardTappedEvent({required this.workout});
}
