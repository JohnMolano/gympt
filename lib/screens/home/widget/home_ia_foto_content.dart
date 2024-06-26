import 'package:flutter/foundation.dart';
import 'package:gympt/core/const/color_constants.dart';
import 'package:gympt/core/const/data_constants.dart';
import 'package:gympt/core/const/text_constants.dart';
import 'package:gympt/core/service/user_service.dart';
import 'package:gympt/core/service/workouts_servide.dart';
import 'package:gympt/data/workout_data.dart';
import 'package:gympt/screens/home/widget/home_statistics.dart';
import 'package:gympt/screens/home/widget/home_user_info_card.dart';
import 'package:gympt/screens/home/widget/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:gympt/screens/workout_details_screen/page/workout_details_page.dart';
import 'home_exercises_card.dart';

class HomeIAFotoContent extends StatefulWidget {
  const HomeIAFotoContent({super.key});
  @override
  State<HomeIAFotoContent> createState() => _HomeIAFotoContentState();
}

class _HomeIAFotoContentState extends State<HomeIAFotoContent> {
  late Future<UserData> _userDataFuture;
  bool createdRoutine = false;
  Map? userData;
  @override
  void initState() {
    super.initState();
    _userDataFuture = UserService.getDataUser();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final userSnapshot = await UserService.getUserByUid();
    if (userSnapshot != null && userSnapshot.exists) {
      setState(() {
        userData = userSnapshot.data();
        createdRoutine = true;
      });
    }
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
    if(createdRoutine) {
      return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          const HomeStatistics(), 
          const SizedBox(height: 30), 
          _createExercisesList(context),
          Expanded(
              child: FutureBuilder<UserData>(
                future: _userDataFuture
        ,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No se encontraron datos de usuario.'));
                  } else {
                    return _createUserInfo(context, snapshot.data!);
                  }
                },
              ),
            ),
          //const VideoYoutubeScreen(),
          //const YoutubeVideoIframe(),
          
        ],
      ),
    );
    } else {
      return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          _createProgress(), 
          const SizedBox(height: 25), 
          const ImagePickerScreen(),
        ],
      ),
    );
    }
    
  }


  Widget _createExercisesList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            TextConstants.discoverWorkouts,
            style: TextStyle(
              color: ColorConstants.textBlack,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 20),
              WorkoutCard(
                color: ColorConstants.cardioColor,
                workout: DataConstants.homeWorkouts[0],
                onTap: () async {
                  // 1. Obteener los datos de Firebase
                  List<WorkoutData> workouts = await WorkoutsService.fetchWorkoutsWhereTitle("Cardio"); 
                  // 2. Verificar si hay datos
                if (mounted && workouts.isNotEmpty) { 
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => WorkoutDetailsPage(
                        workout: workouts[0], // Acceder al primer elemento
                      ),
                    ));
                  } else {
                    // Manejar el caso donde no hay datos (mostrar un mensaje, etc.)
                    if (kDebugMode) {
                      print('No hay entrenamientos disponibles');
                    } 
                  }
                },
              ),
              const SizedBox(width: 15),
              WorkoutCard(
                  color: ColorConstants.armsColor,
                  workout: DataConstants.homeWorkouts[1],
                  onTap: () async {
                    // 1. Obteener los datos de Firebase
                    List<WorkoutData> workouts2 = await WorkoutsService.fetchWorkoutsWhereTitle("Arms"); 
                    // 2. Verificar si hay datos
                  if (mounted && workouts2.isNotEmpty) { 
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => WorkoutDetailsPage(
                          workout: workouts2[0], // Acceder al primer elemento
                        ),
                      ));
                    } else {
                      // Manejar el caso donde no hay datos (mostrar un mensaje, etc.)
                      if (kDebugMode) {
                        print('No hay entrenamientos disponibles');
                      } 
                    }
                  },
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ],
    );
  }


  Widget _createProgress() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorConstants.white,
        boxShadow: [
          BoxShadow(
            color: ColorConstants.textBlack.withOpacity(0.12),
            blurRadius: 5.0,
            spreadRadius: 1.1,
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(
            Icons.camera_alt,
            color: ColorConstants.primaryColor,
            size: 30.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
          SizedBox(width: 20),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TextConstants.iaImgProgress,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  TextConstants.iaImgSuccessful,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createUserInfo(BuildContext context, UserData userData) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        SizedBox(
          height: screenHeight * 3.4,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              WorkoutUserInfoCard(
                color: ColorConstants.cardioColor,
                userInfo: userData,
                onTap: () async {
                 if (kDebugMode) {
                      print('dataUser ++++++++++++++++++++++++2');
                      print(userData.modelo.objetivoMes);
                    } 
                },
              ),
              const SizedBox(width: 15),
            ],
          ),
        ),
      ],
    );
  }
}
