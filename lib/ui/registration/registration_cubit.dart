import 'package:comment_like/common/colors/common_colors.dart';
import 'package:comment_like/ui/registration/registration_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationCubit extends Cubit<RegistrationState>{
  RegistrationCubit(super.initialState);

  void isPasswordVisible({isPasswordVisible}){
    emit(state.copyWith(isPasswordVisible: isPasswordVisible));
  }

  void isConfirmPasswordVisible({isConfirmPasswordVisible}){
    emit(state.copyWith(isConfirmPasswordVisible: isConfirmPasswordVisible));
  }

  void isPasswordNConfirmPasswordSame({password, confirmPassword}){
    if(password.toString().isEmpty || confirmPassword.toString().isEmpty){
      emit(state.copyWith(passwordValidationMessage: "", color: CommonColor.white));
    }
    else if(password == confirmPassword) {
      emit(state.copyWith(passwordValidationMessage: "Password is Match", color: CommonColor.green, isPasswordNConfirmPasswordSame: true));
    }else{
      emit(state.copyWith(passwordValidationMessage: "Password Doesn't Match", color: CommonColor.red, isPasswordNConfirmPasswordSame: false));
    }
  }


}