import 'package:comment_like/model_class/comment_model.dart';
import 'package:comment_like/model_class/show_comment_name_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class AllPostState extends Equatable {
  final String registerUserId;
  final String registerUserName;
  final bool isLike;
  final int totalLikesOnPost;
  final List likePostList;

  final int index;

  final TextEditingController commentController;
  final List<ShowCommentNameModel> commentList;
  final bool isTextFieldEmpty;
  // final Map<String, dynamic> commentData;

  const AllPostState({
    this.registerUserId = "",
    this.registerUserName = "",
    this.isLike = false,
    this.totalLikesOnPost = 0,
    this.likePostList = const [],
    required this.commentController,
    this.commentList = const <ShowCommentNameModel>[],
    this.index = 0,
    this.isTextFieldEmpty = false
    // this.commentData = const {}
  });

  @override
  List<Object?> get props => [
    registerUserId,
    registerUserName,
    isLike,
    totalLikesOnPost,
    likePostList,
    commentController,
    commentList,
    index,
    isTextFieldEmpty
    // commentData
  ];

  AllPostState copyWith({
    String? registerUserId,
    String? registerUserName,
    bool? isLike,
    int? totalLikesOnPost,
    List? likePostList,
    TextEditingController? commentController,
    List<ShowCommentNameModel>? commentList,
    int? index,
    bool? isTextFieldEmpty,
    // Map<String, dynamic>? commentData,
  }) {
    return AllPostState(
      registerUserId: registerUserId ?? this.registerUserId,
      registerUserName: registerUserName ?? this.registerUserName,
      isLike: isLike ?? this.isLike,
      totalLikesOnPost: totalLikesOnPost ?? this.totalLikesOnPost,
      likePostList: likePostList ?? this.likePostList,
      commentController: commentController ?? this.commentController,
      commentList: commentList ?? this.commentList,
      // commentData: commentData ?? this.commentData,
      index: index ?? this.index,
      isTextFieldEmpty: isTextFieldEmpty ?? this.isTextFieldEmpty
    );
  }
}
