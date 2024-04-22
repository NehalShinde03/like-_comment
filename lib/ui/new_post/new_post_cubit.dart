import 'package:comment_like/services/data_base_helper.dart';
import 'package:comment_like/ui/new_post/new_post_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class NewPostCubit extends Cubit<NewPostState>{
  NewPostCubit(super.initialState);
  /// image picker
  void imagePicker() async{
   XFile? pickedImage = await DataBaseHelper.instance.imagePicker();
    if(pickedImage != null){
      // XFile pickedImageFile = XFile(pickedImage.path);
      emit(state.copyWith(pickedImageFile: XFile(pickedImage.path)));
    }
  }

  /// upload image
  void imageUpload({required XFile uploadImagePath, required bool isImageUploaded, required BuildContext context}) async{
     String uploadedImage = await DataBaseHelper.instance.uploadImages(uploadImagePath: uploadImagePath, context: context);
     emit(state.copyWith(uploadImage: uploadedImage, isImageUploaded: isImageUploaded));
  }

}