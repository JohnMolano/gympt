import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:gympt/core/service/generate_content_provider.dart';
import 'package:gympt/screens/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gympt/screens/home/widget/home_ia_foto_content.dart';

class HomeIAFotoPage extends StatelessWidget {
  const HomeIAFotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContext(context),
    );
  }

  GenerateContentProvider _buildContext(BuildContext context) {
    return GenerateContentProvider(
      model: configurarModelo(),
      modelProvision: configurarModeloVision(),
      child: BlocProvider<HomeBloc>(
        create: (BuildContext context) => HomeBloc(),
        child: BlocConsumer<HomeBloc, HomeState>(
          buildWhen: (_, currState) => currState is HomeInitial,
          builder: (context, state) {
            return const HomeIAFotoContent();
          },
          listenWhen: (_, currState) => true,
          listener: (context, state) {},
        ),
      )
    );
  }
}


GenerativeModel configurarModelo() {
  const apiKey = 'AIzaSyDnyhtzfsWCbaL8J_ubDv7l5W8NuDUq9z0';
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  return model;
}
GenerativeModel configurarModeloVision() {
  const apiKey = 'AIzaSyDnyhtzfsWCbaL8J_ubDv7l5W8NuDUq9z0';
  final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);
  return model;
}