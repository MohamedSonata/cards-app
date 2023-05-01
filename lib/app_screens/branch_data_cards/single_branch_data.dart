import 'package:cardsapp/app_screens/internet_error_widget/internet_error_widget.dart';
import 'package:cardsapp/models/user_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/card_model.dart';
import '../../shared/app_colors/app_colors.dart';
import '../../shared/app_colors/app_colors_dark.dart';
import '../../shared/components/reuseable_components.dart';

class SingleBranchDataScreen extends StatelessWidget {
   const SingleBranchDataScreen({Key? key,required this.branchId,required this.branchName}) : super(key: key);
   final String branchId,branchName;


  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<AppCubit>(context)..getSingleBranchCards(branchID: branchId),
      child: BlocConsumer<AppCubit,AppCubitStates>(
        listener: (context,state){},
        builder: (context,state){
          var carModelList = AppCubit.get(context).singleBranchCardsModelList;

          return AppCubit.get(context).internetTesting ? StreamBuilder(
            stream: Stream.periodic(Duration(seconds: 2)).asyncMap((event) => AppCubit.get(context)..checkInternet()),
            builder: (context, snapshot) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                    textScaleFactor: 0.80
                ),
                child: ConditionalBuilder(
                  condition: AppCubit.get(context).singleBranchCardsModelList.isNotEmpty,
                  builder: (context)=>  Scaffold(
                    backgroundColor: AppDarkModeColors.kBackGroundColor,
                    appBar: AppBar(
                      iconTheme: IconThemeData(
                        color: AppDarkModeColors.kWhiteColor
                      ),
                    elevation: 0.0,
                      backgroundColor:AppDarkModeColors.kBackGroundColor ,
                      title:  Text('بيانات بطاقات الفرع',style: TextStyle(color: AppDarkModeColors.kWhiteColor,fontWeight: FontWeight.bold),),
                    ),
                    body: Column(
                      children: [
                        /// Top Widget for Branch Name
                        FittedBox(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            margin: const EdgeInsets.only(left: 8,right: 8,bottom: 4),
                            height: 25,
                            decoration: BoxDecoration(
                                color: AppDarkModeColors.kWidgetsBackGroundColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text(
                                  '${branchName}',
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
                        /// Top Widget Of All cards And Price Of Max Quantity For The Branch
                        Container(
                          height: 25,
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              color: AppDarkModeColors.kYellowColorShade300,
                              borderRadius: BorderRadius.circular(24)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              carModelList.isNotEmpty ?Text(
                                '${carModelList.isNotEmpty ?AppCubit.get(context).singleBranchCardsModelList
                                    .map<double>((e) => e.price*e.maxQuantity )
                                    .reduce((element, value) =>element+value  ).toString():0} JOD  / ',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22
                                ),
                              ):const Text('0'),
                              carModelList.isNotEmpty ?Text(
                                ' ${carModelList.isNotEmpty ?AppCubit.get(context).singleBranchCardsModelList
                                    .map<int>((e) => e.maxQuantity! )
                                    .reduce((element, value) =>element+value  ).toString() :0} بطاقة ',
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
                        /// Cards Widget List
                        Expanded(child: cartProductsListBuilder(context)),
                        /// Bottom Widget Of all cards and price of quantity for the branch
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: AppDarkModeColors.kYellowColorShade300,
                              borderRadius: BorderRadius.circular(4)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              carModelList.isNotEmpty ?Text(
                                '${carModelList.isNotEmpty ?AppCubit.get(context).singleBranchCardsModelList
                                    .map<double>((e) => e.price*e.quantity )
                                    .reduce((element, value) =>element+value  ).toString():0} JOD',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22
                                ),
                              ):const Text('0'),
                              const Text(' : سعر البطاقات المتوفرة في الفرع',style: TextStyle(
                                  color: Colors.white,
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
                  ),
                  fallback:(context)=> Scaffold(
                    appBar: AppBar(
                      title: Text('بيانات بطاقات الفرع'),
                    ),
                      body: Column(
                        children: [
                          Center(child: CircularProgressIndicator(color: AppDarkModeColors.kGreenColorShade100,)),
                        ],
                      )),

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
   Widget cartProductsListBuilder(context) =>
       Padding(
         padding: const EdgeInsets.symmetric(horizontal: 8.0),
         child: CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
           SliverList(
             delegate: SliverChildBuilderDelegate(
                     (context, index) => AppCubit.get(context).singleBranchCardsModelList.isNotEmpty ?Column(
                   children: [
                     cardItemBuilder(
                         AppCubit.get(context).singleBranchCardsModelList[index],context ,index),
                   ],
                 )
                     : const Text('Loading'),
                 childCount:AppCubit.get(context).singleBranchCardsModelList.length),
           ),
           SliverToBoxAdapter(
             child: Column(
               children: [
                 Container(

                   decoration: BoxDecoration(
                       color: AppColors.kBackGroundColor,
                       borderRadius: BorderRadius.circular(10)
                   ),
                   padding: EdgeInsets.all(4),
                   child: Row(
                     children: [
                       const Text('Total ',style: TextStyle(fontSize: 18),),
                       // Text('${AppCubit.get(context).cardModelList.map((e) => e.price * e.quantity).reduce((value, element) => element + value)} JOD'),
                     ],
                   ),
                 )
               ],
             ),
           )
         ]),
       );

   Widget cardItemBuilder(CardModel cardModel,context, index) => Column(
     children: [
       const SizedBox(
         height: 5,
       ),
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
             /// Card Image Widget
             cardModel.image != null ? CircleAvatar(
               radius: 25,
               foregroundImage: AssetImage('${cardModel.image}'),
             ):
             CircleAvatar(
               radius: 25,
               foregroundImage: AssetImage('assets/images/orange7.jpg'),
             ),
             const SizedBox(
               width: 10,
             ),
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 /// Card Name Widget
                 Text(
                   'Card Name: ${cardModel.cardName}',
                   style:  TextStyle(
                       color: AppDarkModeColors.kWhiteColor,
                       fontWeight: FontWeight.bold,
                       fontSize: 18),
                 ),
                 /// Card Price Widget
                 Text(
                   'Card price: ${cardModel.price} JOD',
                   style: TextStyle(
                       color: AppColors.kButtonColor,
                       fontWeight: FontWeight.w600,
                       fontSize: 16),
                 ),
                 const SizedBox(
                   height: 5,
                 ),
                 /// Card Quantity Widget
                 StreamBuilder<DocumentSnapshot>(
                     stream:FirebaseFirestore.instance.collection('branches').doc(branchId).collection('cards').doc(AppCubit.get(context).singleBranchCardsModelList[index].cardUID).snapshots() ,
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
                 /// Card UpdatedAt Widget
                 Text(
                   'UpdatedAt: ${cardModel.updatedAt?.substring(0,16)}',
                   style: TextStyle(
                       color: AppDarkModeColors.kWhiteColor,

                       fontSize: 14),
                 ),
                 /// Card UpdatedBy Widget
                 Text(
                   'UpdatedBy: ${cardModel.updatedBy?.substring(0,cardModel.updatedBy?.length)}',
                   style: TextStyle(
                       color: AppDarkModeColors.kGreenColorShade100,

                       fontSize: 14,fontWeight: FontWeight.bold),
                 ),
               ],
             ),
             Spacer(),
             /// Card Increase and decrease Quantity Widget
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
                           AppCubit.get(context).decreaseCardQuantityAdminFunc(
                             branchUID: branchId,
                             cardID: cardModel.cardUID,
                             cardName:cardModel.cardName ,
                             image: cardModel.image,
                             updatedAt: DateTime.now().toString(),
                             quantity: cardModel.quantity! -1,
                             price:cardModel.price ,
                             updatedBy: 'Admin',
                             maxQuantity: cardModel.maxQuantity,
                               filterByNum: cardModel.filterByNum
                           );
                         }else{
                           showToast(text: 'غير مسموح', state: ToastStates.ERROR,runiCode: ' \u{1F627}');
                         }
                       },
                       icon: const Icon(
                         Icons.remove,
                         color: Colors.black,
                       )),

                   StreamBuilder<DocumentSnapshot>(
                       stream:FirebaseFirestore.instance.collection('branches').doc(branchId).collection('cards').doc(AppCubit.get(context).singleBranchCardsModelList[index].cardUID).snapshots() ,
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
                         if(cardModel.quantity! <cardModel.maxQuantity!){
                           AppCubit.get(context).increaseCardQuantityAdminFunc(
                               branchUID: branchId,
                               cardID: cardModel.cardUID,
                               cardName:cardModel.cardName ,
                               image: cardModel.image,
                               updatedAt: DateTime.now().toString(),
                               quantity: cardModel.quantity! +1 ,
                               price:cardModel.price ,
                               updatedBy: 'Admin',
                               maxQuantity: cardModel.maxQuantity,
                               filterByNum: cardModel.filterByNum

                           );


                         }else{
                           showToast(text: 'غير مسموح', state: ToastStates.ERROR,runiCode: ' \u{1F627}');
                         }

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
