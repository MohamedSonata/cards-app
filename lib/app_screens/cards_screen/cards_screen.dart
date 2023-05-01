import 'package:cardsapp/app_screens/branch_data_cards/single_branch_data.dart';
import 'package:cardsapp/layout/cubit/states.dart';
import 'package:cardsapp/models/branches_model.dart';
import 'package:cardsapp/shared/app_colors/app_colors.dart';
import 'package:cardsapp/shared/app_colors/app_colors_dark.dart';
import 'package:cardsapp/shared/components/reuseable_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/cubit.dart';
import '../../models/card_model.dart';
import '../../shared/local/cache_helper.dart';

class CardsScreen extends StatelessWidget {
   CardsScreen({Key? key}) : super(key: key);
  var quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppCubitStates>(
      listener: (context, state) {

      },
      builder: (context, state) {

        var carModelList = AppCubit.get(context).cardModelList;
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
              textScaleFactor: .85
          ),
          child: ConditionalBuilder(
            condition: state is !AppGetUserDataSuccessState,
            builder: (context)=> isAdmin == true ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  Center(
                    child: FittedBox(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        margin: const EdgeInsets.all(8),
                        height: 50,
                        decoration: BoxDecoration(
                            color: AppDarkModeColors.kWidgetsBackGroundColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            const Text(
                              'Branches',
                              style:  TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),


                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context,index)=>branchItemBuilder(AppCubit.get(context).branchesModelList[index],context,index),
                        separatorBuilder: (context,index)=>myDivider(),
                        itemCount: 4),
                  )


                  // Expanded(
                  //   child: ListView.separated(
                  //       itemBuilder: (context, index) => cardItemBuilder(
                  //           AppCubit.get(context).cardModelList[index], index),
                  //       separatorBuilder: (context, index) => myDivider(),
                  //       itemCount: AppCubit.get(context).cardModelList.length),
                  // )
                ],
              ),
            ):
            Column(
              children: [
                FittedBox(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    margin: const EdgeInsets.only(left: 8,right:8,bottom: 5),
                    height: 25,
                    decoration: BoxDecoration(
                        color: AppDarkModeColors.kWidgetsBackGroundColor.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(
                          '${AppCubit.get(context).branchesModel?.branchName}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                         Text(
                          ' : اسم الفرع ',
                          style:  TextStyle(
                              color: AppDarkModeColors.kGreenColorShade100,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  height: 25,
                  decoration: BoxDecoration(
                      color: AppDarkModeColors.kYellowColorShade300,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      carModelList.isNotEmpty ?Text(
                        '${carModelList.isNotEmpty ?AppCubit.get(context).cardModelList
                            .map<double>((e) => e.price*e.maxQuantity )
                            .reduce((element, value) =>element+value  ).toString():0} JOD  / ',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22
                        ),
                      ):const Text('0'),
                      carModelList.isNotEmpty ?Text(

                        '${carModelList.isNotEmpty ?AppCubit.get(context).cardModelList
                            .map<int>((e) => e.maxQuantity! )
                            .reduce((element, value) =>element+value  ).toString() :0} بطاقة',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22
                        ),
                        textDirection: TextDirection.rtl,
                      ):const Text('0'),
                      const Text(' : أقصى كمية للفرع',style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),),
                    ],
                  ),
                ),

                Expanded(child: cartProductsListBuilder(context)),
                Container(

                  height: 35,
                  decoration: BoxDecoration(
                      color: AppDarkModeColors.kYellowColorShade300,
                      borderRadius: BorderRadius.circular(4)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      carModelList.isNotEmpty ?Text(
                        '${carModelList.isNotEmpty ?AppCubit.get(context).cardModelList
                            .map<double>((e) => e.price*e.quantity )
                            .reduce((element, value) =>element+value  ).toString():0} JOD',
                        style:  TextStyle(
                            color: AppDarkModeColors.kWhiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 22
                        ),
                      ):const Text('0'),
                      Text(' : سعر البطاقات المتوفرة في الفرع',style: TextStyle(
                          color: AppDarkModeColors.kWhiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),),
                    ],
                  ),
                ),


                // Expanded(
                //   child: ListView.separated(
                //       itemBuilder: (context, index) => cardItemBuilder(
                //           AppCubit.get(context).cardModelList[index], index),
                //       separatorBuilder: (context, index) => myDivider(),
                //       itemCount: AppCubit.get(context).cardModelList.length),
                // )
              ],
            ),
            fallback:(context)=> Column(
              children: [
                Center(child: CircularProgressIndicator()),
              ],
            ),

          ),
        );
      },
    );
  }

   Widget branchItemBuilder(BranchesModel branchesModel,context,index)=>InkWell(
     onTap: (){
       print(AppCubit.get(context).branchesModelList[index].branchUID
       );
       navigateTo(context, SingleBranchDataScreen(
         branchId:AppCubit.get(context).branchesModelList[index].branchUID!
         ,branchName:AppCubit.get(context).branchesModelList[index].branchName! ,));
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
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text('Branch Name:  ${branchesModel.branchName}',style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w600),),
                 Text('Related Users',style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w400),),
               ],
             ),
             Spacer(),
             Column(
               children: [
                 IconButton(onPressed: (){
                   print(AppCubit.get(context).branchesModelList[index].branchUID
                   );
                   navigateTo(context, SingleBranchDataScreen(
                     branchId:AppCubit.get(context).branchesModelList[index].branchUID!
                     ,branchName:AppCubit.get(context).branchesModelList[index].branchName! ,));
                 }, icon: Icon(Icons.edit,color: Colors.white,)),
                 Text('تعديل',style: TextStyle(color: Colors.white),)
               ],
             )
           ],
         ),
       ),
     ),
   );
  Widget cartProductsListBuilder(context) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => AppCubit.get(context).cardModelList.isNotEmpty ?Column(
                        children: [
                          cardItemBuilder(
                              AppCubit.get(context).cardModelList[index],context, index),
                        ],
                      )
                    : const Text('Loading'),
                childCount:AppCubit.get(context).cardModelList.length),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.kBackGroundColor,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      children: [
                        const Text('Total: '),
                        // Text('${AppCubit.get(context).cardModelList.map((e) => e.price * e.quantity).reduce((value, element) => element + value)} JOD'),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ]),
      );

  Widget cardItemBuilder(CardModel cardModel,context, index) => Column(
        children: [

          Container(
            margin: EdgeInsets.symmetric(horizontal: 4,vertical: 2),


            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
            decoration: BoxDecoration(
                color: AppDarkModeColors.kBackGroundColor,
                borderRadius: BorderRadius.circular(20),
              // gradient:LinearGradient(
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              //   colors: [
              //     AppDarkModeColors.kBackGroundColor,
              //     AppDarkModeColors.kBackGroundColor.withOpacity(0.1)
              //   ]
              // ),
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
                  blurRadius: 2,
                  spreadRadius: 0.0,
                ),
              ]
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  foregroundImage: AssetImage('${cardModel.image}'),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Card Name: ${cardModel.cardName}',
                      style:  TextStyle(
                          color: AppDarkModeColors.kWhiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),

                    Text(
                      'Card price: ${cardModel.price} JOD',
                      style: TextStyle(
                          color: AppDarkModeColors.kWhiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),



                    const SizedBox(
                      height: 5,
                    ),
                    StreamBuilder<DocumentSnapshot>(
                        stream:FirebaseFirestore.instance.collection('branches').doc(AppCubit.get(context).userModel?.relatedBranchID).collection('cards').doc(AppCubit.get(context).cardModelList[index].cardUID).snapshots() ,
                        builder: (context,snapShot){
                          if(snapShot.hasData){
                            return Text(
                              'Card Quantity: ${snapShot.data?['quantity']}',
                              style:  TextStyle(color: AppDarkModeColors.kWhiteColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            );
                          }else{
                            return Text(
                              'Card Quantity: 0',
                              style:  TextStyle(color: AppDarkModeColors.kWhiteColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            );
                          }


                        }),
                    // Text(
                    //   'Card Quantity: ${cardModel.quantity}',
                    //   style: TextStyle(
                    //       color: AppColors.kTextWarningRedColor,
                    //       fontWeight: FontWeight.w600,
                    //       fontSize: 16),
                    // ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Total Price: ${cardModel.quantity! * cardModel.price} JOD',
                      style: TextStyle(
                          color: AppDarkModeColors.kRedColorShade200,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                    Text(
                      'UpdatedAt: ${cardModel.updatedAt?.substring(0,16)}',
                      style: TextStyle(
                          color: AppDarkModeColors.kWhiteColor,

                          fontSize: 14),
                    ),
                    if(cardModel.updatedBy!.length>16)

                      Text(
                      'UpdatedBy: ${cardModel.updatedBy?.substring(0,15)}',
                      style: TextStyle(
                          color: AppDarkModeColors.kGreenColorShade100,

                          fontSize: 14),
                    ),
                    if(cardModel.updatedBy!.length<16)
                    Text(
                      'UpdatedBy: ${cardModel.updatedBy?.substring(0,cardModel.updatedBy!.length)}',
                      style: TextStyle(
                          color: AppDarkModeColors.kGreenColorShade100,

                          fontSize: 14),
                    ),
                  ],
                ),
               Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                           if(cardModel.quantity! >0){
                             AppCubit.get(context).decreaseCardQuantity(
                               cardID: cardModel.cardUID,
                               cardName:cardModel.cardName ,
                               image: cardModel.image,
                               updatedAt: DateTime.now().toString(),
                               quantity: cardModel.quantity! -1,
                               price:cardModel.price ,
                               updatedBy: AppCubit.get(context).userModel?.userName,
                               maxQuantity: cardModel.maxQuantity,
                                 filterByNum: cardModel.filterByNum

                             );
                           }else{
                             showToast(text: 'غير مسموح', state: ToastStates.ERROR, runiCode: ' \u{1F627}');
                           }
                          },
                          icon: const Icon(
                            Icons.remove,
                            color: Colors.black,
                          )),

                      StreamBuilder<DocumentSnapshot>(
                        stream:FirebaseFirestore.instance.collection('branches').doc(AppCubit.get(context).userModel?.relatedBranchID).collection('cards').doc(AppCubit.get(context).cardModelList[index].cardUID).snapshots() ,
                          builder: (context,snapShot){
                          if(snapShot.hasData){
                            return Text(
                              '${snapShot.data?['quantity']}',
                              style: const TextStyle(fontSize: 18,color: Colors.red,fontWeight: FontWeight.bold),
                            );
                          }else{
                            return Text(
                              '0',
                              style: const TextStyle(fontSize: 18,color: Colors.red,fontWeight: FontWeight.bold),
                            );
                          }

                        // return TextFormField(
                        //   controller: quantityController,
                        // );



                      }),

                      IconButton(
                          onPressed: () {
                            if(cardModel.quantity! < cardModel.maxQuantity!){ AppCubit.get(context).increaseCardQuantity(
                                cardID: cardModel.cardUID,
                                cardName:cardModel.cardName ,
                                image: cardModel.image,
                                updatedAt: DateTime.now().toString(),
                                quantity: cardModel.quantity! +1 ,
                                price:cardModel.price ,
                                updatedBy: AppCubit.get(context).userModel?.userName,
                                maxQuantity: cardModel.maxQuantity,
                              filterByNum: cardModel.filterByNum
                            );
                            }else{
                              showToast(text: 'غير مسموح', state: ToastStates.ERROR, runiCode: ' \u{1F627}');                            }

                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.black,
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          )
        ],
      );
}
