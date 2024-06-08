import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/services.dart';
import 'package:gympt/core/const/path_constants.dart';
import 'package:image_picker/image_picker.dart';

class GenerateContentProvider extends InheritedWidget {
  final GenerativeModel model;
  final GenerativeModel modelProvision;
  const GenerateContentProvider(
      {super.key,
      required super.child,
      required this.model,
      required this.modelProvision});

  static GenerateContentProvider of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<GenerateContentProvider>()!;

  Future<String?> obtenerRespuestaGemini(String entradaDeTexto) async {
    final content = [Content.text(entradaDeTexto)];
    final response = await model.generateContent(content);
    return response.text;
  }

  Future<String?> comparadorDeImagenes(String entradaDeTexto, String pathImg1, String pathImg2) async {
      final img1Bytes = await rootBundle.load(pathImg1);
      final img2Bytes = await rootBundle.load(pathImg2);

      final img1Buffer = img1Bytes.buffer.asUint8List();
      final img2Buffer = img2Bytes.buffer.asUint8List();

      final imageParts = [
        DataPart('image/jpeg', img1Buffer),
        DataPart('image/jpeg', img2Buffer),
      ];

      final prompt = TextPart(
          entradaDeTexto);
      final response = await modelProvision.generateContent([
        Content.multi([prompt, ...imageParts])
      ]);
      if (kDebugMode) {
        print(response.text);
      }
      return Future.value(response.text);
  }
  Future<String?> describirImagen(String entradaDeTexto, String pathImg) async {

      final imgBytes = await rootBundle.load(pathImg);

      final imgBuffer = imgBytes.buffer.asUint8List();

      final imageParts = [
        DataPart('image/jpeg', imgBuffer),
      ];

      final prompt = TextPart(
          entradaDeTexto);
      final response = await modelProvision.generateContent([
        Content.multi([prompt, ...imageParts])
      ]);
      if (kDebugMode) {
        print(response.text);
      }
      return Future.value(response.text);
  }

  Future<String?> sacarRutinaDeImagen(String entradaDeTexto, XFile image) async {
      final imgBufferExample = await rootBundle.load(PathConstants.IaExample1);
      final imgBufferExample2 = imgBufferExample.buffer.asUint8List();
      final imagePartsExample = [
        DataPart('image/jpeg', imgBufferExample2),
      ];
      
      Uint8List imgBuffer = await XFile(image.path).readAsBytes();
      final imageParts = [
        DataPart('image/jpeg', imgBuffer),
      ];
      final prompt = TextPart(entradaDeTexto);
      final textImg = TextPart("Image: ");
      final resultExample = TextPart('{"objetivoMes": "perder peso","tipoPersona": "hombre","edad": 35,"altura": 175,"peso": 100,"imc": 32.5,"medidas": {"pecho": 100,"cintura": 120,"caderas": 110},"tipoCuerpo": "endomorfo","lugarEjecucion": "gimnasio","equipamientoElementosUsar": "mancuernas, barra, disco","calentamiento": "10 minutos de cardio ligero (caminar, trotar, bicicleta)","ejercicios": [{"nombre": "press de banca","series": 3,"repeticiones": 10},{"nombre": "remo horizontal","series": 3,"repeticiones": 10},{"nombre": "sentadillas","series": 3,"repeticiones": 10},{"nombre": "peso muerto","series": 1,"repeticiones": 10},{"nombre": "abdominales","series": 3,"repeticiones": 15}],"enfriamiento": "10 minutos de cardio ligero (caminar, trotar, bicicleta)","consejos": "beber mucha agua, dormir lo suficiente, comer una dieta saludable","nutricion": {"desayuno": "huevos, avena, fruta","comida": "pechuga de pollo, arroz integral, verduras","cena": "pescado, quinoa, verduras"}}');

      final response = await modelProvision.generateContent([
        Content.multi([prompt, textImg, ...imagePartsExample, resultExample, textImg, ...imageParts])
      ]);
      if (kDebugMode) {
        print(response.text);
      }
      return Future.value(response.text);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
  
  String? lookupMimeType(String path, {List<int>? headerBytes}) =>
    _globalResolver.lookup(path, headerBytes: headerBytes);
}

// ignore: camel_case_types
class _globalResolver {
  static lookup(String path, {List<int>? headerBytes}) {}
}