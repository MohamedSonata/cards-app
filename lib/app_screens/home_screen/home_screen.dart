import 'package:cardsapp/app_screens/new_card_screen/new_card_screen.dart';
import 'package:cardsapp/layout/cubit/cubit.dart';
import 'package:cardsapp/layout/cubit/states.dart';
import 'package:cardsapp/login_screen/social_login_screen.dart';
import 'package:cardsapp/shared/app_colors/app_colors.dart';
import 'package:cardsapp/shared/app_colors/app_colors_dark.dart';
import 'package:cardsapp/shared/components/reuseable_components.dart';
import 'package:cardsapp/shared/local/cache_helper.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppCubitStates>(
      listener: (context,state){
        if(state is AppAddNewCardSuccessState){
          showToast(text: 'تم أضافة البطاقة بنجاح', state: ToastStates.Success);
        }
      },
      builder: (context,state){
        return
           MediaQuery(
             data: MediaQuery.of(context).copyWith(
                 textScaleFactor: .85
             ),
             child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,

                children: [
              Column(
                children: [
                  if(isAdmin == true)
                    Container(

                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColors.kWarningColor,
                          borderRadius: BorderRadius.circular(16)
                      ),
                      child: const Center(child: Text('مرحبا بك في لوحة التحكم',style: TextStyle(color: Colors.black,fontSize: 25),)),
                    ),
                  if(isAdmin == false)
                    Container(
                      padding: const EdgeInsets.all(8),

                      decoration: BoxDecoration(
                          color: AppColors.kWarningColor,
                          borderRadius: BorderRadius.circular(16)
                      ),
                      child: Center(child: Text(' مرحبا: ${AppCubit.get(context).userModel?.userName}',
                        style: const TextStyle(color: Colors.black,fontSize: 23,fontWeight: FontWeight.bold),)),
                    ),
                  SizedBox(height: 50,),

                  if(isAdmin == false)
                    Center(
                      child: ElevatedButton(
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
                          children: [
                            const Icon(Icons.logout_outlined),
                            Text('تسجيل الخروج',style: TextStyle(color: AppDarkModeColors.kWhiteColor,fontWeight: FontWeight.bold,fontSize: 20),),
                          ],
                        ),
                      )),
                    ),
                  const SizedBox(
                    height: 10,
                  ),

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
                              offset: Offset(-2.5, -2.5),
                              blurRadius: 2,
                              spreadRadius: 0.0,
                            ),
                            BoxShadow(
                              color: AppDarkModeColors.kUnselectedTextColor.withOpacity(0.2),
                              offset: Offset(2.5,2.5 ),
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

                  // myDivider(),

                ],
              ),
                  const Spacer(),
                  if(isAdmin == false)

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






                  // Row(
                  //   children: [
                  //     Text('الفرع',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
                  //     const SizedBox(width: 20,),
                  //     // DropdownButton(
                  //     //   hint: const Text('Choose Branch',style: TextStyle(color: Colors.redAccent),),
                  //     //   items: AppCubit.get(context).branchesModelList.map((e) =>
                  //     //       DropdownMenuItem(
                  //     //         child: Padding(
                  //     //           padding: const EdgeInsets.all(8.0),
                  //     //           child: Text(e.branchName!,style: const TextStyle(color: Colors.black),),
                  //     //         ),
                  //     //         value: e.branchUID.toString(),)).toList(),
                  //     //   onChanged: ( value){
                  //     //     AppCubit.get(context).changeSelectedBranchUIDState(value as String );
                  //     //     print(AppCubit.get(context).selectedBranchUID);
                  //     //   },
                  //     //   value: AppCubit.get(context).selectedBranchUID,
                  //     // ),
                  //   ],
                  // ),
                ],
              ),
          ),
           );

      },

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
