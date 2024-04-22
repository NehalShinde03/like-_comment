import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegistrationState extends Equatable {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  final GlobalKey<FormState> formKey;

  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isPasswordNConfirmPasswordSame;

  final String passwordValidationMessage;
  final Color color;


  const RegistrationState(
      {required this.nameController,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController,
      required this.formKey,
      this.isPasswordVisible= false,
      this.isConfirmPasswordVisible= false,
      this.isPasswordNConfirmPasswordSame = false,
      this.passwordValidationMessage = "",
      this.color = Colors.white
      });

  @override
  List<Object?> get props => [
        nameController,
        emailController,
        passwordController,
        confirmPasswordController,
        formKey,
        isPasswordVisible,
        isConfirmPasswordVisible,
        isPasswordNConfirmPasswordSame,
        passwordValidationMessage,
        color
      ];

  RegistrationState copyWith(
      {
        TextEditingController? nameController,
        TextEditingController? emailController,
        TextEditingController? passwordController,
        TextEditingController? confirmPasswordController,
        GlobalKey<FormState>? formKey,
        bool? isPasswordVisible,
        bool? isConfirmPasswordVisible,
        bool? isPasswordNConfirmPasswordSame,
        String? passwordValidationMessage,
        Color? color
      }) {
    return RegistrationState(
        nameController: nameController ?? this.nameController,
        emailController: emailController ?? this.emailController,
        passwordController: passwordController ?? this.passwordController,
        confirmPasswordController:
            confirmPasswordController ?? this.confirmPasswordController,
        formKey: formKey ?? this.formKey,
        isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
        isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
        isPasswordNConfirmPasswordSame: isPasswordNConfirmPasswordSame ?? this.isPasswordNConfirmPasswordSame,
        passwordValidationMessage: passwordValidationMessage ?? this.passwordValidationMessage,
        color: color ?? this.color
    );
  }
}
