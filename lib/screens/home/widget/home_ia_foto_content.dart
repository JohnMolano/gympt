import 'package:gympt/core/const/color_constants.dart';
import 'package:gympt/core/const/data_constants.dart';
import 'package:gympt/core/const/path_constants.dart';
import 'package:gympt/core/const/text_constants.dart';
import 'package:gympt/screens/home/widget/home_statistics.dart';
import 'package:gympt/screens/home/widget/image_picker.dart';
import 'package:gympt/screens/workout_details_screen/page/workout_details_page.dart';
import 'package:flutter/material.dart';

import 'home_exercises_card.dart';

class HomeIAFotoContent extends StatelessWidget {
  const HomeIAFotoContent({
    super.key,
  });
  
  get createdRoutine => false;

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
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          createdRoutine ? const HomeStatistics() 
          : _createProgress(), const SizedBox(height: 25), const ImagePickerScreen(),
          //const VideoYoutubeScreen(),
          //const YoutubeVideoIframe(),
          //const SizedBox(height: 35),
          //const HomeStatistics(),
          
        ],
      ),
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
}
