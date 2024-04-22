import 'package:comment_like/ui/all_post/all_post_view.dart';
import 'package:comment_like/ui/bottom_navigation_bar/bottom_navigation_bar_ui.dart';
import 'package:comment_like/ui/login/login_view.dart';
import 'package:comment_like/ui/new_post/new_post_view.dart';
import 'package:comment_like/ui/profile/profile_view.dart';
import 'package:comment_like/ui/registration/registration_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: BottomNavigationBarUi.routeName,
      routes: route,
    );
  }

  Map<String, WidgetBuilder> get route => <String, WidgetBuilder>{
    RegistrationView.routeName:RegistrationView.builder,
    LoginView.routeName:LoginView.builder,
    NewPostView.routeName:NewPostView.builder,
    AllPostView.routeName:AllPostView.builder,
    ProfileView.routeName:ProfileView.builder,
    BottomNavigationBarUi.routeName:BottomNavigationBarUi.builder
  };

}
