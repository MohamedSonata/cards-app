import 'package:cardsapp/app_screens/app_register/cubit/states.dart';
import 'package:cardsapp/models/app_create_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




class AppRegisterCubit extends Cubit<AppRegisterStates> {
  AppRegisterCubit() : super(AppRegisterinitialstate());

  static AppRegisterCubit get(context) => BlocProvider.of(context);


  void userRegister({
  required String userName,
  required String email,
  required String password,
  required String phoneNumber,
  required String branch,
  required String relatedBranchID,
  required bool isAdmin,
  required bool isQuit,

  }) {
    emit(AppRegisterLoadingstate());
FirebaseAuth.instance
    .createUserWithEmailAndPassword(
    email: email,
    password: password)
    .then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      userCreate(
          userName: userName,
          email: email,
          password: password,
          phoneNumber: phoneNumber,
          branch: branch,
          relatedBranchID: relatedBranchID,
          uId: value.user!.uid,
          isAdmin: isAdmin,
          isQuit: isQuit
      );


})
    .catchError((error){
      print(error.toString());
      emit(AppRegisterErorrstate(error.toString()));

});
    
  }

  void userCreate({
  required String userName,
  required String email,
  required String password,
  required String phoneNumber,
  required String branch,
  required String relatedBranchID,
  required String uId,
  required bool isAdmin,
  required bool isQuit,

  })
  {
    AppUserCreateModel model = AppUserCreateModel(
      userName: userName,
      email:email,
      phoneNumber: phoneNumber,
      password: password,
      image: 'https://image.freepik.com/free-vector/man-shows-gesture-great-idea_10045-637.jpg',
     isAdmin: isAdmin,
     branch: branch,
      isQuit: isQuit,
      relatedBranchID:relatedBranchID ,
      uId: uId,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
          emit(AppCreateUserSuccessState());
    }).catchError((error){
      print(error.toString());
emit(AppCreateUserErorrstate(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(AppRegisterChangePasswordVisibilityState());
  }
}
