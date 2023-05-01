




import 'package:cardsapp/app_screens/internet_error_widget/internet_error_widget.dart';
import 'package:cardsapp/layout/cubit/states.dart';
import 'package:cardsapp/login_screen/social_login_screen.dart';
import 'package:cardsapp/shared/app_colors/app_colors.dart';
import 'package:cardsapp/shared/components/reuseable_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/cubit.dart';
import '../../shared/app_colors/app_colors_dark.dart';

class AppRegisterScreen extends StatelessWidget {
  AppRegisterScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create:(context) => AppCubit()..getBranchesData()..checkInternet(),
      child: BlocConsumer<AppCubit, AppCubitStates>(
        listener: (context, state) {

          if (state is AppCreateUserSuccessState) {
            Navigator.pop(context);
            showToast(
                runiCode: '\u{1F642}',
                text: '  تم انشاء الحساب بنجاح ',
                state: ToastStates.Success);
            AppCubit.get(context).selectedBranchUID = null;

          }

        },
        builder: (context, state) {
          return AppCubit.get(context).internetTesting  == true ? StreamBuilder(
            stream: Stream.periodic(Duration(seconds: 2)).asyncMap((event) => AppCubit.get(context)..checkInternet()),
            builder: (context, snapshot) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                    textScaleFactor: .85
                ),
                child: Scaffold(
                  backgroundColor: AppDarkModeColors.kBackGroundColor,
                  appBar: AppBar(
                    iconTheme: IconThemeData(
                      color: AppDarkModeColors.kWhiteColor
                    ),
                    backgroundColor: AppDarkModeColors.kBackGroundColor,
                    centerTitle: true,
                    title: Text('Create Account',style: TextStyle(color: AppDarkModeColors.kWhiteColor,fontWeight: FontWeight.w600),),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: AppDarkModeColors.kBackGroundColor,
                                    borderRadius: BorderRadius.circular(200),
                                    boxShadow: [
                                      BoxShadow(

                                        color: Colors.grey.withOpacity(0.7),
                                        offset: Offset(-2.5, -2.5),
                                        blurRadius: 2,
                                        spreadRadius: 0.0,
                                      ),
                                      BoxShadow(
                                        color: AppDarkModeColors.kBlackColor.withOpacity(0.9),
                                        offset: Offset(2.5,2.5 ),
                                        blurRadius: 4,
                                        spreadRadius: 0.0,
                                      ),
                                    ]
                                ),
                                child: Image(
                                  fit: BoxFit.cover,
                                  height: 250.0,
                                  width: 250.0,
                                  image: AssetImage('assets/images/main_app_logo.png'),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Lets Get Started!',
                                style: TextStyle(
                                    fontFamily: 'assets/Fonts/Farro-Regular.ttf',
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: AppDarkModeColors.kWhiteColor
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                'انشاء مستحدم جديد واضافته للفرع',
                                style: TextStyle(
                                    fontFamily: 'assets/Fonts/Farro-Regular.ttf',
                                    fontSize: 14.0,
                                    color: AppDarkModeColors.kWhiteColor.withOpacity(0.7)),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              warningTextBuilder('اسم الشخص',context),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(55.0),
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  controller: nameController,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Please enter your Name";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    // labelText: 'Your Name',
                                    hintText: 'اسم الشخص',
                                    hintStyle: TextStyle(
                                        color: Colors.grey[300],
                                        fontWeight: FontWeight.bold),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: AppDarkModeColors.kWidgetsBackGroundColor,
                                    ),
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(55.0),
                                      borderSide: BorderSide(
                                        color: AppDarkModeColors.kBlueColorShade300,
                                      ),),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 10.0,
                              ),
                              warningTextBuilder('البريد الالكتروني',context),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(55.0),
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  controller: emailController,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Please enter your Email address";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    // labelText: 'Email Address',
                                    hintText: 'البريد الالكتروني',
                                    hoverColor: Colors.white,
                                    // fillColor: Colors.white,
                                    // focusColor: Colors.white,
                                    hintStyle: TextStyle(
                                        color: Colors.grey[300],
                                        fontWeight: FontWeight.bold),
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: AppDarkModeColors.kWidgetsBackGroundColor,
                                    ),
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(55.0),
                                      borderSide: BorderSide(
                                        color: AppDarkModeColors.kBlueColorShade300,
                                      ),),),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              warningTextBuilder('رقم الهاتف',context),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(55.0),
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  controller: phoneController,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Please enter your Phone Number";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    // labelText: 'Phone Number',
                                    hintText: 'رقم الهاتف',

                                    // fillColor: Colors.white,
                                    // focusColor: Colors.white,
                                    hintStyle: TextStyle(
                                        color: Colors.grey[300],
                                        fontWeight: FontWeight.bold),
                                    prefixIcon: Icon(
                                      Icons.phone_android,
                                      color: AppDarkModeColors.kWidgetsBackGroundColor,
                                    ),
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(55.0),
                                      borderSide: BorderSide(
                                        color: AppDarkModeColors.kBlueColorShade300,
                                      ),),),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              warningTextBuilder('كلمة السر',context),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(55.0),
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  controller: passwordController,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Please enter your Password";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    // labelText: 'Password',
                                    hintText: 'كلمة السر',
                                    hoverColor: Colors.white,
                                    // fillColor: Colors.white,
                                    // focusColor: Colors.white,
                                    hintStyle: TextStyle(
                                        color: Colors.grey[300],
                                        fontWeight: FontWeight.bold),
                                    prefixIcon: Icon(
                                      Icons.lock_open,
                                      color: AppDarkModeColors.kWidgetsBackGroundColor,
                                    ),
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(55.0),
                                      borderSide: BorderSide(
                                        color: AppDarkModeColors.kBlueColorShade300,
                                      ),),),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              // Container(
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(55.0),
                              //     color: Colors.white,
                              //   ),
                              //   child: TextFormField(
                              //     validator: (String value) {
                              //       if (value.isEmpty) {
                              //         return "Please enter your Password Again";
                              //       } else {
                              //         return null;
                              //       }
                              //     },
                              //     decoration: InputDecoration(
                              //         labelText: 'Confirm Password',
                              //         hintText: 'Confirm Password',
                              //         hoverColor: Colors.white,
                              //         // fillColor: Colors.white,
                              //         // focusColor: Colors.white,
                              //         hintStyle: TextStyle(
                              //             color: Colors.grey,
                              //             fontWeight: FontWeight.bold),
                              //         prefixIcon: Icon(
                              //           Icons.lock_open,
                              //           color: Colors.blue,
                              //         ),
                              //         border: InputBorder.none,
                              //         focusedBorder: OutlineInputBorder(
                              //           borderRadius: BorderRadius.circular(55.0),
                              //           borderSide: BorderSide(
                              //             color: Colors.blue,
                              //           ),
                              //         )),
                              //   ),
                              // ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'الفرع',
                                    style: TextStyle(
                                        color: AppDarkModeColors.kWhiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  DropdownButton(
                                    dropdownColor: AppDarkModeColors.kWidgetsBackGroundColor,



                                    borderRadius: BorderRadius.circular(12),

                                    hint:  Text(
                                      '    إختر الفرع',
                                      style: TextStyle(color: AppDarkModeColors.kWhiteColor,fontWeight: FontWeight.bold),
                                    ),
                                    items: AppCubit.get(context)
                                        .branchesModelList
                                        .map((e) => DropdownMenuItem(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          e.branchName!,
                                          style:  TextStyle(
                                              color: AppDarkModeColors.kWhiteColor),
                                        ),
                                      ),
                                      value: e.branchUID.toString(),
                                    ))
                                        .toList(),
                                    onChanged: (value) {
                                      AppCubit.get(context)
                                          .changeSelectedBranchUIDState(
                                          value as String);
                                      AppCubit.get(context).getSingleBranchData(
                                          singleBranchUID: value);
                                      print(
                                          AppCubit.get(context).selectedBranchUID);
                                    },
                                    value: AppCubit.get(context).selectedBranchUID,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),

                              ConditionalBuilder(
                                condition: state is! AppRegisterLoadingState,
                                builder: (context) => Container(
                                  width: 200.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.blue,
                                  ),
                                  child: MaterialButton(
                                    onPressed: () {
                                      // AppCubit.get(context).branchesModelList.contains(AppCubit.get(context).selectedBranchUID);
                                      // FirebaseAuth.instance..currentUser?.updatePassword('123456');
                                      if (formKey.currentState!.validate()) {
                                        if(AppCubit.get(context).selectedBranchUID !=null){
                                          AppCubit.get(context).userRegister(
                                            userName: nameController.text,
                                            email: emailController.text,
                                            password: passwordController.text,
                                            phoneNumber: phoneController.text,
                                            branch: AppCubit.get(context)
                                                .singleBranchModel!
                                                .branchName!,
                                            isAdmin: false,
                                            isQuit: false,
                                            relatedBranchID: AppCubit.get(context)
                                                .selectedBranchUID!,
                                          );
                                        }else{
                                          showToast(text: 'الرجاء اختيار الفرع أولا', state: ToastStates.ERROR,runiCode: '\u{1F3EC}');
                                        }

                                      }
                                    },
                                    child:const Text(
                                      'إنشاء حساب الأن',
                                      style: TextStyle(
                                          fontFamily: 'Fonts/Oswald-Bold.ttf',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.2),
                                    ),
                                  ),
                                ),
                                fallback: (context) =>
                                    Center(child: CircularProgressIndicator()),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          ) : StreamBuilder(
            stream: Stream.periodic(Duration(seconds: 2)).asyncMap((event) => AppCubit.get(context)..checkInternet()),
            builder: (context, snapshot) {
              return InternetErrorWidget();
            }
          );
        },
      ),
    );
  }
  Widget warningTextBuilder(String textContent,context)=>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text.rich(
              textDirection: TextDirection.rtl,
                TextSpan(
                    children:[
                      TextSpan(text: textContent,
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color:AppDarkModeColors.kWhiteColor)),
                      TextSpan(text:'' ,
                          style: TextStyle(
                              fontSize: 18.0,
                              color:  Theme.of(context).textTheme.bodyText1?.color,
                              fontWeight: FontWeight.bold)
                      ),
                    ]
                )
            ),
          ],
        ),
      );
}
