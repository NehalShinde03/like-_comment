
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileUi extends StatefulWidget {
  const ProfileUi({super.key});

  static const String routeName = '/profile_ui';
  static Widget builder(BuildContext context) => ProfileUi();

  @override
  State<ProfileUi> createState() => _ProfileUiState();
}

class _ProfileUiState extends State<ProfileUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Center(child: Text("Profile view", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)),
    );
  }
}
