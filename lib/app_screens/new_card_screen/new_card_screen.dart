import 'package:cardsapp/layout/app_layout.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/app_colors/app_colors_dark.dart';
import '../../shared/components/reuseable_components.dart';
import '../internet_error_widget/internet_error_widget.dart';

class AddNewCardScreen extends StatelessWidget {
   AddNewCardScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();

  var cardNameController = TextEditingController();
  var priceController = TextEditingController() ;
  var quantityController = TextEditingController();
  var maxQuantityController = TextEditingController();
  var branchNameController = TextEditingController();
  var selectedBranchUIDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context)=>AppCubit()..getBranchesData(),
      child: BlocConsumer<AppCubit,AppCubitStates>(
        listener: (context,state){

          if( state is AppAddNewCardSuccessState){
            showToast(text: 'تمت الاضافة بنجاح', state:ToastStates.Success , runiCode: '');
            showRatingDialog(context);
          }
          if( state is AppGetSingleBranchDataSuccessState){
            branchNameController.text  = AppCubit.get(context).newCardSelectedBranchName!;
            selectedBranchUIDController.text  = AppCubit.get(context).selectedNewCardBranchUID!;


          }
        },
        builder: (context,state){

          return AppCubit.get(context).internetTesting ?   StreamBuilder(
            stream: Stream.periodic(Duration(seconds: 3)).asyncMap((event) => AppCubit.get(context)..checkInternet()),
            builder: (context, snapshot) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                    textScaleFactor: .85
                ),
                child: Scaffold(
                  backgroundColor: AppDarkModeColors.kBackGroundColor,
                  appBar: AppBar(
                    centerTitle: true,
                    title: const Text('اضافة بطاقة جديدة',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    backgroundColor: AppDarkModeColors.kBackGroundColor,
                    iconTheme: const IconThemeData(
                      color: Colors.white
                    ),
                  ),
                  body: SingleChildScrollView(
                    child:  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            const Text('اضافة بطاقة جديدة وربطها مع الفرع',style: TextStyle(
                              color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20
                            ),),
                            warningTextBuilder('اسم البطاقة',context),
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white.withOpacity(0.9),),

                              child: TextFormField(
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return "Please enter Card Name";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: cardNameController,
                                decoration: InputDecoration(
                                  // labelText: 'Card Name',
                                    hintText: 'Example: Orange 1',
                                    hintStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                    prefixIcon:  const Icon(
                                      Icons.add_card_outlined,

                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide:  const BorderSide(

                                      ),
                                    )),
                              ),
                            ),
                            warningTextBuilder('السعر',context),
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white.withOpacity(0.9),),

                              child: TextFormField(
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return "Please enter Card Price";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: priceController,
                                decoration: InputDecoration(
                                  // labelText: 'Card Price',
                                    hintText: 'Example: 1.75',
                                    hintStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                    prefixIcon:  const Icon(
                                      Icons.price_change,

                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide:  const BorderSide(

                                      ),
                                    )),
                              ),
                            ),
                            warningTextBuilder('الكمية',context),
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white.withOpacity(0.9),),

                              child: TextFormField(
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return "Please enter Card Quantity";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: quantityController ,
                                decoration: InputDecoration(
                                  // labelText: 'Card Quantity',
                                    hintText: 'Example: 8',
                                    hintStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                    prefixIcon:  const Icon(
                                      Icons.numbers_rounded,

                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide:  const BorderSide(

                                      ),
                                    )),
                              ),
                            ),
                            warningTextBuilder('أقصى كمية للبطاقة',context),
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white.withOpacity(0.9),),

                              child: TextFormField(
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return "Please enter Card MaxQuantity";
                                  } else {
                                    return null;
                                  }
                                },
                                controller:maxQuantityController ,
                                decoration: InputDecoration(
                                  // labelText: 'Card Quantity',
                                    hintText: 'Example: 8',
                                    hintStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                    prefixIcon:  const Icon(
                                      Icons.numbers_rounded,

                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide:  const BorderSide(

                                      ),
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [


                                DropdownButton(
                                  dropdownColor: AppDarkModeColors.kWidgetsBackGroundColor,
                                  focusColor:AppDarkModeColors.kWidgetsBackGroundColor ,
                                  iconEnabledColor: AppDarkModeColors.kWhiteColor,




                                  borderRadius: BorderRadius.circular(12),

                                  hint:  Text(
                                    '    إختر الفرع',
                                    style: TextStyle(color: AppDarkModeColors.kWhiteColor,fontWeight: FontWeight.bold),
                                  ),
                                  items: AppCubit.get(context)
                                      .branchesModelList
                                      .map((e) => DropdownMenuItem(
                                    value: e.branchUID.toString(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        e.branchName!,
                                        style:  TextStyle(
                                            color: AppDarkModeColors.kWhiteColor),
                                      ),
                                    ),
                                  ))
                                      .toList(),
                                  onChanged: (value) async{
                                    AppCubit.get(context)
                                        .changeNewCardSelectedBranchUIDState(
                                        value as String);
                                    AppCubit.get(context).getSingleBranchData(singleBranchUID: value);
                                    AppCubit.get(context).getBranchCardsAdminFunc(branchUID: value);
                                    print(AppCubit.get(context).selectedNewCardBranchUID);
                                   // if( state is !AppGetSingleBranchDataLoadingState){
                                   //   branchNameController.text  = AppCubit.get(context).singleBranchModel!.branchName!;
                                   //   print('Controller : ${branchNameController.text}');
                                   //
                                   // }

                                  },
                                  value:AppCubit.get(context).selectedNewCardBranchUID ,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                warningTextBuilder('الفرع',context),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ConditionalBuilder(
                              condition: state is !AppAddNewCardLoadingState,
                              builder: (context)=>Container(
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: AppDarkModeColors.kBlueColorShade100,
                                    ),
                                    onPressed: (){

                                      // showToast(text: 'قريبا', state:ToastStates.Success ,runiCode: '');
                                      // if(formKey.currentState!.validate()){
                                      //   if(AppCubit.get(context).newCardSelectedBranchName !=null ){
                                      //
                                      //   }else{
                                      //     showToast(
                                      //         text: 'الرجاء اختيار الفرع أولا',
                                      //         state: ToastStates.ERROR,
                                      //         runiCode: '\u{1F3EC}');
                                      //   }
                                      // }

                                      if(formKey.currentState!.validate()){
                                        if(AppCubit.get(context).selectedNewCardBranchUID !=null){
                                          AppCubit.get(context).addNewCard(
                                            filterByNum: AppCubit.get(context).cardModelListAdmin.length +1,
                                            selectedBranchID: selectedBranchUIDController.text.toString(),
                                              cardName: cardNameController.text,
                                              price: double.tryParse(priceController.text),
                                              quantity: int.tryParse(quantityController.text),
                                              maxQuantity: int.tryParse(maxQuantityController.text)
                                          );


                                        }else{
                                          showToast(
                                              text: 'الرجاء اختيار الفرع أولا',
                                              state: ToastStates.ERROR,
                                              runiCode: '\u{1F3EC}');
                                        }

                                      }
                                    }, child: const Text('اضافة البطاقة',style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),)),
                              ),
                              fallback: (context)=> Center(child: CircularProgressIndicator(color: AppDarkModeColors.kGreenColorShade100,)),

                            )

                          ],
                        ),
                      ),
                    ),
                  ),

                ),
              );
            }
          ): StreamBuilder<Object>(
            stream: Stream.periodic(Duration(seconds: 3)).asyncMap((event) => AppCubit.get(context)..checkInternet()),
            builder: (context, snapshot) {
              return InternetErrorWidget();
            }
          );
        },

      ),
    );
  }
   showRatingDialog(context){
     showDialog(
         barrierDismissible: false,
         context: context,
         builder: (context){

       return BlocConsumer<AppCubit,AppCubitStates>(
         listener: (context,state){},
         builder: (context,state){
           return WillPopScope(
             onWillPop: ()async=>false,
             child: Dialog(
                 child: Stack(
                   children: [
                     ratingDialogWelcome(context),
                     dialogDetailsBoxBuilder(context),
                   ],
                 )
             ),
           );
         },

       );
     });
   }
   Widget dialogDetailsBoxBuilder(context)=>Positioned(
       bottom: 0,
       left: 0,
       right: 0,
       child: Row(
         children: [
           Expanded(
             child: Container(
               decoration:  const BoxDecoration(
                   color: Colors.red,
                   borderRadius:  BorderRadius.only(
                       topRight: Radius.circular(24),
                       bottomRight: Radius.circular(24)

                   )

               ),

               child: MaterialButton(
                 onPressed: (){
                   navigateTo(context, AppLayout());


                   // Navigator.pop(context);


                 },
                 child: const Text('الغاء',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                 ),
                 textColor: Colors.white,
               ),
             ),
           ),
           const SizedBox(width: 8,),
           Expanded(
             child: Container(
               decoration:  BoxDecoration(
                   color: AppDarkModeColors.kGreenColorShade300,
                   borderRadius:  const BorderRadius.only(
                       topLeft: Radius.circular(24),
                       bottomLeft: Radius.circular(24)

                   )

               ),

               child: MaterialButton(
                 onPressed: (){
                   cardNameController.clear();
                    priceController.clear();
                   quantityController.clear();
                    maxQuantityController.clear();
                  branchNameController.clear();
                  selectedBranchUIDController.clear();
                   Navigator.pop(context);
                 },
                 child: const Text('اضافة بطاقة أخرى',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                 ),
                 textColor: Colors.white,
               ),
             ),
           ),
         ],
       ));
   Widget ratingDialogWelcome(context)=> Container(
     margin: const EdgeInsets.all(12),
     decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(24)
     ),
     clipBehavior: Clip.antiAlias,
     height: 200,
     width: double.infinity,
     child: Column(

       children:  [


         const SizedBox(height: 15,),
         Text(' تم اضافة البطاقة بنجاح \n  ${cardNameController.text}',style:  const TextStyle(
             fontSize: 24,
             fontWeight: FontWeight.bold,
             color: Colors.red
         ),
           textAlign: TextAlign.center,),
         const SizedBox(height: 5,),
         Text(' الى الفرع: ${branchNameController.text} ',style: const TextStyle(color: Colors.red,fontSize: 18,fontWeight: FontWeight.bold),),


       ],
     ),
   );
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
                       TextSpan(text:' *' ,
                           style: TextStyle(
                               fontSize: 18.0,
                               color:  AppDarkModeColors.kRedColorShade100,
                               fontWeight: FontWeight.bold)
                       ),
                     ]
                 )
             ),
           ],
         ),
       );
}
