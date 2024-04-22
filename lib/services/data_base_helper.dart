import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_like/common/spacing/common_spacing.dart';
import 'package:comment_like/common/widget/common_text.dart';
import 'package:comment_like/model_class/comment_model.dart';
import 'package:comment_like/model_class/new_post_model.dart';
import 'package:comment_like/model_class/registration_model.dart';
import 'package:comment_like/model_class/show_comment_name_model.dart';
import 'package:comment_like/ui/all_post/all_post_view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motion_toast/motion_toast.dart';

// StreamController<List<String>> streamController = StreamController<List<String>>.broadcast();

class DataBaseHelper {
  DataBaseHelper._();

  static final instance = DataBaseHelper._();

  final fireStoreRegisterUserInstance =
  FirebaseFirestore.instance.collection("RegisterUer");

  final fireStoreNewPostInstance =
  FirebaseFirestore.instance.collection("New Post");

  final fireStoreLikeInstance = FirebaseFirestore.instance.collection("Like");

  final fireStoreCommentInstance =
  FirebaseFirestore.instance.collection("Comment");

  List<dynamic> likeList = [];
  List<dynamic> commentList = [];

  ///insert new user record in fireStore (collection name = 'RegisterUser')
  void insertNewUser({required RegistrationModel registrationModel}) async {
    await fireStoreRegisterUserInstance
        .add(registrationModel.toJson())
        .then((value) {
      value.set({'userId': value.id}, SetOptions(merge: true));
    });
  }

  /// compare sign-in user record with fireStore all user data
  void compareSignInRecordWithAllUser(
      {required String userEmail,
        required String userPassword,
        context}) async {
    fireStoreRegisterUserInstance
        .where('userEmail', isEqualTo: userEmail)
        .where('userPassword', isEqualTo: userPassword)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.size > 0) {
        snapshot.docs.forEach((element) {
          Navigator.pushNamed(context, AllPostView.routeName,
              arguments: element.get('userId'));
        });
      } else {
        MotionToast.error(
          toastDuration: const Duration(seconds: 3),
          title: const CommonText(
              text: 'Login',
              fontSize: Spacing.normal,
              fontWeight: TextWeight.bold),
          description: const CommonText(
            text: 'InValid Credential..!!!',
          ),
          barrierColor: Colors.black.withOpacity(0.3),
          dismissable: true,
          animationType: AnimationType.fromLeft,
          animationCurve: Curves.bounceOut,
          iconType: IconType.cupertino,
        ).show(context);
      }
    });
  }

  /// insert new post description, location
  void insertNewPost({required NewPostModel newPostModel}) async {
    print('desc ====> ${newPostModel.description}');
    print('loc ====> ${newPostModel.location}');
    await fireStoreNewPostInstance.add(newPostModel.toJson()).then((value) {
      value.set({'postId': value.id}, SetOptions(merge: true));
    });
  }

  void updateLike({required String postId, required bool isLike}) async{
    await fireStoreNewPostInstance.doc(postId).update({'isLike' : isLike});
  }

  /// picked image from gallery
  Future<XFile?> imagePicker() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  /// upload image
  Future<String> uploadImages({required XFile uploadImagePath, context}) async {
    if (uploadImagePath.path.isNotEmpty) {
      try {
        Reference reference = FirebaseStorage.instance
            .ref()
            .child('Images/')
            .child(uploadImagePath.name);
        var uploadImage = await reference.putFile(File(uploadImagePath.path));
        String downloadImageUrl = await uploadImage.ref.getDownloadURL();
        print('upload image type ===> ${uploadImage.runtimeType}');
        return downloadImageUrl;
      } catch (e) {
        print('Exception ====> $e');
      }
    }
    return "";
  }

  ///delete post
  void deletePost({required String postId}) {
    fireStoreNewPostInstance.doc(postId).delete();
  }

  /// get register user name
  Future<String> registerUserName({required String userId}) async {
    DocumentSnapshot<Map<String, dynamic>> userName =
    await fireStoreRegisterUserInstance.doc(userId).get();
    return userName.get('userName');
  }


  ///insert Like in newPost Collection
  insertLikes({required String postId, required String userId}) async{
    bool userAlreadyLikeOnPost = false;
    FirebaseFirestore.instance.collection("New Post").doc().get();
    await fireStoreNewPostInstance
        .where('postId', isEqualTo: postId)
        .where("like" , arrayContains: userId)
        .get().then((value){
      print('match size ===> ${value.size}');
      if(value.size > 0){
        fireStoreNewPostInstance.doc(postId).update({"like" : FieldValue.arrayRemove([userId])});
        userAlreadyLikeOnPost = false;
      }
      else{
        fireStoreNewPostInstance.doc(postId).update({"like" : FieldValue.arrayUnion([userId])});
        userAlreadyLikeOnPost = true;
      }
    });
    print('userAlreadyLikeOnPost ===> $userAlreadyLikeOnPost');
    return userAlreadyLikeOnPost;
  }

  /// done
  Future<List<String>> showUserNameToLikeAPost({required String postId}) async{
    List<String> totalListList = [];
    DocumentSnapshot<Map<String, dynamic>> getPostData = await fireStoreNewPostInstance.doc(postId).get();
    List<String> getAllUserToBeLikeAPost  = List<String>.from(getPostData.get('like'));
    for(int i=0; i<getAllUserToBeLikeAPost.length; i++){
      DocumentSnapshot<Map<String, dynamic>> getUseData = await fireStoreRegisterUserInstance.doc(getAllUserToBeLikeAPost[i]).get();
      totalListList.add(getUseData.get('userName'));
    }
    return totalListList;
  }


  /// insert comment data
  Future<void> insertComment({required CommentModel commentModel}) async {
    await fireStoreCommentInstance.add(commentModel.toJson())
        .then((value) async {
            value.set({'commentId': value.id}, SetOptions(merge: true));
            await fireStoreNewPostInstance.doc(commentModel.postId).update({
               'comment': FieldValue.arrayUnion([value.id])
            });
    });
  }

  /// getComments
  // Future<List<ShowCommentNameModel>> getComment({required String postId}) async {
  //   final List<ShowCommentNameModel> getCommentList = <ShowCommentNameModel>[];
  //   try {
  //     final getPostData = await fireStoreNewPostInstance.doc(postId).get();
  //     List<String> getListOfCommentId = List<String>.from(getPostData.data()!['comment'] ?? []);
  //     for (int i = 0; i < getListOfCommentId.length; i++) {
  //       final commentDoc = await fireStoreCommentInstance.doc(getListOfCommentId[i]).get();
  //       final userNameDoc = await fireStoreRegisterUserInstance.doc(commentDoc.data()!['userId']).get();
  //       getCommentList.add(ShowCommentNameModel(
  //         comment: commentDoc.get('comment'),
  //         userName: userNameDoc.get('userName')
  //       ));
  //     }
  //     return getCommentList;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }


  Future<List<ShowCommentNameModel>> getComments({required String postId}) async {
    try {
      final postData = await fireStoreNewPostInstance.doc(postId).get();
      final List<String> commentIds = List<String>.from(postData.data()!['comment'] ?? []);

      final List<DocumentSnapshot> commentSnapshots =
            await Future.wait(commentIds.map((commentId) => fireStoreCommentInstance.doc(commentId).get()));

      final List<ShowCommentNameModel> comments = [];

      for (final commentSnapshot in commentSnapshots) {
        final userId = commentSnapshot.get('userId');
        final userNameDoc = await fireStoreRegisterUserInstance.doc(userId).get();
        // final userName = userNameDoc.get('userName');

        comments.add(ShowCommentNameModel(
          comment: commentSnapshot.get('comment'),
          userName: userNameDoc.get('userName'),
        ));
      }

      return comments;
    } catch (e) {
      rethrow;
    }
  }




}
/// element.data()['comment'] vs commentDocRef.get('comment')
