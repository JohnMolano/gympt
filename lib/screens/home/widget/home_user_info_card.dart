import 'package:gympt/core/const/color_constants.dart';
import 'package:gympt/core/service/user_service.dart';
import 'package:flutter/material.dart';

class WorkoutUserInfoCard extends StatelessWidget {
  final Color color;
  final UserData userInfo;
  final Function() onTap;

  const WorkoutUserInfoCard({super.key, 
    required this.color,
    required this.userInfo,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              subtitle: Text(userInfo.modelo.objetivoMes, 
                          style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.textGrey,
                        ),),
            ),
            ListTile(
              title: const Text('Tipo de persona:'),
              subtitle: Text(userInfo.modelo.tipoPersona, 
                          style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.textGrey,
                        ),),
            ),
            ListTile(
              title: const Text('Tipo de cuerpo:'),
              subtitle: Text(userInfo.modelo.tipoCuerpo, 
                          style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.textGrey,
                        ),),
            ),
            ListTile(
              title: const Text('Promedio de edad metabólica:'),
              subtitle: Text(userInfo.modelo.edadMetablicaAproximada, 
                          style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.textGrey,
                        ),),
            ),
            ListTile(
              title: const Text('Promedio de altura:'),
              subtitle: Text(userInfo.modelo.altura.toString(), 
                          style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.textGrey,
                        ),),
            ),
            ListTile(
              title: const Text('Promedio de peso:'),
              subtitle: Text(userInfo.modelo.peso.toString(), 
                          style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.textGrey,
                        ),),
            ),
            ListTile(
              title: const Text('Indice de masa corporal:'),
              subtitle: Text(userInfo.modelo.imc.toString(), 
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
              subtitle: Text(userInfo.modelo.medidas.pecho.toString(), 
                          style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.textGrey,
                        ),),
            ),
            ListTile(
              title: const Text('Cintura:'),
              subtitle: Text(userInfo.modelo.medidas.cintura.toString(), 
                          style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.textGrey,
                        ),),
            ),
            ListTile(
              title: const Text('Caderas:'),
              subtitle: Text(userInfo.modelo.medidas.caderas.toString(), 
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
              subtitle: Text(userInfo.modelo.lugarEjecucion, 
                          style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.textGrey,
                        ),),
            ),
            ListTile(
              title: const Text('Equipos a usar:'),
              subtitle: Text(userInfo.modelo.equipamientoElementosUsar, 
                          style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.textGrey,
                        ),),
            ),
            ListTile(
              title: const Text('Calentamiento:'),
              subtitle: Text(userInfo.modelo.calentamiento, 
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
              title: Text(userInfo.modelo.ejercicios[0].nombre),
              subtitle: Text('Series: ${userInfo.modelo.ejercicios[0].series}, Repeticiones: ${userInfo.modelo.ejercicios[0].repeticiones}', 
                          style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.textGrey,
                        ),),
            ),
            ListTile(
              title: Text(userInfo.modelo.ejercicios[1].nombre),
              subtitle: Text('Series: ${userInfo.modelo.ejercicios[1].series}, Repeticiones: ${userInfo.modelo.ejercicios[1].repeticiones}', 
                          style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.textGrey,
                        ),),
            ),
            ListTile(
              title: Text(userInfo.modelo.ejercicios[2].nombre),
              subtitle: Text('Series: ${userInfo.modelo.ejercicios[2].series}, Repeticiones: ${userInfo.modelo.ejercicios[2].repeticiones}', 
                          style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.textGrey,
                        ),),
            ),
            ListTile(
              title: Text(userInfo.modelo.ejercicios[3].nombre),
              subtitle: Text('Series: ${userInfo.modelo.ejercicios[3].series}, Repeticiones: ${userInfo.modelo.ejercicios[3].repeticiones}', 
                          style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.textGrey,
                        ),),
            ),
            ListTile(
              title: const Text('Enfriamiento:'),
              subtitle: Text(userInfo.modelo.enfriamiento, 
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
              subtitle: Text(userInfo.modelo.nutricion.desayuno, 
                          style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.textGrey,
                        ),),
            ),
            ListTile(
              title: const Text('Almuerzo:'),
              subtitle: Text(userInfo.modelo.nutricion.comida, 
                          style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.textGrey,
                        ),),
            ),
            ListTile(
              title: const Text('Cena:'),
              subtitle: Text(userInfo.modelo.nutricion.cena, 
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
              subtitle: Text(userInfo.modelo.consejos, 
                          style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.textGrey,
                        ),),
            )
            // Agrega los otros elementos aquí de la misma manera
          ],
        ),
      ),
    );
  }
}
