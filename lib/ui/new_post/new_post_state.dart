import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewPostState extends Equatable {
  final TextEditingController descriptionController;
  final TextEditingController locationController;
  final XFile pickedImageFile;
  final String uploadImage;
  final bool isImageUploaded;
  final String registerUserId;

  const NewPostState(
      {required this.descriptionController,
      required this.locationController,
      required this.pickedImageFile,
      this.uploadImage="",
      this.isImageUploaded = false,
      this.registerUserId = ""
      });

  @override
  List<Object?> get props =>
      [descriptionController, locationController, pickedImageFile, uploadImage, isImageUploaded, registerUserId];

  NewPostState copyWith({
    TextEditingController? descriptionController,
    TextEditingController? locationController,
    XFile? pickedImageFile,
    String? uploadImage,
    bool? isImageUploaded,
    String? registerUserId
  }) {
    return NewPostState(
        descriptionController:
            descriptionController ?? this.descriptionController,
        locationController: locationController ?? this.locationController,
        pickedImageFile: pickedImageFile ?? this.pickedImageFile,
        uploadImage: uploadImage ?? this.uploadImage,
        isImageUploaded: isImageUploaded ?? this.isImageUploaded,
        registerUserId: registerUserId ?? this.registerUserId
      ,);
  }
}
