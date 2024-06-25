import 'package:gympt/core/const/color_constants.dart';
import 'package:gympt/core/const/data_constants.dart';
import 'package:gympt/core/service/workouts_servide.dart';
import 'package:gympt/data/workout_data.dart';
import 'package:gympt/screens/workouts/widget/workout_card.dart';
import 'package:flutter/material.dart';

class WorkoutContent extends StatefulWidget {
  const WorkoutContent({super.key});
  @override
  _WorkoutContentState createState() => _WorkoutContentState();
}

class _WorkoutContentState extends State<WorkoutContent> {
  late Future<List<WorkoutData>> _workoutsFuture;
  
  @override
  void initState() {
    super.initState();
    _workoutsFuture = WorkoutsService.fetchWorkouts();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstants.homeBackgroundColor,
      height: double.infinity,
      width: double.infinity,
      child: _createHomeBody(context),
    );
  }

  Widget _createHomeBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('Workouts',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 5),
          Expanded(
              child: FutureBuilder<List<WorkoutData>>(
                future: _workoutsFuture
        ,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No se encontraron entrenamientos.'));
                  } else {
                    return ListView(
                      children: snapshot.data!
                          .map(
                            (workout) => _createWorkoutCard(workout), // Reemplaza con tu función para crear tarjetas
                          )
                          .toList(),
                    );
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _createWorkoutCard(WorkoutData workoutData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: WorkoutCard(workout: workoutData),
    );
  }
}
