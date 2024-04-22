import 'package:comment_like/common/spacing/common_spacing.dart';
import 'package:comment_like/common/widget/common_elevated_button.dart';
import 'package:comment_like/common/widget/common_text.dart';
import 'package:comment_like/common/widget/common_textfield.dart';
import 'package:comment_like/services/data_base_helper.dart';
import 'package:comment_like/model_class/registration_model.dart';
import 'package:comment_like/ui/login/login_view.dart';
import 'package:comment_like/ui/registration/registration_cubit.dart';
import 'package:comment_like/ui/registration/registration_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  static const String routeName = '/registration_view';

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RegistrationCubit(
              RegistrationState(
                nameController: TextEditingController(),
                emailController: TextEditingController(),
                passwordController: TextEditingController(),
                confirmPasswordController: TextEditingController(),
                formKey: GlobalKey(),
              )),
      child: const RegistrationView(),
    );
  }

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {

  RegistrationCubit get registrationCubit => context.read<RegistrationCubit>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: BlocBuilder<RegistrationCubit, RegistrationState>(
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                key: state.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Padding(
                      padding: PaddingValue.xLarge,
                      child: CommonText(
                        text: 'Sign up',
                        fontSize: Spacing.xxLarge,
                        fontWeight: TextWeight.bold,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: Spacing.large, vertical: Spacing.normal),
                      child: CommonTextField(
                        controller: state.nameController,
                        prefixIcon: Icons.person,
                        labelText: 'Enter Name',
                        validator: (val) => val!.isEmpty ? 'field required' : null,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: Spacing.large - 2, vertical: Spacing.normal),
                      child: CommonTextField(
                        controller: state.emailController,
                        prefixIcon: Icons.email,
                        labelText: 'Enter Email',
                        validator: (val) => val!.isEmpty ? 'field required' : null,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: Spacing.large - 2, vertical: Spacing.normal),
                      child: CommonTextField(
                        controller: state.passwordController,
                        prefixIcon: Icons.lock,
                        suffixIcon: state.isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                        labelText: 'Enter Password',
                        validator: (val) => val!.isEmpty ? 'field required' : null,
                        onTap: () => registrationCubit.isPasswordVisible(isPasswordVisible: !state.isPasswordVisible),
                        obscureText: !(state.isPasswordVisible),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: Spacing.large - 2, vertical: Spacing.normal),
                      child: CommonTextField(
                        controller: state.confirmPasswordController,
                        prefixIcon: Icons.lock,
                        suffixIcon: state.isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                        labelText: 'Enter Confirm Password',
                        validator: (val) => val!.isEmpty ? 'field required' : null,
                        onTap: () => registrationCubit.isConfirmPasswordVisible(isConfirmPasswordVisible: !state.isConfirmPasswordVisible),
                        obscureText: !(state.isConfirmPasswordVisible),
                        onChanged: (val){
                          registrationCubit.isPasswordNConfirmPasswordSame(
                              password: state.passwordController.text,
                              confirmPassword: state.confirmPasswordController.text
                          );
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: Spacing.xLarge),
                      child: CommonText(text: state.passwordValidationMessage, textColor: state.color,),
                    ),

                    const Gap(RadiusValue.xxLarge),
                    Center(
                      child: CommonElevatedButton(
                        buttonColor: Colors.teal,
                        text: 'Sign-up',
                        textColor: Colors.white,
                        onPressed: state.isPasswordNConfirmPasswordSame
                            ?() {
                               if (state.formKey.currentState!.validate()){
                                  DataBaseHelper.instance.insertNewUser(
                                    registrationModel: RegistrationModel(
                                      userName: state.nameController.text,
                                      userEmail: state.emailController.text,
                                      userPassword: state.passwordController.text,
                                      userConfirmPassword: state.confirmPasswordController.text)
                                    );
                                  Navigator.pushNamed(context, LoginView.routeName);
                               }
                              }
                            : null,
                      ),
                    ),

                    ///already account
                    const Gap(Spacing.xxxLarge * 1),
                    Center(
                      child: RichText(
                          text: TextSpan(
                            text: 'Already have an account?',
                            style: const TextStyle(
                                fontWeight: TextWeight.regular,
                                fontSize: TextSize.title,
                                color: Colors.grey
                            ),
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()..onTap=() => Navigator.pushNamed(context, LoginView.routeName),
                                text: '\tSign in',
                                style: const TextStyle(
                                    fontWeight: TextWeight.medium,
                                    fontSize: TextSize.title - 1,
                                    color: Colors.teal
                                ),
                              )
                            ]
                          )
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        );
      },
    ));
  }
}
