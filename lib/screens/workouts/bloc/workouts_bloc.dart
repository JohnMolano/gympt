import 'package:bloc/bloc.dart';
import 'package:gympt/data/workout_data.dart';
import 'package:flutter/material.dart';

part 'workouts_event.dart';
part 'workouts_state.dart';

class WorkoutsBloc extends Bloc<WorkoutsEvent, WorkoutsState> {
  WorkoutsBloc() : super(WorkoutsInitial()){
    on<WorkoutsEvent>((event, emit) {
      emit(CardTappedState(workout: event.workout));
    });
  }
}
