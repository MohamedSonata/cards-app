

import 'package:cardsapp/layout/app_layout.dart';
import 'package:cardsapp/layout/cubit/cubit.dart';
import 'package:cardsapp/login_screen/cubit/cubit.dart';
import 'package:cardsapp/login_screen/cubit/states.dart';
import 'package:cardsapp/shared/app_colors/app_colors_dark.dart';
import 'package:cardsapp/shared/components/reuseable_components.dart';
import 'package:cardsapp/shared/local/cache_helper.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/app_colors/app_colors.dart';

class AppLoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var pasworrdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppLoginCubit(),
      child: BlocConsumer< AppLoginCubit , AppLoginStates>(
        listener: (context , state){
var ttt;

          if (state is AppLoginSuccessState) {
            CacheHelper.saveData(
                key: 'uId',
                value: state.uId)
                .then((value) {
              uId = CacheHelper.getData(key: 'uId');
                  if(value){

                    navigateAndFinish(context,  AppLayout(),);
                  }

              showToast(text: 'تم تسجيل الدخول بنجاح', state: ToastStates.Success);
            });
          }
          if (state is AppLoginSuccessState) {
          AppCubit.get(context).enableDisableApp();
          }



          if (state is AppLoginErorrstate) {
            showToast(text: 'عفوا يرجى التأكد من اسم الحساب أو كلمة السر',state: ToastStates.ERROR);

          // if (state is AppLoginErorrstate)
          // {
          //
          //   showToast(text:state.error, state: ToastStates.ERROR );
          //
          // }



        }


          },

        builder: (context , state){
          return  MediaQuery(
            data: MediaQuery.of(context).copyWith(
                textScaleFactor: .85
            ),
            child: Scaffold(
              backgroundColor: AppDarkModeColors.kBackGroundColor,
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Form(
                        key: formKey,
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20.0,
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
                                height: 10.0,
                              ),
                              Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: AppDarkModeColors.kWhiteColor,
                                    fontFamily: 'Farro'),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                'سجل الدخول الأن حتى تتمكن من التحكم في البطاقات',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontFamily: 'Farro'),
                              ),
                              SizedBox(height: 20.0,),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(55.0),
                                  color: Colors.white,),

                                child: TextFormField(
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Please enter your Email address";
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: emailController,
                                  decoration: InputDecoration(
                                      // labelText: 'Email Address',
                                      hintText: 'Your@Mail.com',
                                      hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                      prefixIcon:  Icon(
                                        Icons.account_circle,

                                      ),
                                      border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(55.0),
                                        borderSide: BorderSide(
                                          color: AppDarkModeColors.kBlueColorShade300,
                                        ),
                                      )
                                  ),
                                ),
                              ),
                              SizedBox(height: 15,),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(55.0),
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  onFieldSubmitted: (value){
                                    if (formKey.currentState!.validate()) {
                                      AppLoginCubit.get(context).userLogin(
                                        email: emailController.text,
                                        password: pasworrdController.text,
                                      );
                                    }
                                  },
                                  obscureText: AppLoginCubit.get(context).isPassword,

                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Please Enter Your Password';
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: pasworrdController,
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                          onPressed:(){
                                            AppLoginCubit.get(context).changePasswordVisibility();
                                          },
                                          icon: Icon(AppLoginCubit.get(context).suffix)),
                                      // labelText: 'Password',
                                      // labelStyle: TextStyle(color: Colors.grey,fontSize: 20),
                                      hintText: 'Password',
                                      hoverColor: Colors.white,
                                      // fillColor: Colors.white,
                                      // focusColor: Colors.white,
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                      prefixIcon: Icon(
                                        Icons.lock_open,
                                        color: Colors.blue,
                                      ),
                                      border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(55.0),
                                        borderSide: BorderSide(
                                          color: AppDarkModeColors.kBlueColorShade300,
                                        ),
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.end,
                              //   children: [
                              //     TextButton(
                              //         onPressed: () {},
                              //         child: Text('Forgot Password?'))
                              //   ],
                              // ),
                              SizedBox(
                                height: 10.0,
                              ),
                              ConditionalBuilder(
                                condition: state is !AppLoginLoadingstate,
                                builder: (context) => Container(
                                  width: 200.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: AppDarkModeColors.kBlueColorShade100,
                                  ),
                                  child:  MaterialButton(
                                    onPressed: ()async {
                                      if (formKey.currentState!.validate()) {
                                        AppLoginCubit.get(context).userLogin(
                                          email: emailController.text,
                                          password: pasworrdController.text,
                                        );
                                      }


                                    },
                                    child: Text(
                                      'الدخول الأن',
                                      style: TextStyle(
                                          fontFamily: 'Fonts/Oswald-Bold.ttf',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.2),
                                    ),
                                  ),

                                ),
                                fallback: (context) => Center(child: CircularProgressIndicator.adaptive()),
                              ),




                            ],
                          ),
                        )),
                  ),
                )
            ),
          );
        },

      ),


    );
  }
}
