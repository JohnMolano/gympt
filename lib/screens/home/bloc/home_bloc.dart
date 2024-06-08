import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()){
    on<ReloadImageEvent>((event, emit) {
      emit(ReloadImageState());
    });
  }
}
