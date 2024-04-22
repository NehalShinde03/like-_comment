import 'dart:io';

import 'package:comment_like/common/colors/common_colors.dart';
import 'package:comment_like/common/spacing/common_spacing.dart';
import 'package:comment_like/common/widget/common_elevated_button.dart';
import 'package:comment_like/common/widget/common_text.dart';
import 'package:comment_like/common/widget/common_textfield.dart';
import 'package:comment_like/services/data_base_helper.dart';
import 'package:comment_like/model_class/new_post_model.dart';
import 'package:comment_like/ui/new_post/new_post_cubit.dart';
import 'package:comment_like/ui/new_post/new_post_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class NewPostView extends StatefulWidget {
  const NewPostView({super.key});

  static const String routeName = '/new_post_view';

  static Widget builder(BuildContext context) {
    final registerUserId = ModalRoute.of(context)?.settings.arguments as String?;
    return BlocProvider(
      create: (context) => NewPostCubit(
        NewPostState(
          descriptionController: TextEditingController(),
          locationController: TextEditingController(),
          pickedImageFile: XFile(""),
          registerUserId: registerUserId??""
        ),
      ),
      child: const NewPostView(),
    );
  }

  @override
  State<NewPostView> createState() => _NewPostViewState();
}

class _NewPostViewState extends State<NewPostView> {

  NewPostCubit get newPostCubit => context.read<NewPostCubit>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const CommonText(text: 'New Post', fontSize: Spacing.xLarge),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: BlocBuilder<NewPostCubit, NewPostState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// upload image
                  Padding(
                    padding: PaddingValue.medium,
                    child: GestureDetector(
                      onTap: () {
                          context.read<NewPostCubit>().imagePicker();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: MediaQuery.of(context).size.height / 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey),
                          color: Colors.white,
                        ),
                        child: SizedBox(
                            child: state.pickedImageFile.path.isEmpty
                                ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 150,
                                  color: Colors.grey,
                                ),
                                CommonText(
                                  text: 'Tap to Select Image',
                                  fontWeight: FontWeight.bold,
                                  textColor: Colors.grey,
                                  fontSize: 20,
                                )
                              ],
                            )
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                  File(state.pickedImageFile.path),
                                  fit: BoxFit.fill),
                            ),
                        ),
                      ),
                    ),
                  ),

                  /// enter description
                  const Gap(20),
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
                    child: CommonTextField(
                      controller: state.descriptionController,
                      labelText: 'Enter Description',
                      prefixIcon: Icons.description,
                      iconColor: Colors.blue,
                    ),
                  ),

                  /// enter location
                  const Gap(6),
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
                    child: CommonTextField(
                      controller: state.locationController,
                      labelText: 'Enter location',
                      prefixIcon: Icons.location_on,
                      iconColor: Colors.red,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: PaddingValue.large,
                        child: Center(
                          child: CommonElevatedButton(
                            text: 'Post',
                            onPressed: () async {

                              ///upload image
                              // DataBaseHelper.instance.uploadImages(uploadImagePath: state.pickedImageFile);
                              if(state.isImageUploaded == false){
                                print('register user Id ====> ${state.registerUserId}');
                                newPostCubit.imageUpload(
                                    uploadImagePath: state.pickedImageFile,
                                    isImageUploaded: true,
                                    context: context
                                );
                              }

                              /// insert post desc, location & image
                             if(state.uploadImage.isNotEmpty){
                               DataBaseHelper.instance.insertNewPost(
                                 newPostModel: NewPostModel(
                                   userId: state.registerUserId,
                                   imageUrl: state.uploadImage,
                                   description: state.descriptionController.text,
                                   location: state.locationController.text,
                                   isLike: false
                                 ),
                               );
                               Navigator.pop(context);
                             }else{
                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Column(
                                 children: [
                                   CommonText(text: 'Image is Uploaded...', textColor: CommonColor.white),
                                   CommonText(text: '\t\tPlease Wait...', textColor: CommonColor.white),
                                 ],
                               )));
                             }


                              ///insert post data
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: PaddingValue.large,
                        child: Center(
                          child: CommonElevatedButton(
                            text: 'Cancel',
                            onPressed: () {},
                          ),
                        ),
                      ),

                      // state.uploadImage.isEmpty
                      // ? CircularProgressIndicator()
                      // : SizedBox()

                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
    ));
  }
}
