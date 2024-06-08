import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gympt/core/service/firebase_storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

part 'edit_account_event.dart';
part 'edit_account_state.dart';

class EditAccountBloc extends Bloc<EditAccountEvent, EditAccountState> {
  EditAccountBloc() : super(EditAccountInitial()){
    on<UploadImage>((event, emit) async {
      try {
        final XFile? image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image != null) {
          emit(EditAccountProgress());
          await FirebaseStorageService.uploadImage(filePath: image.path);
          emit(EditPhotoSuccess(image));
        }
      } catch (e) {
        emit(EditAccountError(e.toString()));
        await Future.delayed(const Duration(seconds: 1));
        emit(EditAccountInitial());
      }
    });
  }
}
