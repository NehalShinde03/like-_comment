import 'package:flutter/material.dart';

class SearchUserProfile extends StatefulWidget {
  const SearchUserProfile({super.key});

  static const String routeName = '/search_user_profile_ui';
  static Widget builder(BuildContext context) => SearchUserProfile();

  @override
  State<SearchUserProfile> createState() => _SearchUserProfileState();
}

class _SearchUserProfileState extends State<SearchUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("search"),),
    );
  }
}
