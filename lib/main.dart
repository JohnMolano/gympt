import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:gympt/core/const/color_constants.dart';
import 'package:gympt/core/service/notification_service.dart';
import 'package:gympt/screens/onboarding/page/onboarding_page.dart';
import 'package:gympt/screens/tab_bar/page/tab_bar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await initializeFirebase();


  runApp(const Gympt());
}

class Gympt extends StatefulWidget {
  const Gympt({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GymptState createState() => _GymptState();
}

class _GymptState extends State<Gympt> {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = NotificationService.flutterLocalNotificationsPlugin;

  @override
  initState() {
    super.initState();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    //final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();
    //final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    tz.initializeTimeZones();

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    if (kDebugMode) {
      print('isLoggedIn: $FirebaseAuth.instance.currentUser');
    }
    // ignore: prefer_const_constructors
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gympt',
      theme: ThemeData(
        textTheme: const TextTheme(bodyLarge: TextStyle(color: ColorConstants.textColor)),
        fontFamily: 'NotoSansKR',
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isLoggedIn ? const TabBarPage() : const OnboardingPage(),
    );
  }

  Future selectNotification(String? payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }
}
