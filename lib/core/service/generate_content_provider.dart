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
      final imgBufferExampleEctomorfa = await rootBundle.load(PathConstants.iaExampleEctomorfa);
      final imgBufferExampleEctomorfa2 = imgBufferExampleEctomorfa.buffer.asUint8List();
      final imagePartsExampleEctomorfa = [
        DataPart('image/jpeg', imgBufferExampleEctomorfa2),
      ];

      final imgBufferExampleMesomorfica = await rootBundle.load(PathConstants.iaExampleMesomorfica);
      final imgBufferExampleMesomorfica2 = imgBufferExampleMesomorfica.buffer.asUint8List();
      final imagePartsExampleMesomorfica = [
        DataPart('image/jpeg', imgBufferExampleMesomorfica2),
      ];

      final imgBufferExampleEndomorfo = await rootBundle.load(PathConstants.iaExampleEndomorfo);
      final imgBufferExampleEndomorfo2 = imgBufferExampleEndomorfo.buffer.asUint8List();
      final imagePartsExampleEndomorfo = [
        DataPart('image/jpeg', imgBufferExampleEndomorfo2),
      ];
      
      Uint8List imgBuffer = await XFile(image.path).readAsBytes();
      final imageParts = [
        DataPart('image/jpeg', imgBuffer),
      ];
      final prompt = TextPart(entradaDeTexto);
      final textImg = TextPart("Image: ");
      final outputImg = TextPart("Output: ");
      final resultExampleEctomorfa = TextPart('{"objetivoMes": "ganar peso","tipoPersona": "hombre","edadMetablicaAproximada": "30 a 40","altura": 190,"peso": 50,"imc": 13.85,"medidas": {"pecho": 50,"cintura": 45,"caderas": 60},"tipoCuerpo": "Contextura física ectomorfa","lugarEjecucion": "gimnasio","equipamientoElementosUsar": "mancuernas , banca plano con barra, disco","calentamiento": "5 minutos de cardio ligero (caminar, trotar, bicicleta)","ejercicios": [{"nombre": "Press inclinado con mancuernas","series": 4,"repeticiones": 12},{"nombre": "Press de banca plano con barral","series": 4,"repeticiones": 12},{"nombre": "Aperturas planas con mancuernas","series": 4,"repeticiones": 12},{"nombre": "Press francés con barra Z","series": 3,"repeticiones": 12},{"nombre": "Extensiones de tríceps con empuñadura W","series": 4,"repeticiones": 15}],"enfriamiento": "5 minutos de cardio ligero (caminar, trotar, bicicleta)","consejos": "beber mucha agua, dormir lo suficiente, comer una dieta saludable y una buena proporción de carbohidratos proteínas grasas.","nutricion": {"desayuno": "3 huevos, 10 g de mantequilla. Tostada integral, 1 plátano. 1 Café con leche o capuccino, 1 batido de proteínas y 1 fruta", "comida": " Pescado (lenguado, o atún) con puré de patatas. Fruta, Galletas de avena.","cena": "Pollo (120 g) con aceite de colza (10 mL) y mostaza (10 mL). Con arroz integral, queso parmesano y tomates."}}');
      final resultExampleMesomorfica = TextPart('{"objetivoMes": "Aumentar y marcar tren superior","tipoPersona": "hombre","edadMetablicaAproximada": "25 a 35","altura": 170,"peso": 80,"imc": 27.68,"medidas": {"pecho": 70,"cintura": 60,"caderas": 70},"tipoCuerpo": "Contextura física mesomórfica","lugarEjecucion": "Gym","equipamientoElementosUsar": "mancuernas , barra, disco, barras paralelas, polea","calentamiento": "10 minutos de cardio ligero (caminar, trotar, bicicleta)","ejercicios": [{"nombre": "Press de pecho plano","series": 4,"repeticiones": 15},{"nombre": "Dominadas – pull ups","series": 4,"repeticiones": 6},{"nombre": "Press militar con barra","series": 4,"repeticiones": 10},{"nombre": "Curls de bíceps","series": 4,"repeticiones": 10},{"nombre": "Fondos en barras paralelas","series": 4,"repeticiones": 8}],"enfriamiento": "10 minutos de cardio ligero (caminar, trotar, bicicleta)","consejos": "beber mucha agua, dormir lo suficiente, comer una dieta saludable, descansar al menos 1 o dos días a la semana, necesita de alimentos con carbohidratos en su dieta.","nutricion": {"desayuno": "Café 200 mLAlmendras 20 gPlátano 1 unidadAvena 80 g2 Claras1 HuevoLeche 200 mL1 cucharada de maca", "comida": " Pechuga de pollo con trigo sarraceno y verdurasFilet de pollo a la plancha 150 gTrigo sarraceno 170 gAceite de oliva virgen 30 mLEspárragos 50 gTomate cherry 50 gFruta 1 unidad","cena": "Lenguado al hornocon pasta integralFilet de lenguado 200 gSalsa de tomates fritos 10 gPasta integral 150 gQueso magro 10 g2 trozos de chocolate negroFruta 1 unidad"}}');
      final resultExampleEndomorfo = TextPart('{"objetivoMes": "Aumentar y marcar tren superior","tipoPersona": "hombre","edadMetablicaAproximada": "25 a 35","altura": 150,"peso": 100,"imc": 44.44,"medidas": {"pecho": 100,"cintura": 80,"caderas": 85},"tipoCuerpo": "Contextura física endomorfo","lugarEjecucion": "Gym","equipamientoElementosUsar": "barra, mancuernas , disco, polea","calentamiento": "15 minutos de cardio ligero (caminar, trotar, bicicleta)","ejercicios": [{"nombre": "Pres inclinado con barra","series": 3,"repeticiones": 8},{"nombre": "Press militar con mancuernas","series": 3,"repeticiones": 8},{"nombre": "Elevaciones laterales con mancuernas","series": 3,"repeticiones": 12},{"nombre": "Curls de bíceps","series": 4,"repeticiones": 10},{"nombre": "Jalon en polea al pecho con agarre cerrado","series": 3,"repeticiones": 12}],"enfriamiento": "10 minutos de cardio ligero (caminar, trotar, bicicleta)","consejos": "beber mucha agua, dormir lo suficiente, comer una dieta baja en carbohidratos simples, limitar el consumo de alimentos dulces y el exceso de azúcar","nutricion": {"desayuno": "huevos, avena, fruta", "comida": " pechuga de pollo, arroz integral, verduras","cena": "pescado, quinoa, verduras"}}');

      final response = await modelProvision.generateContent([
        Content.multi([prompt, 
        textImg, ...imagePartsExampleEctomorfa, resultExampleMesomorfica, outputImg,
        textImg, ...imagePartsExampleMesomorfica, resultExampleEctomorfa, outputImg,
        textImg, ...imagePartsExampleEndomorfo, resultExampleEndomorfo, outputImg,
        textImg, ...imageParts])
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