import 'package:cardsapp/app_screens/app_register/app_register_screen.dart';
import 'package:cardsapp/layout/cubit/cubit.dart';
import 'package:cardsapp/shared/app_colors/app_colors_dark.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/states.dart';
import '../../login_screen/social_login_screen.dart';
import '../../shared/app_colors/app_colors.dart';
import '../../shared/components/reuseable_components.dart';
import '../../shared/local/cache_helper.dart';
import '../new_card_screen/new_card_screen.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppCubitStates>(
      listener: (context, state) {
        if (state is AppCreateUserSuccessState) {
          showToast(
            runiCode: '\u{1F642}',
              text: '  تم انشاء الحساب بنجاح ',
              state: ToastStates.Success);
          AppCubit.get(context).registerForm = false;
        }
      },
      builder: (context, state) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
              textScaleFactor: .85
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(

              children: [
                Center(
                  child: Text(
                    '${AppCubit.get(context).userModel?.userName} مرحبا ',
                    style: TextStyle(
                        fontSize: 25,
                        color: AppDarkModeColors.kWhiteColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10,),
                // if(isAdmin== true)
                //   ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //           onPrimary: Colors.red
                //       ),
                //
                //       onPressed: (){
                //
                //         FirebaseAuth.instance.currentUser!.updatePassword('43948474');
                //
                //       }, child: Text('UpdatePassword')),
                Expanded(


                  child: SizedBox(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [

                          // if(isAdmin== true)
                          InkWell(
                            onTap: (){
                              navigateTo(context, AppRegisterScreen());
                            },
                            child: Container(
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color: AppDarkModeColors.kBackGroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(

                                      color: Colors.grey.withOpacity(0.7),
                                      offset: const Offset(-2.5, -2.5),
                                      blurRadius: 2,
                                      spreadRadius: 0.0,
                                    ),
                                    BoxShadow(
                                      color: AppDarkModeColors.kUnselectedTextColor.withOpacity(0.2),
                                      offset: const Offset(2.5,2.5 ),
                                      blurRadius: 6,
                                      spreadRadius: 0.0,
                                    ),
                                  ]
                              ),
                              child: ListTile(
                                leading:  Icon(Icons.person,color: AppDarkModeColors.kWhiteColor,),
                                title:  Text(
                                  'اضافة مستخدم جديد',
                                  style: TextStyle(fontWeight: FontWeight.w600,color:AppDarkModeColors.kWhiteColor ),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                  navigateTo(context, AppRegisterScreen());
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: AppDarkModeColors.kWhiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          if(isAdmin== true)
                            InkWell(
                              onTap: (){
                                navigateTo(context, AddNewCardScreen());
                              },
                              child: Container(
                                margin: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    color: AppDarkModeColors.kBackGroundColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(

                                        color: Colors.grey.withOpacity(0.7),
                                        offset: const Offset(-2.5, -2.5),
                                        blurRadius: 2,
                                        spreadRadius: 0.0,
                                      ),
                                      BoxShadow(
                                        color: AppDarkModeColors.kUnselectedTextColor.withOpacity(0.2),
                                        offset: const Offset(2.5,2.5 ),
                                        blurRadius: 6,
                                        spreadRadius: 0.0,
                                      ),
                                    ]
                                ),
                                child: ListTile(
                                  leading:  Icon(Icons.person,color: AppDarkModeColors.kWhiteColor,),
                                  title:  Text(
                                    'اضافة بطاقة جديدة',
                                    style: TextStyle(fontWeight: FontWeight.w600,color:AppDarkModeColors.kWhiteColor ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      navigateTo(context, AddNewCardScreen());
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      color: AppDarkModeColors.kWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),


                          if (!AppCubit.get(context).registerForm == true)
                            const SizedBox(height: 10,),

                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: AppDarkModeColors.kBlueColorShade200,
                              ),
                              onPressed: (){
                                AppCubit.get(context).signOut();
                                CacheHelper.clearData().then((value) {
                                  if(value){
                                    navigateAndFinish(context, AppLoginScreen());
                                  }
                                });
                              }, child: FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.logout_outlined),
                                Text('تسجيل الخروج',style: TextStyle(color: AppDarkModeColors.kWhiteColor,fontWeight: FontWeight.bold,fontSize: 20),),
                              ],
                            ),
                          )),

                          if (AppCubit.get(context).registerForm == true)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Form(
                                key: formKey,
                                child: Center(
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      ClipOval(
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundColor:
                                          AppColors.kWidgetsBackGroundColor,
                                          backgroundImage: const AssetImage(
                                            'assets/images/main_app_logo.png',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
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
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        'انشاء مستحدم جديد واضافته للفرع',
                                        style: TextStyle(
                                            fontFamily: 'assets/Fonts/Farro-Regular.ttf',
                                            fontSize: 14.0,
                                            color: AppDarkModeColors.kWhiteColor.withOpacity(0.7)),
                                      ),
                                      const SizedBox(
                                        height: 25.0,
                                      ),
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
                                            hintText: 'User Name',
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

                                      const SizedBox(
                                        height: 25.0,
                                      ),
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
                                            hintText: 'Your@mail.com',
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
                                      const SizedBox(
                                        height: 25.0,
                                      ),
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
                                            hintText: 'Phone Number',

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
                                      const SizedBox(
                                        height: 25.0,
                                      ),
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
                                            hintText: 'Password',
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
                                      const SizedBox(
                                        height: 25.0,
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
                                      const SizedBox(
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
                                      const SizedBox(height: 10,),

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
                                              if (formKey.currentState!.validate()) {
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
                                              }
                                            },
                                            child: const Text(
                                              'إنشاء حساب الأن',
                                              style: const TextStyle(
                                                  fontFamily: 'Fonts/Oswald-Bold.ttf',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.2),
                                            ),
                                          ),
                                        ),
                                        fallback: (context) =>
                                            const Center(child: const CircularProgressIndicator()),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(
                ),


                FittedBox(
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.bottomRight,
                        child:  FittedBox(
                          child: Text('Designed By Preduro Apps Co',
                            style: TextStyle(color: Colors.grey,fontSize: 15),),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.bottomRight,
                        child:  FittedBox(
                          child: Text('Copyrights Recieved \u{00A9} 2022',
                            style: TextStyle(color: Colors.grey),),
                        ),
                      ),
                      SizedBox(height: 3,),
                      InkWell(
                          onTap: (){
AppCubit.get(context).sendEmail(email: 'sonata.1993@yahoo.com');
                          },
                          child: FittedBox(
                            child: Row(
                              children: const[

                                 Text('Contact Us',style:  TextStyle(color: Colors.blueAccent,fontSize: 17),),
                                 SizedBox(width: 3,),
                                 Icon(Icons.mail,color: Colors.blueAccent,size: 15,),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),

                // ListTile(
                //   leading: const Icon(Icons.person),
                //   title: const Text('تحت',style: TextStyle( fontWeight: FontWeight.w600),),
                //   trailing: IconButton(
                //     onPressed: (){
                //       navigateTo(context,  AppRegisterScreen());
                //     },
                //     icon:  Icon(Icons.arrow_forward_ios_outlined,color: AppColors.kButtonColor,),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
