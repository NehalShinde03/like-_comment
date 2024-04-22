import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_like/services/data_base_helper.dart';
import 'package:comment_like/model_class/comment_model.dart';
import 'package:comment_like/model_class/show_comment_name_model.dart';
import 'package:comment_like/ui/all_post/all_post_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllPostCubit extends Cubit<AllPostState> {
  AllPostCubit(super.initialState);


  /// text field data change
  void textFieldTextChange({required bool isTextFieldEmpty}){
    emit(state.copyWith(isTextFieldEmpty: isTextFieldEmpty));
  }

  void getCurrentUserName({registerUserId}) async {
    String registerUserName =
        await DataBaseHelper.instance.registerUserName(userId: registerUserId);
    emit(state.copyWith(registerUserName: registerUserName));
  }

  void likeListLength({likeListLength}) async {
    emit(state.copyWith(totalLikesOnPost: likeListLength));
  }

  void insertLikes({required String userId, required String postId}) async {
    bool isLike = await DataBaseHelper.instance
        .insertLikes(postId: postId, userId: userId);
    DataBaseHelper.instance.updateLike(postId: postId, isLike: isLike);
    emit(state.copyWith(isLike: isLike));
  }



  /// insert comment
  void insertComment({required CommentModel commentModel, required int index,}) async{
    try{
      DataBaseHelper.instance.insertComment(commentModel: commentModel,);
    }catch(e){
      throw "Exception(insert Comment) ==> $e";
    }
    final getUserModel = await DataBaseHelper.instance.fireStoreRegisterUserInstance.doc(commentModel.userId).get();
    List<ShowCommentNameModel> commentList = state.commentList;
    commentList.add(ShowCommentNameModel(
      comment: commentModel.comment,
      userName: getUserModel.get('userName')
    ));
    emit(state.copyWith(commentList: commentList, index: state.commentList.length));
    print("state dataList length ==> ${state.commentList.length}");
  }

  /// retrieve list of comments
  void retrieveComment({required String postId}) async{
    emit(state.copyWith(commentList: <ShowCommentNameModel>[], index: 0));
    try{
      final List<ShowCommentNameModel> commentList = await DataBaseHelper.instance.getComments(postId: postId);
      emit(state.copyWith(commentList: commentList));
    }catch(e){
      throw "Exception(get Comment) ==> $e";
    }
  }

  // Future<String> getUserName(String userId) async{
  //   final getUserModel = await DataBaseHelper.instance.fireStoreRegisterUserInstance.doc(userId).get();
  //   String getUserName = getUserModel.get('userName');
  //   print("getUserName ==> $getUserName");
  //   return getUserName;
  // }

}
