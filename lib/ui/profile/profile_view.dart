import 'package:comment_like/ui/profile/profile_cubit.dart';
import 'package:comment_like/ui/profile/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  static const String routeName = '/profile_view';
  static Widget builder(BuildContext context){
    return BlocProvider(
      create: (context) => ProfileCubit(ProfileState()),
      child: ProfileView(),
    );
  }

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('profile')),
    );
  }
}
