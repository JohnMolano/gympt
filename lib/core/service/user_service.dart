import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:gympt/core/extensions/exceptions.dart';
import 'package:gympt/core/service/auth_service.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class UserService {
  static final FirebaseAuth firebase = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;


  static Future<bool> editPhoto(String photoUrl) async {
    try {
      await firebase.currentUser?.updatePhotoURL(photoUrl);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  static Future<bool> changeUserData(
      {required String displayName, required String email}) async {
    try {
      await firebase.currentUser?.updateDisplayName(displayName);
      await firebase.currentUser?.verifyBeforeUpdateEmail(email);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception(e);
    }
  }

  static Future<bool> changePassword({required String newPass}) async {
    try {
      await firebase.currentUser?.updatePassword(newPass);
      return true;
    } on FirebaseAuthException catch (e) {
      throw CustomFirebaseException(getExceptionMessage(e));
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> signOut() async {
    await firebase.signOut();
  }

  static String getUId() {
    final now = DateTime.now();
    final year = now.year.toString();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final hours = now.hour.toString().padLeft(2, '0');
    final minutes = now.minute.toString().padLeft(2, '0');
    final seconds = now.second.toString().padLeft(2, '0');
    final milliseconds = now.millisecond.toString().padLeft(3, '0');
    return '$year$month$day$hours$minutes$seconds$milliseconds';
  }

  static Future<Map<String, dynamic>?> getLocationUser(String ip) async {
    try {
      final response = await http.get(Uri.parse('https://api.ipbase.com/v1/json/$ip'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        if (kDebugMode) {
          print('Error fetching IP address: ${response.statusCode}');
        }
        return null;
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching IP address: $error');
      }
      return null;
    }
  }

  static Future<String?> getWifiIP() async {
    final info = NetworkInfo();
    String? wifiIP = await info.getWifiIP();
    return wifiIP;
  }
  
  static Future<String?> getPublicIP() async {
    try {
      final response = await http.get(Uri.parse('https://api.ipify.org?format=json'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['ip'];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getPublicIP fetching IP: $e');
      }
    }
    return null;
  }

  static Future<bool> changeUserDataRoutine({required String imageUrl,required String visionResult}) async {
    try {
      //final ipAddress = await UserService.getWifiIP(); //mobile
      final ipAddress = await getPublicIP();
      final geo = await UserService.getLocationUser(ipAddress!);
      final clientId = UserService.getUId();
      await firestore.collection('users').doc(clientId).set({
        'visionResult': visionResult,
        'imageUrl': imageUrl,
        'ipAddress': ipAddress,
        'geo': geo,
      });
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error en changeUserDataRoutine al guardar datos: $e');
      }
      throw Exception(e);
    }
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
  final String edadMetablicaAproximada;
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
    required this.edadMetablicaAproximada,
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
      edadMetablicaAproximada: json['edadMetablicaAproximada'],
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