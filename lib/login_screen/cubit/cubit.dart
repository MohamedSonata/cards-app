

import 'package:bloc/bloc.dart';
import 'package:cardsapp/layout/cubit/cubit.dart';
import 'package:cardsapp/login_screen/cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AppLoginCubit extends Cubit<AppLoginStates> {
  AppLoginCubit() : super(AppLogininitialstate());

  static AppLoginCubit get(context) => BlocProvider.of(context);
// SocialCreateUserModel model;
  BuildContext? context;
  void userLogin({
    required String email,
    required String password,
  }) {
    emit(AppLoginLoadingstate());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: email,
        password: password)
        .then((value)
    {
      // print(value.user.email);
      // print(value.user.uid);
      emit(AppLoginSuccessState(value.user!.uid,));
      // emit(AppLoginSuccessState(model, value.user.uid));

    })
        .catchError((error){

          emit(AppLoginErorrstate(error.toString()));
          print(error.toString());

    });
  }

  // void checkRole({context, String role ='user'})async{
  //
  //   User user = FirebaseAuth.instance.currentUser;
  //   DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  //   emit(AppCheckRoleState(role = snap['role']));
  //   role = snap['role'];
  //
  //   if (role == 'user'){
  //     navigateTo(context, ShopLayout());
  //
  //
  //   }else if (role == 'admin'){
  //     navigateAndFinish(context, AdminScreen());
  //   }
  //
  //
  // }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(AppLChangePasswordVisibilitystate());
  }
}
