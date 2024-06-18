import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:gympt/data/exercise_data.dart';

class WorkoutData {
  final String title;
  final String exercices;
  final String minutes;
  final int currentProgress;
  final int progress;
  final String image;
  final List<ExerciseData> exerciseDataList;

  WorkoutData({
    required this.title,
    required this.exercices,
    required this.minutes,
    required this.currentProgress,
    required this.progress,
    required this.image,
    required this.exerciseDataList,
  });

  @override
  String toString() {
    return 'WorkoutData(title: $title, exercices: $exercices, minutes: $minutes, currentProgress: $currentProgress, progress: $progress, image: $image, exerciseDataList: $exerciseDataList)';
  }

  // Método para convertir un documento de Firestore a un objeto WorkoutData
  factory WorkoutData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
   
    // Convertir el array de objetos a una lista de ExerciseData
    List<ExerciseData> exercises = (data['exerciseDataList'] as List<dynamic>?)
      ?.map((exerciseData) => ExerciseData(
            title: exerciseData['title'] ?? '',
            minutes: exerciseData['minutes'] ?? 0,
            progress: exerciseData['progress'] ?? 0.1,
            description: exerciseData['description'] ?? '',
            video: exerciseData['video'] ?? '',
            steps: (exerciseData['steps'] as List<dynamic>?)
                  ?.map((step) => step.toString())
                  .toList() ??
              [],
        ))
      .toList() ?? [];

    return WorkoutData(
      //id: doc.id,
      title: data['title'] ?? '',
      minutes: data['minutes'] ?? 0,
      exercices: data['exercices'] ?? '',
      currentProgress: data['currentProgress'] ?? 0, 
      progress: data['progress'] ?? 0, 
      image: data['image'] ?? '',
      exerciseDataList: exercises,
    );
  }
}
