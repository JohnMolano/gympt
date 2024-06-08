import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gympt/core/service/generate_content_provider.dart';
import 'package:image_picker/image_picker.dart';

// https://www.codewithhussain.com/flutter-image-picker
class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});
  
  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  static const prompt = "Generates a personalized training plan in Spanish to improve the physical appearance of the person in the photo. If there are no people in the photo, it informs that there must be a person for the analysis, taking into account whether it is an older person, an adult, a young person, or a girl. or baby. Steps: Image analysis: Identify the sex, approximate age and body type of the person according to Sheldon's classification. Estimate height and weight, age, BMI, measurements (if possible). Observe the posture, body composition and fat distribution and in the type of person put details of the analysis, be careful with bad comments. You are going to create a routine for Monday, Tuesday, Wednesday, Thursday and Friday of exercises based on their body constitution in Spanish to improve the physical appearance of this person and create a goal for one month that can be increasing glutes, toning, toning arms , tone legs, mark abdomen, increase body mass, lose weight, etc. take into account the type of person who can, for example, be an athlete, normal, sedentary, tell me what type of body they have according to Sheldon's classification, separate the items by list and in the nutritional advice indicate specific foods for a balanced diet and taking into account Consider the type of person and their age to eat for a month and they will help you with the goal. The results that I always want to have are: Goal of the month, Type of person, Age, Height, Weight, BMI, Measurements, Body type, Place of execution, Equipment or elements to use, Warm-up, Exercises, Cool down. , Tips and nutrition.";
  XFile? image;
  Uri? imageFirebase;
  GenerateContentProvider? generateContentProvider;
  @override
  void initState() {
    super.initState();
    generateContentProvider = GenerateContentProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final img =
                      await picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    image = img;
                  });

                  if (image != null) {
                    final imageFirebaseUrl = await uploadFileToFirebaseStorage(image);
                    setState(() {
                      imageFirebase = imageFirebaseUrl;
                    });
                  }
                  
                },
                label: const Text('Choose Image'),
                icon: const Icon(Icons.image),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final ImagePicker picker0 = ImagePicker();
                  final img =
                      await picker0.pickImage(source: ImageSource.camera);
                  setState(() {
                    image = img;
                  });

                  if (image != null) {
                    await uploadFileToFirebaseStorage(image);
                  }
                  
                },
                label: const Text('Take Photo'),
                icon: const Icon(Icons.camera_alt_outlined),
              ),
            ],
          ),
          if (image != null)
            Column(
                children: [
                  if (kIsWeb)
                    Image.network(image!.path, width: 200, height: 200,)
                  else
                    Image.file(File(image!.path), width: 200, height: 200,),
                  
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        image = null;
                      });
                    },
                    label: const Text('Remove Image'),
                    icon: const Icon(Icons.close),
                  )
                ],
            )
          else
            const SizedBox(),
          Text(
            'Respuesta: ',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          if (imageFirebase != null)
            FutureBuilder(
              future:
                  generateContentProvider!.sacarRutinaDeImagen(prompt, image!),
              builder: (context, respuestaAsync) {
                if (respuestaAsync.connectionState ==
                    ConnectionState.done) {
                
                  // Validate the JSON string
                  bool isValid = isValidJson(respuestaAsync.data!);

                  if (!isValid) {
                    return Text(respuestaAsync.data!);
                  } else {
                    // Convert the JSON string to an object
                    Modelo modelo = Modelo.fromJson(respuestaAsync.data!);
                   
                    if (kDebugMode) {
                      print('JSON:');
                      print(modelo);
                    }

                    return Row( 
                      children: [
                          Text(
                            'Objetivo del mes: ${modelo.objetivoMes}',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          Text(
                            'Tipo de persona: ${modelo.tipoPersona}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ]
                    ); 
                  }
                } else {
                  return const CircularProgressIndicator();
                }
            }),
        ],
      );
  }
}


Future<Uri> uploadFileToFirebaseStorage(XFile? image) async {
  // Upload the image to Firebase Storage
  final FirebaseStorage storage = FirebaseStorage.instance;
  final Reference ref = storage.ref().child('images_status_user/user_${image!.name}');
  if (kIsWeb) {
    Uint8List imageData = await XFile(image.path).readAsBytes();
    await ref.putData(imageData);
  } else {
    await ref.putFile(File(image.path));
  }  
  
  // Get the URL of the uploaded image
  final String imageUrl = await ref.getDownloadURL();
  // Store the image URL in a database or use it as needed
  if (kDebugMode) {
    print('Image URL: $imageUrl');
  }

  return Uri.parse(imageUrl);
}

bool isValidJson(String jsonString) {
  try {
    jsonDecode(jsonString);
    return true;
  } catch (e) {
    return false;
  }
}




class Medidas {
  final int pecho;
  final int cintura;
  final int caderas;

  Medidas({required this.pecho, required this.cintura, required this.caderas});

  factory Medidas.fromJson(Map<String, dynamic> json) {
    return Medidas(
      pecho: json['pecho'],
      cintura: json['cintura'],
      caderas: json['caderas'],
    );
  }
}

class Ejercicio {
  final String nombre;
  final int series;
  final int repeticiones;

  Ejercicio({required this.nombre, required this.series, required this.repeticiones});

  factory Ejercicio.fromJson(Map<String, dynamic> json) {
    return Ejercicio(
      nombre: json['nombre'],
      series: json['series'],
      repeticiones: json['repeticiones'],
    );
  }
}

class Nutricion {
  final String desayuno;
  final String comida;
  final String cena;

  Nutricion({required this.desayuno, required this.comida, required this.cena});

  factory Nutricion.fromJson(Map<String, dynamic> json) {
    return Nutricion(
      desayuno: json['desayuno'],
      comida: json['comida'],
      cena: json['cena'],
    );
  }
}

class Modelo {
  final String objetivoMes;
  final String tipoPersona;
  final int edad;
  final int altura;
  final int peso;
  final double imc;
  final Medidas medidas;
  final String tipoCuerpo;
  final String lugarEjecucion;
  final String equipamientoElementosUsar;
  final String calentamiento;
  final List<Ejercicio> ejercicios;
  final String enfriamiento;
  final String consejos;
  final Nutricion nutricion;

  Modelo({
    required this.objetivoMes,
    required this.tipoPersona,
    required this.edad,
    required this.altura,
    required this.peso,
    required this.imc,
    required this.medidas,
    required this.tipoCuerpo,
    required this.lugarEjecucion,
    required this.equipamientoElementosUsar,
    required this.calentamiento,
    required this.ejercicios,
    required this.enfriamiento,
    required this.consejos,
    required this.nutricion,
  });

  factory Modelo.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);

    return Modelo(
      objetivoMes: json['objetivoMes'],
      tipoPersona: json['tipoPersona'],
      edad: json['edad'],
      altura: json['altura'],
      peso: json['peso'],
      imc: json['imc'],
      medidas: Medidas.fromJson(json['medidas']),
      tipoCuerpo: json['tipoCuerpo'],
      lugarEjecucion: json['lugarEjecucion'],
      equipamientoElementosUsar: json['equipamientoElementosUsar'],
      calentamiento: json['calentamiento'],
      ejercicios: (json['ejercicios'] as List)
          .map((item) => Ejercicio.fromJson(item))
          .toList(),
      enfriamiento: json['enfriamiento'],
      consejos: json['consejos'],
      nutricion: Nutricion.fromJson(json['nutricion']),
    );
  }
}