import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:gympt/core/const/color_constants.dart';
import 'package:gympt/core/const/path_constants.dart';
import 'package:gympt/core/const/text_constants.dart';
import 'package:gympt/core/service/auth_service.dart';
import 'package:gympt/screens/common_widgets/settings_container.dart';
import 'package:gympt/screens/edit_account/edit_account_screen.dart';
import 'package:gympt/screens/reminder/page/reminder_page.dart';
import 'package:gympt/screens/settings/bloc/settings_bloc.dart';
import 'package:gympt/screens/sign_in/page/sign_in_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? photoUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildContext(context));
  }

  BlocProvider<SettingsBloc> _buildContext(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (context) => SettingsBloc(),
      child: BlocConsumer<SettingsBloc, SettingsState>(
        buildWhen: (_, currState) => currState is SettingsInitial,
        builder: (context, state) {
          return _settingsContent(context);
        },
        listenWhen: (_, currState) => true,
        listener: (context, state) {},
      ),
    );
  }

  Widget _settingsContent(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? "No Username";
    photoUrl = user?.photoURL;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: Column(children: [
            Stack(alignment: Alignment.topRight, children: [
              Center(
                child: photoUrl == null
                    ? const CircleAvatar(
                        backgroundImage: AssetImage(PathConstants.profile),
                        radius: 60)
                    : CircleAvatar(
                        radius: 60,
                        child: ClipOval(
                            child: FadeInImage.assetNetwork(
                          placeholder: PathConstants.profile,
                          image: photoUrl!,
                          fit: BoxFit.cover,
                          width: 200,
                          height: 120,
                        )),
                      ),
              ),
              TextButton(
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditAccountScreen()));
                    setState(() {
                      photoUrl = user?.photoURL;
                    });
                  },
                  style: TextButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor:
                          ColorConstants.primaryColor.withOpacity(0.16)),
                  child: const Icon(Icons.edit,
                      color: ColorConstants.primaryColor)),
            ]),
            const SizedBox(height: 15),
            Text(displayName,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            SettingsContainer(
              withArrow: true,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ReminderPage()));
              },
              child: const Text(TextConstants.reminder,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
            ),
            if (!kIsWeb)
              SettingsContainer(
                child: Text(
                    '${TextConstants.rateUsOn}${Platform.isIOS ? 'App store' : 'Play market'}',
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w500)),
                onTap: () {
                  return launchUrl((Platform.isIOS
                      ? Uri.parse('https://www.apple.com/app-store/')
                      : Uri.parse('https://play.google.com/store')));
                },
              ),
            SettingsContainer(
                onTap: () => launchUrl(Uri.parse(
                    'https://techcraftjm.com/doc/PoliticaTratamientDatosTECHCRAFTJMS.A.S..pdf')),
                child: const Text(TextConstants.terms,
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w500))),
            SettingsContainer(
                child: const Text(TextConstants.signOut,
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                onTap: () {
                  AuthService.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SignInPage()),
                  );
                }),
            const SizedBox(height: 15),
            const Text(TextConstants.joinUs,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () => launchUrl(Uri.parse(
                        'https://www.facebook.com/profile.php?id=61557095804330')),
                    style: TextButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.white,
                        elevation: 1),
                    child: Image.asset(PathConstants.facebook)),
                TextButton(
                    onPressed: () => launchUrl(Uri.parse(
                        'https://www.linkedin.com/company/102855726/admin/dashboard/')),
                    style: TextButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.white,
                        elevation: 1),
                    child: Image.asset(PathConstants.instagram)),
                TextButton(
                    onPressed: () => launchUrl(
                        Uri.parse('https://www.youtube.com/@techcraftjm')),
                    style: TextButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.white,
                        elevation: 1),
                    child: Image.asset(PathConstants.twitter)),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
