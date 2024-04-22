import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_like/common/colors/common_colors.dart';
import 'package:comment_like/common/spacing/common_spacing.dart';
import 'package:comment_like/common/widget/common_text.dart';
import 'package:comment_like/services/data_base_helper.dart';
import 'package:comment_like/model_class/comment_model.dart';
import 'package:comment_like/model_class/show_comment_name_model.dart';
import 'package:comment_like/ui/all_post/all_post_cubit.dart';
import 'package:comment_like/ui/all_post/all_post_state.dart';
import 'package:comment_like/ui/new_post/new_post_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class AllPostView extends StatefulWidget {
  const AllPostView({super.key});

  static const String routeName = '/all_post_view';

  static Widget builder(BuildContext context) {
    final registerUserId =
    ModalRoute.of(context)?.settings.arguments as String?;
    return BlocProvider(
      create: (context) => AllPostCubit(AllPostState(
          registerUserId: registerUserId ?? "",
          commentController: TextEditingController())),
      child: const AllPostView(),
    );
  }

  @override
  State<AllPostView> createState() => _AllPostViewState();
}

class _AllPostViewState extends State<AllPostView> {
  AllPostCubit get allPostCubit => context.read<AllPostCubit>();
  // List<dynamic> likeList = [];
  // final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    allPostCubit.state.commentController.clear();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _globalKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const CommonText(text: 'All Post', fontSize: Spacing.xLarge),
      ),
      floatingActionButton: BlocBuilder<AllPostCubit, AllPostState>(
          builder: (context, state) {
            return FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, NewPostView.routeName,
                  arguments: state.registerUserId,
                );
              },
              child: const Icon(Icons.rocket_launch),
            );
          }),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("New Post").snapshots(),
        builder: (context, snapshot) {
          print("type of snaphot ===> ${snapshot.runtimeType}");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if (snapshot.connectionState == ConnectionState.none) {
            return Center(
              child: CommonText(
                  text: 'Connection Failed',
                  textColor: CommonColor.white,
                  fontSize: Spacing.medium),
            );
          }
          else if (!snapshot.hasData) {
            return Center(
              child: CommonText(
                  text: 'No Data Available..!!!',
                  textColor: CommonColor.white,
                  fontSize: Spacing.medium),
            );
          }
          else {
            return ListView.separated(
              itemCount: snapshot.data?.docs.length ?? 0,
              shrinkWrap: true,
              // reverse: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: PaddingValue.small,
                  child: Card(
                    elevation: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// name and delete
                        Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: Spacing.xMedium,
                            vertical: Spacing.small,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      BlocBuilder<AllPostCubit, AllPostState>(
                                        builder: (context, state) {
                                          return Padding(
                                            padding: const EdgeInsetsDirectional.symmetric(
                                              horizontal: Spacing.small,
                                            ),
                                            child: CommonText(
                                              text: state.registerUserName,
                                            ),
                                          );
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .symmetric(
                                          horizontal: Spacing.small,
                                        ),
                                        child: CommonText(
                                          text: snapshot.data?.docs[index]['location'],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              PopupMenuButton(
                                icon: const Icon(
                                  Icons.more_horiz_outlined,
                                ),
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 1,
                                    child: CommonText(text: 'Delete'),
                                  )
                                ],
                                onSelected: (value) {
                                  if (value == 1) {
                                    DataBaseHelper.instance.deletePost(
                                      postId: snapshot.data?.docs[index]['postId'],
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                        /// show picked photo
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1,
                            height: MediaQuery.of(context).size.height / 2,
                            margin: const EdgeInsetsDirectional.symmetric(
                                vertical: Spacing.medium,
                                horizontal: RadiusValue.medium),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                snapshot.data?.docs[index].get('imageUrl'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),

                        /// like, comment, desc
                        Padding(
                          padding: const EdgeInsetsDirectional.symmetric(horizontal: Spacing.small),
                          child: Row(
                            children: [

                              ///for like
                              BlocBuilder<AllPostCubit, AllPostState>(
                                builder: (context, state) {
                                  return IconButton(
                                    onPressed: () {
                                    /*DataBaseHelper.instance.insertLikes(
                                          postId: snapshot.data?.docs[index]['postId'],
                                          userId: state.registerUserId
                                      );*/
                                      allPostCubit.insertLikes(
                                          postId: snapshot.data?.docs[index]['postId'],
                                          userId: state.registerUserId
                                      );
                                    },
                                    icon: Icon(
                                      snapshot.data?.docs[index]['isLike']
                                           ? Icons.favorite
                                           : Icons.favorite_border,
                                      color: Colors.red,
                                      size: Spacing.xxLarge,
                                    ),
                                  );
                                },
                              ),

                              ///for comment
                              IconButton(
                                onPressed: () {

                                  context.read<AllPostCubit>().retrieveComment(postId: snapshot.data?.docs[index]['postId']);

                                  ///showModalBottom Sheet does not move along with keyboard
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    useSafeArea: true,
                                    context: context,
                                    builder: (context2) {
                                      return BlocProvider.value(
                                        value: BlocProvider.of<AllPostCubit>(context),
                                        child: Padding(
                                          padding: MediaQuery.of(context).viewInsets,
                                          child: Container(
                                            height: MediaQuery.of(context).size.height/2,
                                            margin: EdgeInsetsDirectional.only(
                                              bottom: MediaQuery.of(context2).viewInsets.bottom
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Gap(Spacing.small),
                                                const CommonText(
                                                  text: "💬",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: TextSize.appBarTitle,
                                                ),


                                                BlocBuilder<AllPostCubit, AllPostState>(
                                                  builder: (context, state){
                                                    print("comment List length view ===> ${state.commentList.length}");
                                                    return CommonText(
                                                      text: "${state.commentList.length} Comments",
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: TextSize.appBarTitle,
                                                    );
                                                  },
                                                ),


                                                // BlocProvider.value(
                                                //       value: BlocProvider.of<AllPostCubit>(context),
                                                //       child: BlocSelector<AllPostCubit, AllPostState, List<ShowCommentNameModel>>(
                                                //         selector: (state) => state.commentList,
                                                //         builder: (context, state){
                                                //           return CommonText(
                                                //             text: '${state.length}',
                                                //             fontWeight: FontWeight.bold,
                                                //             fontSize: TextSize.label,
                                                //           );
                                                //         },
                                                //       ),
                                                //     ),

                                                const Gap(Spacing.medium),
                                                BlocBuilder<AllPostCubit, AllPostState>(
                                                    builder: (context, state) {
                                                      return Padding(
                                                        padding: const EdgeInsetsDirectional.symmetric(horizontal: Spacing.small),
                                                        child: Row(
                                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: Spacing.xxxLarge * 7.0,
                                                              child: Padding(
                                                                padding: const EdgeInsetsDirectional.symmetric(horizontal: Spacing.small),
                                                                child: TextFormField(
                                                                  controller: state.commentController,
                                                                  cursorColor: CommonColor.black,
                                                                  decoration: InputDecoration(
                                                                    hintText: "Type Something...",
                                                                    hintStyle: TextStyle(
                                                                        color: CommonColor.black
                                                                    ),
                                                                    contentPadding: const EdgeInsetsDirectional.only(
                                                                      start: Spacing.small,
                                                                      bottom: Spacing.xxLarge,
                                                                    ),
                                                                    border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(Spacing.large),
                                                                        borderSide: BorderSide(color: CommonColor.black)
                                                                    ),
                                                                    focusedBorder: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(Spacing.large),
                                                                        borderSide: BorderSide(color: CommonColor.black)
                                                                    ),
                                                                  ),
                                                                  onChanged: (val){
                                                                    (val.isNotEmpty)
                                                                        ? allPostCubit.textFieldTextChange(isTextFieldEmpty: true)
                                                                        : allPostCubit.textFieldTextChange(isTextFieldEmpty: false);
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              behavior: HitTestBehavior.opaque,
                                                              onTap: (state.isTextFieldEmpty)
                                                                  ? () {
                                                                print("textEditingController ===> ${state.commentController.text}");
                                                                    allPostCubit.insertComment(
                                                                        commentModel: CommentModel(
                                                                          comment: state.commentController.text ,
                                                                          postId: snapshot.data?.docs[index]['postId'],
                                                                          userId: state.registerUserId,
                                                                        ),
                                                                        index: state.commentList.length,
                                                                    );
                                                                  state.commentController.value = TextEditingValue(text: "");
                                                                 allPostCubit.textFieldTextChange(isTextFieldEmpty: false);
                                                              } : null,
                                                              child: const CircleAvatar(
                                                                radius: 20,
                                                                backgroundColor: Colors.white,
                                                                child: Icon(Icons.telegram, size: Spacing.xxxLarge * 1.1),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }),

                                                const Gap(Spacing.medium),
                                                Flexible(
                                                    child: BlocBuilder<AllPostCubit, AllPostState>(
                                                      builder: (context, state) {
                                                        print("comment List length view ===> ${state.commentList.length}");
                                                          if(state.commentList.isEmpty){
                                                            return const Center(child: CircularProgressIndicator(),);
                                                          }else{
                                                            return ListView.separated(
                                                              itemCount: state.commentList.length,
                                                              shrinkWrap: true,
                                                              reverse: true,
                                                              itemBuilder: (context, index) {
                                                                return  SizedBox(
                                                                  child: Row(
                                                                    children: [
                                                                      const Padding(
                                                                        padding:
                                                                        EdgeInsetsDirectional
                                                                            .symmetric(horizontal: 5,vertical: 2),
                                                                        child: CircleAvatar(
                                                                          backgroundColor:Colors.black,
                                                                          radius: 15,
                                                                        ),
                                                                      ),

                                                                      Padding(
                                                                          padding: const EdgeInsetsDirectional.symmetric(horizontal:Spacing.small),
                                                                          child: Row(
                                                                            children: [
                                                                              CommonText(
                                                                                text: state.commentList[index].userName,
                                                                                textColor: Colors.black,
                                                                                fontWeight:
                                                                                FontWeight.bold,
                                                                                fontSize: TextSize.appBarSubTitle,
                                                                              ),
                                                                              const Gap(Spacing.small),

                                                                              CommonText(
                                                                                text: state.commentList[index].comment,
                                                                                textColor: Colors.black,
                                                                                fontWeight:
                                                                                FontWeight.w400,
                                                                                fontSize: TextSize.appBarSubTitle,
                                                                              ),
                                                                            ],
                                                                          )
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );

                                                              },
                                                              separatorBuilder: (context, index) {
                                                                return const Gap(Spacing.xSmall);
                                                              },
                                                            );
                                                          }
                                                        },
                                                      )
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.comment_outlined,
                                  color: Colors.black,
                                  size: Spacing.xLarge,
                                ),
                              )

                            ],
                          ),
                        ),

                        ///total number of likes   /// done
                        StreamBuilder<List<String>>(
                            stream: DataBaseHelper.instance.showUserNameToLikeAPost(
                                postId: snapshot.data?.docs[index]['postId']
                            ).asStream(),
                            builder: (context, snapshot) {
                              return GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          const Gap(Spacing.small),
                                          const CommonText(
                                            text: "❤️",
                                            fontWeight: FontWeight.bold,
                                            fontSize: TextSize.appBarTitle,
                                          ),
                                          CommonText(
                                            text: '${snapshot.data?.length ?? 0} Likes',
                                            fontWeight: FontWeight.bold,
                                            fontSize: TextSize.label,
                                          ),
                                          const Gap(15),
                                          Flexible(
                                            child: ListView.separated(
                                              itemCount: snapshot.data?.length ?? 0,
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  children: [
                                                    const Padding(
                                                      padding:
                                                      EdgeInsetsDirectional
                                                          .symmetric(horizontal: 5,vertical: 2),
                                                      child: CircleAvatar(
                                                        backgroundColor:Colors.black,
                                                        radius: 15,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsetsDirectional
                                                          .symmetric(
                                                          horizontal:Spacing.small),
                                                      child: CommonText(
                                                        text: snapshot.data?[index] ?? "",
                                                        textColor: Colors.black,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: TextSize
                                                            .appBarSubTitle,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                              separatorBuilder: (context, index) {
                                                return const Gap(Spacing.xSmall);
                                              },
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: Spacing.large,
                                        bottom: Spacing.xSmall),
                                    child: CommonText(
                                      text: '${snapshot.data?.length ?? 0} Likes',
                                      textColor: Colors.grey,
                                    )
                                ),
                              );
                            }
                        ),

                        /// description
                        Padding(
                          padding: const EdgeInsetsDirectional.symmetric(horizontal: Spacing.xLarge, vertical: Spacing.medium),
                          child: CommonText(
                            text: snapshot.data?.docs[index]['description'],
                            textColor: Colors.black,
                            fontWeight: TextWeight.semiBold,
                            fontSize: TextSize.label-2,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Gap(Spacing.medium);
              },
            );
          }
        },
      ),
    );
  }
}
