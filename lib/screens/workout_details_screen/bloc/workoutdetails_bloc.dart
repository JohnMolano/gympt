import 'package:bloc/bloc.dart';
import 'package:gympt/data/exercise_data.dart';
import 'package:gympt/data/workout_data.dart';
import 'package:flutter/material.dart';

part 'workoutdetails_event.dart';
part 'workoutdetails_state.dart';

class WorkoutDetailsBloc extends Bloc<WorkoutDetailsEvent, WorkoutDetailsState> {
  final WorkoutData workout;
  WorkoutDetailsBloc({required this.workout}) : super(WorkoutDetailsInitial()){
    on<BackTappedEvent>((event, emit) {
      emit(BackTappedState());
    });
    on<WorkoutExerciseCellTappedEvent>((event, emit) {
      emit(WorkoutExerciseCellTappedState(
        currentExercise: event.currentExercise,
        nextExercise: event.nextExercise,
      ));
    });
  }
}
