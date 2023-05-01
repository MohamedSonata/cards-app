import 'package:cardsapp/layout/cubit/cubit.dart';
import 'package:cardsapp/layout/cubit/states.dart';
import 'package:cardsapp/models/user_data_model.dart';
import 'package:cardsapp/shared/app_colors/app_colors.dart';
import 'package:cardsapp/shared/app_colors/app_colors_dark.dart';
import 'package:cardsapp/shared/components/reuseable_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../get_user_data_screen/user_data_screen.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return
      BlocConsumer<AppCubit,AppCubitStates>(
        listener: (context,state){},
        builder: (context,state){

          return isAdmin == true ?    MediaQuery(
            data: MediaQuery.of(context).copyWith(
                textScaleFactor: .85
            ),
            child: ConditionalBuilder(
              condition: AppCubit.get(context).users.isNotEmpty,
              builder: (context)=>ListView.separated(
                itemBuilder: (context,index)=>userItemBuilder(AppCubit.get(context).users[index],context,index),
                separatorBuilder: (context,index)=>myDivider(),
                itemCount: AppCubit.get(context).users.length,),

              fallback: (context)=>Center(child: CircularProgressIndicator()),

            ),
          ):Center(child: Text('Coming Soon...',style: TextStyle(color: Colors.grey.shade400,fontSize: 25),));
        },

      );

  }
  Widget userItemBuilder(UserDataModel userDataModel,context,index)=>InkWell(
    onTap: (){
      navigateTo(context, UserDataScreen(userUID:AppCubit.get(context).users[index].uId!,));
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: AppDarkModeColors.kWidgetsBackGroundColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            SizedBox(width: 5,),
            CircleAvatar(
              radius: 50,
              foregroundImage:NetworkImage('${userDataModel.image}',
              ),
            ),
            SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('UserName : ${userDataModel.userName}',style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w600),),
                Text('Email    : ${userDataModel.email}',style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w400),),
                Text('Phone  : ${userDataModel.phoneNumber}',style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w400),),
                Text('Branch : ${userDataModel.branch}',style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w400),),
                Text('Password : ${userDataModel.password}',style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w400),),

                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').doc(AppCubit.get(context).users[index].uId).snapshots(),
                    builder: (context,snapShot){
                    return snapShot.data?['isQuit'] == true? Text('IsQuit   : تم استقالة الشخص',style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w400)) :Text('IsQuit   : مازال بالدوام',style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w400));
      }),
                // AppCubit.get(context).users[index].isQuit! ? Text('IsQuit   : تم استقالة الشخص',style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w400)
                //   ,):Text('IsQuit   : مازال بالدوام',style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w400),),

              ],
            ),
            Spacer(),
            Column(
              children: [
                IconButton(onPressed: (){
                  navigateTo(context, UserDataScreen(userUID:AppCubit.get(context).users[index].uId!,));
                }, icon: Icon(Icons.edit,color: Colors.white,)),
                Text('Edit',style: TextStyle(color: Colors.white),)
              ],
            )
          ],
        ),
      ),
    ),
  );
}
