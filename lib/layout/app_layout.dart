



import 'package:cardsapp/app_screens/internet_error_widget/internet_error_widget.dart';
import 'package:cardsapp/layout/cubit/cubit.dart';
import 'package:cardsapp/layout/cubit/states.dart';
import 'package:cardsapp/shared/app_colors/app_colors.dart';
import 'package:cardsapp/shared/app_colors/app_colors_dark.dart';
import 'package:cardsapp/shared/components/reuseable_components.dart';
import 'package:cardsapp/shared/custom_widgets/app_maintenance_screen.dart';
import 'package:cardsapp/shared/local/cache_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AppLayout extends StatelessWidget {
  const AppLayout({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create:  (context) => AppCubit()..enableDisableApp()..getUserData()..getBranchData()..getBranchesData(),
      child: BlocConsumer<AppCubit, AppCubitStates>(
        listener: (context , state){
          relatedBranchID = CacheHelper.getData(key: 'relatedBranchID');


          if(state is AppGetUserDataSuccessState){

            // if(isAdmin == true && AppCubit.get(context).userModel!.isQuit! == false){
            //  showToast(text: 'اهلا بك في صفحة الادارة الرئيسية', state: ToastStates.Success);
            // }
            if(AppCubit.get(context).userModel!.isAdmin!){
              CacheHelper.saveData(key: 'isAdmin', value: true);
            }
          }


        },
        builder: (context , state){

          var cubit = AppCubit.get(context);
           return StreamBuilder<DocumentSnapshot>(
             stream:FirebaseFirestore.instance.collection('users').doc(uId).snapshots() ,
             builder: (context,snapShots){
               if(snapShots.data?['isQuit'] == true){
                 return Scaffold(
                   backgroundColor: AppDarkModeColors.kBackGroundColor,
                   body: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       Center(
                         child: FittedBox(
                           child: Text(' Oops, Some Thing \n'
                               '       Went Wrong',
                             style: TextStyle(
                                 color: AppDarkModeColors.kWhiteColor,fontWeight: FontWeight.bold,fontSize: 30,height: 1.3
                             ),
                           ),),

                       ),
                       SizedBox(height: 20
                         ,),
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Center(
                           child: Image.asset('assets/images/error404RBG.png',fit: BoxFit.cover,
                           ),
                         ),
                       ),
                       SizedBox(height: 20,),
                       Center(child: FittedBox(child: Text('Forbidden - You don\'t have permission\n'
                           '            to access This Application',style: TextStyle(color: AppColors.kTextLightColor,fontSize: 18,height: 1.3),))),
                       SizedBox(height: 20,),
                       // Center(
                       //   child: FittedBox(
                       //     child: Text('وانت تعلم أنك قمت بالأستقالة من الفرع',
                       //       style: TextStyle(
                       //           color: AppDarkModeColors.kRedColorShade100,fontWeight: FontWeight.bold,fontSize: 20
                       //       ),
                       //     ),),
                       //
                       // ),
                       // Center(
                       //   child: FittedBox(
                       //     child: Text('كل ما يجب عليك فعله',
                       //       style: TextStyle(
                       //           color: AppDarkModeColors.kRedColorShade100,fontWeight: FontWeight.bold,fontSize: 20
                       //       ),
                       //     ),),
                       //
                       // ),
                       // Center(
                       //   child: FittedBox(
                       //     child: Text('هو حذف التطبيق لأنه ليس لديك',
                       //       style: TextStyle(
                       //           color: AppDarkModeColors.kRedColorShade100,fontWeight: FontWeight.bold,fontSize: 20
                       //       ),
                       //     ),),
                       //
                       // ),
                       // Center(
                       //   child: FittedBox(
                       //     child: Text('أي صلاحية للوصول الى لوحة التحكم',
                       //       style: TextStyle(
                       //           color: AppDarkModeColors.kRedColorShade100,fontWeight: FontWeight.bold,fontSize: 20
                       //       ),
                       //     ),),
                       //
                       // ),
                       Center(
                         child: FittedBox(
                           child: Text('\u{1F613}',
                             style: TextStyle(
                                 color: AppDarkModeColors.kRedColorShade100,fontWeight: FontWeight.bold,fontSize: 70
                             ),
                           ),),

                       ),
                     ],
                   ),
                 );
               }else{}
              return AppCubit.get(context).isAppWorking  == true ? const AppMaintenanceScreen()  :Scaffold(
                   backgroundColor: AppDarkModeColors.kBackGroundColor,
                   appBar: AppBar(
                     centerTitle: true,
                     title:isAdmin == true? Text(cubit.titlesAdmin[cubit.currentIndex],style: TextStyle(
                         fontFamily: 'Oswald',
                         fontWeight: FontWeight.w500,
                         color: AppDarkModeColors.kWhiteColor
                     ),):Text(cubit.titles[cubit.currentIndex],style: TextStyle(
                         fontFamily: 'Oswald',
                         fontWeight: FontWeight.w500,
                         color: AppDarkModeColors.kWhiteColor
                     ),),
                     actions: [
                       // IconButton(onPressed: (){}, icon: Icon(Icons.person,color: AppColors.kTextDarkColor,)),
                       // IconButton(onPressed: (){}, icon: Icon(Icons.search,color: AppColors.kTextDarkColor,)),
                     ],
                     backgroundColor: AppDarkModeColors.kBackGroundColor,
                     elevation:0.5,
                   ),
                   body:StreamBuilder(
                     stream: Stream.periodic(Duration(seconds: 3)).asyncMap((event) => AppCubit.get(context)..checkInternet()),
                     builder: (context,snapShots){
                       return AppCubit.get(context).internetTesting ?  isAdmin == true? cubit.ScrensAdmin[cubit.currentIndex]:cubit.Screns[cubit.currentIndex]: InternetErrorWidget();
                     },
                   ),


                   bottomNavigationBar:BottomNavigationBar(
                     selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                     unselectedLabelStyle: TextStyle(),

                     backgroundColor:AppDarkModeColors.kWidgetsBackGroundColor,
                     selectedItemColor: AppColors.kButtonColor,
                     unselectedItemColor: Colors.grey,
                     showSelectedLabels: true,
                     showUnselectedLabels: true,
                     currentIndex: cubit.currentIndex,
                     onTap: (index){
                       cubit.ChangeBottomNav(index);

                     },
                     items: [
                       BottomNavigationBarItem(
                           backgroundColor:AppDarkModeColors.kWidgetsBackGroundColor,
                           label:isAdmin == true ? 'الرئيسية':'البطاقات'  ,
                           icon: isAdmin == true?Icon(Icons.home):Icon(Icons.credit_card_outlined)
                       ),
                       if(isAdmin == true)
                         BottomNavigationBarItem(
                             backgroundColor:AppDarkModeColors.kWidgetsBackGroundColor,
                             label: 'الفروع',
                             icon: Icon(Icons.category)),

                       BottomNavigationBarItem(
                           backgroundColor:AppDarkModeColors.kWidgetsBackGroundColor,
                           label:isAdmin == true ? 'الأشخاص' : ' الاعدادات',
                           icon:isAdmin == true ? Icon(Icons.person) : Icon(Icons.settings)),
                       // if(isAdmin == true)
                       //   BottomNavigationBarItem(
                       //       backgroundColor:AppDarkModeColors.kWidgetsBackGroundColor,
                       //       label: 'الاعدادات',
                       //       icon: Icon(Icons.settings)),



                     ],

                   )
                 // ConditionalBuilder(
                 //   condition: AppCubit.get(context).model !=null,
                 //   builder: (context){
                 //
                 //
                 //
                 //     var model =AppCubit.get(context).model;
                 //    return Column(
                 //       children: [
                 //         if(!model.isUserAdmin)
                 //           // Admin Panel
                 //         Container(
                 //           width: double.infinity,
                 //           height: 50.0,
                 //           color: Colors.amberAccent,
                 //           child: Padding(
                 //             padding: const EdgeInsets.symmetric(horizontal: 20.0),
                 //             child: Row(children: [
                 //               Icon(Icons.info_outline),
                 //               SizedBox(width: 5.0,),
                 //               Expanded(
                 //                   child:
                 //                   Text('Go To Admin Panel')),
                 //               SizedBox(
                 //                 width: 20.0,
                 //               ),
                 //               TextButton(onPressed: (){
                 //                 navigateTo(context, AdminScreen());
                 //               }, child: Text('OPEN')),
                 //
                 //             ],),
                 //           ),
                 //         ),
                 //
                 //         // SignOut TextButton
                 //         Center(
                 //           child: TextButton(
                 //               onPressed: ()
                 //           {
                 //             CacheHelper.removeData(key: 'uId').then((value) {
                 //               if(value){
                 //                 navigateAndFinish(context, SocialLoginScreen());
                 //               }
                 //             });
                 //           }, child: Text('LOGOUT',style: TextStyle(color: Colors.blue),)
                 //           ),
                 //         ),
                 //       ],
                 //     );
                 //   },
                 //   fallback: (context)=>Center(child: CircularProgressIndicator()),
                 // )
               );
             },

           );


        },

      ),
    );
  }
}
