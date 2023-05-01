import 'package:cardsapp/app_screens/internet_error_widget/internet_error_widget.dart';
import 'package:cardsapp/layout/app_layout.dart';
import 'package:cardsapp/layout/cubit/cubit.dart';
import 'package:cardsapp/layout/cubit/states.dart';
import 'package:cardsapp/shared/app_colors/app_colors_dark.dart';
import 'package:cardsapp/shared/components/reuseable_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/app_colors/app_colors.dart';

class UserDataScreen extends StatelessWidget {
    UserDataScreen({Key? key,required this.userUID}) : super(key: key);
   final String userUID;
    final userNameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final phoneNumberController = TextEditingController();
    final isAdminController = TextEditingController();
    final isQuitController = TextEditingController();
    final  branchController = TextEditingController();
    final  relatedBranchController = TextEditingController();
    String? userImageLink;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(

      value: BlocProvider.of<AppCubit>(context)..getSingleUserData(userID: userUID),
      child: BlocConsumer<AppCubit,AppCubitStates>(
        listener: (context,state){},
        builder: (context,state){

          if(state is AppGetSingleUserDataSuccessState){
            if(state.userDataModel.isQuit! == true ){
              isQuitController.text = 'تم استقالة الشخص';
            }else if(state.userDataModel.isQuit! == false){
              isQuitController.text = 'مازال بالدوام';
            }else{
              isQuitController.text = '';
            }
            userNameController.text =state.userDataModel.userName!;
             userImageLink =state.userDataModel.image! ;
                emailController.text =state.userDataModel.email!;
                passwordController.text =state.userDataModel.password!;
                phoneNumberController.text =state.userDataModel.phoneNumber!;
                isAdminController.text =state.userDataModel.isAdmin!.toString();

                // isQuitController.text =state.userDataModel.isQuit!.toString();
                branchController.text =state.userDataModel.branch!;
                relatedBranchController.text =state.userDataModel.relatedBranchID!;
          }


          return AppCubit.get(context).internetTesting ? StreamBuilder(
            stream: Stream.periodic(Duration(seconds: 3)).asyncMap((event) => AppCubit.get(context)..checkInternet()),
            builder: (context, snapshot) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                    textScaleFactor: .80
                ),
                child: Scaffold(
                  backgroundColor: AppDarkModeColors.kBackGroundColor,
                  appBar: AppBar(
                    iconTheme: IconThemeData(
                      color: AppDarkModeColors.kWhiteColor
                    ),
                    backgroundColor: AppDarkModeColors.kBackGroundColor,
                    leading: IconButton(onPressed: (){
                     Navigator.pop(context);


                    },icon: Icon(Icons.arrow_back),),
                    actions: [
                      CircleAvatar(
                      radius: 22,
                      foregroundImage:NetworkImage('${userImageLink!}'

                      ),
                      ),
                      SizedBox(
                        width: 35,
                      )
                    ],



                    title: Text('${AppCubit.get(context).singleUserDataModel?.userName}',style: TextStyle(color: Colors.white.withOpacity(0.8),fontWeight: FontWeight.bold),),
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          warningTextBuilder('الاسم',context),
                          const SizedBox(height: 10,),
                          /// User Name Widget
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.only(
                                  topRight: const Radius.circular(20),
                                  bottomRight: const Radius.circular(20),
                                  bottomLeft: Radius.circular(20)
                              ),
                            ),

                            height: 40,
                            child: TextFormField(
                              readOnly: false,
                              keyboardType: TextInputType.text,
                              // AppLoginCubit.get(context).isPassword,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter UserName';
                                } else if (value.length < 6) {
                                  return 'USER NAME Too Short';
                                }
                                return null;
                              },
                              controller: userNameController,
                              decoration:  InputDecoration(
                                  focusColor: AppColors.kButtonColor,
                                  // labelText: 'User Name',
                                  hintText: 'Enter Your Nick Name',
                                  hintStyle:  const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                  prefixIcon:  Icon(
                                    Icons.textsms_outlined,
                                    color:AppDarkModeColors.kWidgetsBackGroundColor,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: const Radius.circular(20),
                                        bottomRight: const Radius.circular(20),
                                        bottomLeft: Radius.circular(20)
                                    ),
                                    borderSide:  const BorderSide(
                                      color: Colors.red,
                                    ),
                                  )),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          warningTextBuilder('البريد الالكتروني',context),
                          const SizedBox(height: 10,),
                          /// User Name Widget
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.only(
                                  topRight: const Radius.circular(20),
                                  bottomRight: const Radius.circular(20),
                                  bottomLeft: Radius.circular(20)
                              ),
                            ),

                            height: 40,
                            child: TextFormField(
                              readOnly: false,
                              keyboardType: TextInputType.text,
                              // AppLoginCubit.get(context).isPassword,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter UserName';
                                } else if (value.length < 6) {
                                  return 'USER NAME Too Short';
                                }
                                return null;
                              },
                              controller: emailController,
                              decoration:  InputDecoration(
                                  focusColor:AppDarkModeColors.kWidgetsBackGroundColor,
                                  // labelText: 'Email',
                                  hintText: 'Enter Your Email',
                                  hintStyle:  const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                  prefixIcon:  Icon(
                                    Icons.textsms_outlined,
                                    color:AppDarkModeColors.kWidgetsBackGroundColor,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: const Radius.circular(20),
                                        bottomRight: const Radius.circular(20),
                                        bottomLeft: Radius.circular(20)
                                    ),
                                    borderSide:  const BorderSide(
                                      color: Colors.red,
                                    ),
                                  )),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          warningTextBuilder('رقم الهاتف',context),
                          const SizedBox(height: 10,),
                          /// User Name Widget
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.only(
                                  topRight: const Radius.circular(20),
                                  bottomRight: const Radius.circular(20),
                                  bottomLeft: Radius.circular(20)
                              ),
                            ),

                            height: 40,
                            child: TextFormField(
                              readOnly: false,
                              keyboardType: TextInputType.text,
                              // AppLoginCubit.get(context).isPassword,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter PhoneNumber';
                                } else if (value.length < 6) {
                                  return 'USER NAME Too Short';
                                }
                                return null;
                              },
                              controller: phoneNumberController,
                              decoration:  InputDecoration(
                                  focusColor:AppDarkModeColors.kWidgetsBackGroundColor,
                                  // labelText: 'Phone Number',
                                  hintText: 'Enter Your PhoneNumber',
                                  hintStyle:  const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                  prefixIcon:  Icon(
                                    Icons.textsms_outlined,
                                    color:AppDarkModeColors.kWidgetsBackGroundColor,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: const Radius.circular(20),
                                        bottomRight: const Radius.circular(20),
                                        bottomLeft: Radius.circular(20)
                                    ),
                                    borderSide:  const BorderSide(
                                      color: Colors.red,
                                    ),
                                  )),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          warningTextBuilder('كلمة السر',context),
                          const SizedBox(height: 10,),
                          /// User Name Widget
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.only(
                                  topRight: const Radius.circular(20),
                                  bottomRight: const Radius.circular(20),
                                  bottomLeft: Radius.circular(20)
                              ),
                            ),

                            height: 40,
                            child: TextFormField(
                              readOnly: false,
                              keyboardType: TextInputType.text,
                              // AppLoginCubit.get(context).isPassword,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Password';
                                } else if (value.length < 6) {
                                  return 'Password Too Short';
                                }
                                return null;
                              },
                              controller: passwordController,
                              decoration:  InputDecoration(
                                  focusColor:AppDarkModeColors.kWidgetsBackGroundColor,
                                  // labelText: 'Password',
                                  hintText: 'Enter Your Password',
                                  hintStyle:  const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                  prefixIcon:  Icon(
                                    Icons.textsms_outlined,
                                    color:AppDarkModeColors.kWidgetsBackGroundColor,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: const Radius.circular(20),
                                        bottomRight: const Radius.circular(20),
                                        bottomLeft: Radius.circular(20)
                                    ),
                                    borderSide:  const BorderSide(
                                      color: Colors.red,
                                    ),
                                  )),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          warningTextBuilder('استقال/ مازال بالدوام',context),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              warningTextBuilder('حالة الاستقالة',context),
                              const SizedBox(width: 20,),
                              DropdownButton(
                                style: TextStyle(color: Colors.white),





                                dropdownColor: AppDarkModeColors.kWidgetsBackGroundColor,
                                iconEnabledColor: Colors.white,


                                hint: const Text('Choose Type',style: TextStyle(color: Colors.white),),
                                items: [true,false].map((e) =>
                                    DropdownMenuItem(

                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                        child: Text(e.toString(),textAlign:TextAlign.center , style:
                                        const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w700),),
                                      ),
                                      value: e,)).toList(),
                                onChanged: ( value){
                                  AppCubit.get(context).changeUserIsQuitTypeState(value as bool );
                                  print(AppCubit.get(context).selectedValue);
                                },
                                value: AppCubit.get(context).selectedValue,
                              ),
                              Spacer(),
                              if(
                              AppCubit.get(context).selectedValue !=null)
                              CircleAvatar(
                                backgroundColor: AppDarkModeColors.kGreenColorShade100,
                                child: IconButton(onPressed: (){
                                  AppCubit.get(context).updateUserData(isQuitValue:AppCubit.get(context).selectedValue!,userId: userUID );
                                  AppCubit.get(context).selectedValue = null;

                                }, icon: Icon(Icons.check,color: Colors.white,)),
                              ),
                            ],
                          ),


                          warningTextBuilder('حالة الاستقالة',context),
                          const SizedBox(height: 10,),
                          /// User Name Widget
                          StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance.collection('users').doc(userUID).snapshots(),
                            builder: (context,snapShots){
                              if(snapShots.hasData){
                                if(snapShots.data!['isQuit'] == true){
                                  isQuitController.text = 'تم استقالة الشخص';
                                }else if(snapShots.data!['isQuit'] == false){
                                  isQuitController.text = 'مازال بالدوام';
                                }else{}
                                // isQuitController.text = snapShots.data!['isQuit'].toString();
                                return Container(
                                  decoration:  BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)
                                    ),
                                  ),

                                  height: 40,
                                  child: TextFormField(
                                    readOnly: false,
                                    keyboardType: TextInputType.text,
                                    // AppLoginCubit.get(context).isPassword,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Please Enter isQuit Value';
                                      } else if (value.length < 6) {
                                        return 'isQuit Value Must Be True Or False';
                                      }
                                      return null;
                                    },
                                    controller: isQuitController,
                                    decoration:  InputDecoration(
                                        focusColor:AppDarkModeColors.kWidgetsBackGroundColor,
                                        // labelText: 'isQuit',
                                        hintText: 'isQuit Value',
                                        hintStyle:  const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                        prefixIcon:  Icon(
                                          Icons.textsms_outlined,
                                          color:AppDarkModeColors.kWidgetsBackGroundColor,
                                        ),
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                              topRight: const Radius.circular(20),
                                              bottomRight: const Radius.circular(20),
                                              bottomLeft: Radius.circular(20)
                                          ),
                                          borderSide:  const BorderSide(
                                            color: Colors.red,
                                          ),
                                        )),
                                  ),
                                );
                              }else{
                                return Container(
                                  decoration:  BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)
                                    ),
                                  ),

                                  height: 40,
                                  child: TextFormField(
                                    readOnly: false,
                                    keyboardType: TextInputType.text,
                                    // AppLoginCubit.get(context).isPassword,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Please Enter isQuit Value';
                                      } else if (value.length < 6) {
                                        return 'isQuit Value Must Be True Or False';
                                      }
                                      return null;
                                    },
                                    controller: isQuitController,
                                    decoration:  InputDecoration(
                                        focusColor:AppDarkModeColors.kWidgetsBackGroundColor,
                                        // labelText: 'isQuit',
                                        hintText: 'isQuit Value',
                                        hintStyle:  const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                        prefixIcon:  Icon(
                                          Icons.textsms_outlined,
                                          color:AppDarkModeColors.kWidgetsBackGroundColor,
                                        ),
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                              topRight: const Radius.circular(20),
                                              bottomRight: const Radius.circular(20),
                                              bottomLeft: Radius.circular(20)
                                          ),
                                          borderSide:  const BorderSide(
                                            color: Colors.red,
                                          ),
                                        )),
                                  ),
                                );
                              }
                            },

                          ),
                          const SizedBox(height: 10,),
                          // warningTextBuilder('RelatedBranch',context),
                          // const SizedBox(height: 10,),
                          // /// User Name Widget
                          // Container(
                          //   decoration:  BoxDecoration(
                          //     color: Colors.white.withOpacity(0.8),
                          //     borderRadius: BorderRadius.only(
                          //         topRight: Radius.circular(20),
                          //         bottomRight: Radius.circular(20),
                          //         bottomLeft: Radius.circular(20)
                          //     ),
                          //   ),
                          //
                          //   height: 40,
                          //   child: TextFormField(
                          //     readOnly: false,
                          //     keyboardType: TextInputType.text,
                          //     // AppLoginCubit.get(context).isPassword,
                          //     validator: (String? value) {
                          //       if (value!.isEmpty) {
                          //         return 'Please Choose RelatedBranch';
                          //       } else if (value.length < 6) {
                          //         return 'User Must be Related To Branch';
                          //       }
                          //       return null;
                          //     },
                          //     controller: relatedBranchController,
                          //     decoration:  InputDecoration(
                          //         focusColor:AppDarkModeColors.kWidgetsBackGroundColor,
                          //         // labelText: 'RelatedBranch',
                          //         hintText: 'Choose One Branches',
                          //         hintStyle:  const TextStyle(
                          //             color: Colors.grey,
                          //             fontWeight: FontWeight.bold),
                          //         prefixIcon:  Icon(
                          //           Icons.textsms_outlined,
                          //           color:AppDarkModeColors.kWidgetsBackGroundColor,
                          //         ),
                          //         border: const OutlineInputBorder(
                          //           borderRadius: BorderRadius.only(
                          //               topRight: const Radius.circular(20),
                          //               bottomRight: const Radius.circular(20),
                          //               bottomLeft: Radius.circular(20)
                          //           ),
                          //           borderSide:  const BorderSide(
                          //             color: Colors.red,
                          //           ),
                          //         )),
                          //   ),
                          // ),
                          const SizedBox(height: 10,),
                          warningTextBuilder('الفرع',context),
                          const SizedBox(height: 10,),
                          /// User Name Widget
                          Container(
                            decoration:  BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)
                              ),
                            ),

                            height: 40,
                            child: TextFormField(
                              readOnly: false,
                              keyboardType: TextInputType.text,
                              // AppLoginCubit.get(context).isPassword,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Branch Name';
                                } else if (value.length < 6) {
                                  return 'Branch Too Short must be less than 6 Letters';
                                }
                                return null;
                              },
                              controller: branchController,
                              decoration:  InputDecoration(
                                  focusColor:AppDarkModeColors.kWidgetsBackGroundColor,
                                  // labelText: 'Branch Name',
                                  hintText: 'Enter Your Branch Name',
                                  hintStyle:  const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                  prefixIcon:  Icon(
                                    Icons.textsms_outlined,
                                    color:AppDarkModeColors.kWidgetsBackGroundColor,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: const Radius.circular(20),
                                        bottomRight: const Radius.circular(20),
                                        bottomLeft: Radius.circular(20)
                                    ),
                                    borderSide:  const BorderSide(
                                      color: Colors.red,
                                    ),
                                  )),
                            ),
                          ),
                          // const SizedBox(height: 10,),
                          // warningTextBuilder('isAdmin',context),
                          // const SizedBox(height: 10,),
                          // /// User Name Widget
                          // Container(
                          //   decoration:  BoxDecoration(
                          //     color: Colors.white.withOpacity(0.8),
                          //     borderRadius: BorderRadius.only(
                          //         topRight: Radius.circular(20),
                          //         bottomRight: Radius.circular(20),
                          //         bottomLeft: Radius.circular(20)
                          //     ),
                          //   ),
                          //
                          //   height: 40,
                          //   child: TextFormField(
                          //     readOnly: false,
                          //     keyboardType: TextInputType.text,
                          //     // AppLoginCubit.get(context).isPassword,
                          //     validator: (String? value) {
                          //       if (value!.isEmpty) {
                          //         return 'Please Choose isAdmin Value';
                          //       } else if (value.length < 6) {
                          //         return 'isAdmin Value Must Be True Or False';
                          //       }
                          //       return null;
                          //     },
                          //     controller: isAdminController,
                          //     decoration:  InputDecoration(
                          //         focusColor:AppDarkModeColors.kWidgetsBackGroundColor,
                          //         // labelText: 'isAdmin Value',
                          //         hintText: 'Enter Your isAdmin Value',
                          //         hintStyle:  const TextStyle(
                          //             color: Colors.grey,
                          //             fontWeight: FontWeight.bold),
                          //         prefixIcon:  Icon(
                          //           Icons.textsms_outlined,
                          //           color:AppDarkModeColors.kWidgetsBackGroundColor,
                          //         ),
                          //         border: const OutlineInputBorder(
                          //           borderRadius: BorderRadius.only(
                          //               topRight: const Radius.circular(20),
                          //               bottomRight: const Radius.circular(20),
                          //               bottomLeft: Radius.circular(20)
                          //           ),
                          //           borderSide:  const BorderSide(
                          //             color: Colors.red,
                          //           ),
                          //         )),
                          //   ),
                          // ),
                          // const SizedBox(height: 10,),

                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          ) :StreamBuilder(
            stream: Stream.periodic(Duration(seconds: 3)).asyncMap((event) => AppCubit.get(context)..checkInternet()),
            builder: (context, snapshot) {
              return InternetErrorWidget();
            }
          );
        },


      ),
    );
  }
    Widget warningTextBuilder(String textContent,context)=>
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text.rich(
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
        );
}
