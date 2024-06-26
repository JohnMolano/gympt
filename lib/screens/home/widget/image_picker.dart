import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gympt/core/const/color_constants.dart';
import 'package:gympt/core/service/generate_content_provider.dart';
import 'package:gympt/core/service/user_service.dart';
import 'package:image_picker/image_picker.dart';

// https://www.codewithhussain.com/flutter-image-picker
class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});
  
  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  static const prompt = "Generate a personalized training plan in Spanish to improve the physical appearance of the person in the photo. If there are no people in the photo, it informs that there must be a person for the analysis, taking into account whether it is an older person, an adult, a young man or a girl. or baby. Steps: Image analysis: Identify the sex, approximate metabolic age and body type of the person according to Sheldon's classification. Estimate height and weight, age, BMI, measurements (if possible). Observe the posture, body composition and fat distribution and in the type of person put details of the analysis, be careful with bad comments. You are going to create a routine for Monday, Tuesday, Wednesday, Thursday and Friday of exercises based on their body constitution in Spanish to improve the physical appearance of this person and create a goal for a month that can be to increase glutes, tone, tone . arms, tone legs, mark abdomen, increase body mass, lose weight, etc. take into account the type of person who can, for example, be athletic, normal, sedentary, tell me what body type they have according to Sheldon's classification. , separates the elements by list and in the nutritional advice indicates specific foods for a balanced diet and taking into account the type of person and their age to eat for a month and they will help you with the objective. The results that I always want to have are: Goal of the month, Type of person, Age, Height, Weight, BMI, Measurements, Body type, Place of execution, Equipment or elements to use, Warm-up, Exercises, Cool down. , Tips and nutrition.";
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.primaryColor,
                  foregroundColor: ColorConstants.white,
                ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.primaryColor,
                  foregroundColor: ColorConstants.white,
                ),
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
          const SizedBox(height: 25),
          if (image != null)
            Column(
                children: [
                  if (kIsWeb)
                    Image.network(image!.path, width: 200, height: 200,)
                  else
                    Image.file(File(image!.path), width: 200, height: 200,),
                  
                  const SizedBox(height: 25),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        image = null;
                        imageFirebase = null;
                      });
                    },
                    label: const Text('Remove Image'),
                    icon: const Icon(Icons.close),
                  ),
                  const SizedBox(height: 25),
                ],
            )
          else
          const SizedBox(height: 25),
          if (imageFirebase != null && image != null)
            FutureBuilder(
              future:
                  generateContentProvider!.sacarRutinaDeImagen(prompt, image!),
              builder: (context, respuestaAsync) {
                final screenWidth = MediaQuery.of(context).size.width;
                if (respuestaAsync.connectionState ==
                    ConnectionState.done) {
                  
           
                  //guardar en firebase
                  if(respuestaAsync.data != null ) {
                    UserService.changeUserDataRoutine(imageUrl: imageFirebase.toString(),visionResult: respuestaAsync.data.toString());
                  }

                  // Validate the JSON string
                  bool isValid = isValidJson(respuestaAsync.data!);

                  if (!isValid) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      width: screenWidth * 0.9,
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
                      child: Column(  
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center, // Alinea los elementos a la izquierda
                        children: [
                          Text(respuestaAsync.data!)
                        ],
                      ),
                    );
                  } else {
                    // Convert the JSON string to an object 
                    // Use the object as needed
                    Modelo modelo = Modelo.fromJson(respuestaAsync.data!);
                    if (kDebugMode) {
                      print('JSON:');
                      print(modelo);
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      width: screenWidth * 0.9,
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
                      child: Column(  
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center, // Alinea los elementos a la izquierda
                        children: [
                          ListTile( 
                            title: const Text(
                                    'Objetivo del mes:', style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstants.textBlack,
                                    ),),
                            subtitle: Text(modelo.objetivoMes, 
                                        style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.textGrey,
                                      ),),
                          ),
                          ListTile(
                            title: const Text('Tipo de persona:'),
                            subtitle: Text(modelo.tipoPersona, 
                                        style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.textGrey,
                                      ),),
                          ),
                          ListTile(
                            title: const Text('Tipo de cuerpo:'),
                            subtitle: Text(modelo.tipoCuerpo, 
                                        style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.textGrey,
                                      ),),
                          ),
                          ListTile(
                            title: const Text('Promedio de edad metabólica:'),
                            subtitle: Text(modelo.edadMetablicaAproximada, 
                                        style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.textGrey,
                                      ),),
                          ),
                          ListTile(
                            title: const Text('Promedio de altura:'),
                            subtitle: Text(modelo.altura.toString(), 
                                        style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.textGrey,
                                      ),),
                          ),
                          ListTile(
                            title: const Text('Promedio de peso:'),
                            subtitle: Text(modelo.peso.toString(), 
                                        style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.textGrey,
                                      ),),
                          ),
                          ListTile(
                            title: const Text('Indice de masa corporal:'),
                            subtitle: Text(modelo.imc.toString(), 
                                        style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.textGrey,
                                      ),),
                          ),
                          const Divider(height: 0),
                          const ListTile(
                            title: Text(
                                    'Medidas:', style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstants.textBlack,
                                    ),),
                          ),
                          ListTile(
                            title: const Text('Pecho:'),
                            subtitle: Text(modelo.medidas.pecho.toString(), 
                                        style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.textGrey,
                                      ),),
                          ),
                          ListTile(
                            title: const Text('Cintura:'),
                            subtitle: Text(modelo.medidas.cintura.toString(), 
                                        style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.textGrey,
                                      ),),
                          ),
                          ListTile(
                            title: const Text('Caderas:'),
                            subtitle: Text(modelo.medidas.caderas.toString(), 
                                        style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.textGrey,
                                      ),),
                          ),
                          const Divider(height: 0),
                          const ListTile(
                            title: Text(
                                    'Rutina:', style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstants.textBlack,
                                    ),),
                          ),
                          ListTile(
                            title: const Text('Lugar de ejecución:'),
                            subtitle: Text(modelo.lugarEjecucion, 
                                        style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.textGrey,
                                      ),),
                          ),
                          ListTile(
                            title: const Text('Equipos a usar:'),
                            subtitle: Text(modelo.equipamientoElementosUsar, 
                                        style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.textGrey,
                                      ),),
                          ),
                          ListTile(
                            title: const Text('Calentamiento:'),
                            subtitle: Text(modelo.calentamiento, 
                                        style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.textGrey,
                                      ),),
                          ),
                          const ListTile(
                            title: Text(
                                    'Ejercicios:', style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstants.textBlack,
                                    ),),
                          ),
                          ListTile(
                            title: Text(modelo.ejercicios[0].nombre),
                            subtitle: Text('Series: ${modelo.ejercicios[0].series}, Repeticiones: ${modelo.ejercicios[0].repeticiones}', 
                                        style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.textGrey,
                                      ),),
                          ),
                          ListTile(
                            title: Text(modelo.ejercicios[1].nombre),
                            subtitle: Text('Series: ${modelo.ejercicios[1].series}, Repeticiones: ${modelo.ejercicios[1].repeticiones}', 
                                        style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.textGrey,
                                      ),),
                          ),
                          ListTile(
                            title: Text(modelo.ejercicios[2].nombre),
                            subtitle: Text('Series: ${modelo.ejercicios[2].series}, Repeticiones: ${modelo.ejercicios[2].repeticiones}', 
                                        style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.textGrey,
                                      ),),
                          ),
                          ListTile(
                            title: Text(modelo.ejercicios[3].nombre),
                            subtitle: Text('Series: ${modelo.ejercicios[3].series}, Repeticiones: ${modelo.ejercicios[3].repeticiones}', 
                                        style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.textGrey,
                                      ),),
                          ),
                          ListTile(
                            title: const Text('Enfriamiento:'),
                            subtitle: Text(modelo.enfriamiento, 
                                        style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.textGrey,
                                      ),),
                          ),
                          const Divider(height: 0),
                          const ListTile(
                            title: Text(
                                    'Nutrición:', style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstants.textBlack,
                                    ),),
                          ),
                          ListTile(
                            title: const Text('Desayuno:'),
                            subtitle: Text(modelo.nutricion.desayuno, 
                                        style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.textGrey,
                                      ),),
                          ),
                          ListTile(
                            title: const Text('Almuerzo:'),
                            subtitle: Text(modelo.nutricion.comida, 
                                        style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.textGrey,
                                      ),),
                          ),
                          ListTile(
                            title: const Text('Cena:'),
                            subtitle: Text(modelo.nutricion.cena, 
                                        style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.textGrey,
                                      ),),
                          ),
                          const Divider(height: 0),
                          ListTile(
                            title: const Text(
                                    'Consejos:', style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstants.textBlack,
                                    ),),
                            subtitle: Text(modelo.consejos, 
                                        style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.textGrey,
                                      ),),
                          )
                          // Agrega los otros elementos aquí de la misma manera
                        ],
                      ),
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