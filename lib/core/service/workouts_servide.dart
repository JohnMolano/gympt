

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gympt/data/workout_data.dart';

class WorkoutsService {
  static final FirebaseAuth firebase = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<List<WorkoutData>> fetchWorkouts() async {
  final workoutsCollection = FirebaseFirestore.instance.collection('workouts');
  final querySnapshot = await workoutsCollection.get();
  List<WorkoutData> workouts = [];
  for (var doc in querySnapshot.docs) {
    workouts.add(WorkoutData.fromFirestore(doc));
  }
  return workouts;
}
}