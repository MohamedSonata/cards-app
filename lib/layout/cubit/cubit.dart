

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cardsapp/app_screens/cards_screen/cards_screen.dart';
import 'package:cardsapp/app_screens/home_screen/home_screen.dart';
import 'package:cardsapp/app_screens/settings_screen/settings_screen.dart';
import 'package:cardsapp/app_screens/users_screen/users_screen.dart';
import 'package:cardsapp/models/branches_model.dart';


import 'package:cardsapp/shared/components/reuseable_components.dart';
import 'package:cardsapp/layout/cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/app_create_user_model.dart';
import '../../models/card_model.dart';
import '../../models/permissions_model.dart';
import '../../models/user_data_model.dart';
import '../../shared/local/cache_helper.dart';
import '../app_layout.dart';
import 'package:url_launcher/url_launcher.dart';



class AppCubit extends Cubit<AppCubitStates>{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context)=> BlocProvider.of(context);
  /// #######################################  UserRegister Functions
  void userRegister({
    required String userName,
    required String email,
    required String password,
    required String phoneNumber,
    required String branch,
    required String relatedBranchID,
    required bool isAdmin,
    required bool isQuit,

  }) {
    emit(AppRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
        email: email,
        password: password)
        .then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      userCreate(
          userName: userName,
          email: email,
          password: password,
          phoneNumber: phoneNumber,
          branch: branch,
          relatedBranchID: relatedBranchID,
          uId: value.user!.uid,
          isAdmin: isAdmin,
          isQuit: isQuit
      );


    })
        .catchError((error){
      print(error.toString());
      emit(AppRegisterErrorState(error.toString()));

    });

  }

  void userCreate({
    required String userName,
    required String email,
    required String password,
    required String phoneNumber,
    required String branch,
    required String relatedBranchID,
    required String uId,
    required bool isAdmin,
    required bool isQuit,

  })
  {
    AppUserCreateModel model = AppUserCreateModel(
      userName: userName,
      email:email,
      phoneNumber: phoneNumber,
      password: password,
      image: 'https://image.freepik.com/free-vector/man-shows-gesture-great-idea_10045-637.jpg',
      isAdmin: isAdmin,
      branch: branch,
      isQuit: isQuit,
      relatedBranchID:relatedBranchID ,
      uId: uId,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(AppCreateUserSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(AppCreateUserErorrstate(error.toString()));
    });
  }

  bool registerForm = false;

  void changeRegisterFormState({required bool registerFormState}){
    registerForm = registerFormState;
    // emit(AppAddProductChangeProductTypeState());
    emit(AppRegisterFormChangeState());
  }
  /// ############################################################

  bool internetTesting = true;
  bool isAppWorking = false;
  PermissionsModel? permissionsModel;
  enableDisableApp()async{
    // emit(AppCheckIsAppWorkingLoadingState());
  await  FirebaseFirestore.instance.collection('permissions').doc('Nc8TCNSx5Poe8K3kna0I').get()
        .then((value) {
      permissionsModel = PermissionsModel.fromJson(value.data()!);
      isAppWorking = permissionsModel!.isAppWorking!;
      if(isAppWorking == true){
        emit(AppCheckIsAppWorkingSuccessState());
      }


      // print('isAppWorking Value: $isAppWorking');
    }).catchError((error){
    emit(AppCheckIsAppWorkingErrorState(error.toString()));

    // print('isAppWorking : Error');
    });

  }
  checkInternet()async{
    // emit(AppcheckInternetConnectionLoadingState());
    try{
      var result =await InternetAddress.lookup('google.com');
      if(result.isNotEmpty&& result[0].rawAddress.isNotEmpty){
        // print('Internet HasMethod Access Success');
        internetTesting = true;
        if(internetTesting == false){
          emit(AppcheckInternetConnectionSuccessState());
        }
      }
    }on SocketException catch(_){
      print('Internet HasMethod Access Error');
      internetTesting = false;
      emit(AppcheckInternetConnectionErrorState());
    }
  }
   UserDataModel? userModel;

  void getUserData()async{

emit(AppGetUserDataLoadingState());
FirebaseFirestore.instance
    .collection('users')
    .doc(uId)
    .get()
    .then((value) async {

  print('UserData${value.data()}');
      userModel = UserDataModel.fromJson(value.data()!);
  await CacheHelper.saveData(
      key: 'relatedBranchID',
      value: userModel?.relatedBranchID.toString())
      .then((value) {
    relatedBranchID = CacheHelper.getData(key: 'relatedBranchID');
    print('related after edit $relatedBranchID');
  });
  await CacheHelper.saveData(
      key: 'isAdmin',
      value: userModel?.isAdmin)
      .then((value) {
    isAdmin = CacheHelper.getData(key: 'isAdmin');
    print('isAdmin after edit $isAdmin');
  });
      // print(userModel?.relatedBranchID);
 isAdmin == true ? print(relatedBranchID):getBranchCards()  ;


      // print('UserData${value.data()}');
      emit(AppGetUserDataSuccessState());

}).catchError((error){
  print(error.toString());
  emit(AppGetUserDataErrorState(error.toString()));
});


  }
UserDataModel? singleUserDataModel;
  void getSingleUserData({required String userID}){

    emit(AppGetSingleUserDataLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .get()
        .then((value) {

      print('UserData${value.data()}');
      singleUserDataModel = UserDataModel.fromJson(value.data()!);


      // print('UserData${value.data()}');
      emit(AppGetSingleUserDataSuccessState(singleUserDataModel!));

    }).catchError((error){
      print(error.toString());
      emit(AppGetSingleUserDataErrorState(error.toString()));
    });


  }


  int currentIndex = 0;

  List<Widget> Screns=[
    CardsScreen(),
    HomeScreen(),
    // UsersScreen(),

    // SettingsScreen(),

  ];
  List<Widget> ScrensAdmin=[
    SettingsScreen(),
    CardsScreen(),
    UsersScreen(),
    // HomeScreen(),
  ];
  List<String>titles=[

    'Cards',
    'Settings',

  ];
List<String>titlesAdmin=[

  'Home',
  'Users ',
  'Branches ',
  'Settings',

];
   Future sendEmail(
      {required String email, String subject = "", String body = ""}) async {
     final Uri emailLaunchUri = Uri(
       scheme: 'mailto',
       path: 'preduroapps@gmail.com',

     );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw Exception("Unable to open the email");
    }
  }
  void ChangeBottomNav(int index) {
    currentIndex = index;
    if(index == 2 && isAdmin == true){
      getUsers();
    }
   emit(AppChangeBottomNavState());

  }
  void signOut(){
    FirebaseAuth.instance.signOut();
  }
List<UserDataModel> users=[];
  CardModel? cardModel;
  void getUsers(){
    users.clear();
    // emit(SocialGetPostLoadingStates());
    FirebaseFirestore.instance.collection('users').get().then((value) {


      for (var element in value.docs) {
        if(element.data()['uId']!=uId) {
          users.add(UserDataModel.fromJson(element.data()));
        }
      }
      print('users List Length : ${users.length}');
      emit(AppGetAllUsersSuccessState());
    }).catchError((error) {
        print('error << $error >>');
        emit(AppGetAllUsersErrorState(error.toString()));

          },
    );
  }
  bool? selectedValue;
  void changeUserIsQuitTypeState(bool selectedType){
    selectedValue = selectedType;
    // emit(AppAddProductChangeProductTypeState());
    emit(AppIsQuitChangeState());
  }

  void updateUserData({ bool? isQuitValue,String? userId}){
    emit(AppIsQuitChangeState());
    UserDataModel userDataModel = UserDataModel(
      userName:singleUserDataModel?.userName,
      email: singleUserDataModel?.email,
      password: singleUserDataModel?.password,
      phoneNumber: singleUserDataModel?.phoneNumber,
      image:singleUserDataModel?.image,
      relatedBranchID: singleUserDataModel?.relatedBranchID,
      uId: singleUserDataModel?.uId,
      isQuit:isQuitValue ?? singleUserDataModel?.isQuit ,
      isAdmin:singleUserDataModel?.isAdmin ,
        branch: singleUserDataModel?.branch,
    );


    FirebaseFirestore.instance.collection('users').doc(userId).update(userDataModel.toMap()
    ).then((value) {
      getUsers();
    }).catchError((error){});

  }

  List<CardModel> cardModelList=[];

  void getBranchCards(){
    cardModelList.clear();
    // emit(AppGetBranchCardsLoadingState());
    FirebaseFirestore.instance.collection('branches').doc(relatedBranchID)
        .collection("cards")
        .orderBy("filterByNum",descending: false)
        .get()
        .then((value) {
      for (var element in value.docs) {
        cardModelList.add(CardModel.fromJson(element.data()));


      }
      print(cardModelList.length);


      emit(AppGetBranchCardsSuccessState());

    }).catchError((error){
      print('Branch Error Data: ${error.toString()}');
      emit(AppGetBranchCardsErrorState(error.toString()));

    });

  }
  List<CardModel> singleBranchCardsModelList=[];

  void getSingleBranchCards({required String branchID}){
    singleBranchCardsModelList.clear();
    // emit(AppGetBranchCardsLoadingState());
    FirebaseFirestore.instance.collection('branches').doc(branchID).collection("cards").orderBy("filterByNum",descending: false)
        .get()
        .then((value) {
      for (var element in value.docs) {
        singleBranchCardsModelList.add(CardModel.fromJson(element.data()));


      }
      print(singleBranchCardsModelList.length);


      emit(AppGetSingleBranchCardsSuccessState());

    }).catchError((error){
      print('SingleBranch Error Data: ${error.toString()}');
      emit(AppGetSingleBranchCardsErrorState(error.toString()));

    });

  }

  void increaseCardQuantity({
    String? cardName,
    double? price,
    String? image,
    int? quantity,
    String? updatedAt,
    String? cardID,
    String? branchUID,
    String? updatedBy,
    int? maxQuantity,
    int? filterByNum,
  })
  {
    emit(AppIncreaseQuantitySuccessState());

    CardModel cardModel = CardModel(
      cardName: cardName,
      cardUID:cardID,
      price:price ,
      image:image ,
      quantity:quantity ,
      updatedAt: updatedAt,
      updatedBy: updatedBy,
      maxQuantity: maxQuantity,
      filterByNum: filterByNum
    );
    FirebaseFirestore.instance.collection('branches').doc(relatedBranchID).collection('cards').doc(cardID).update(cardModel.toMap()
    ).then((value) {

      getBranchCards();

      print('Icrease ;Done');
    }).catchError((error){
      print('increase Quantity Error: ${error.toString()}');
    });

  }


  void decreaseCardQuantity({
    String? cardName,
    double? price,
    String? image,
    int? quantity,
    String? updatedAt,
    String? cardID,
    String? branchUID,
    String? updatedBy,
    int? maxQuantity,
    int? filterByNum,

  }){
    emit(AppDecreaseQuantitySuccessState());

    CardModel cardModel = CardModel(

      cardName: cardName,
      cardUID:cardID,
      price:price ,
      image:image ,
      quantity:quantity ,
      updatedAt: updatedAt,
      updatedBy: updatedBy,
      maxQuantity: maxQuantity,
      filterByNum: filterByNum
    );


    FirebaseFirestore.instance.collection('branches').doc(relatedBranchID).collection('cards').doc(cardID).update(cardModel.toMap()
    ).then((value) {
      getBranchCards();
      print('Decrease Done');
    }).catchError((error){
      print('Decrease Quantity Error: ${error.toString()}');
    });

  }

  List<CardModel> cardModelListAdmin=[];

  void getBranchCardsAdminFunc({String? branchUID}){
    cardModelListAdmin.clear();
    // emit(AppGetBranchCardsLoadingState());
    FirebaseFirestore.instance.collection('branches').doc(branchUID)
        .collection("cards")
        .orderBy("filterByNum",descending: false)
        .get()
        .then((value) {
      for (var element in value.docs) {
        cardModelListAdmin.add(CardModel.fromJson(element.data()));


      }
      print('cardModelListAdmin Length: ${cardModelListAdmin.length}');


      emit(AppGetBranchCardsSuccessState());

    }).catchError((error){
      print(' Branch Data cardModelListAdmin Error Data: ${error.toString()}');
      emit(AppGetBranchCardsErrorState(error.toString()));

    });

  }
  void increaseCardQuantityAdminFunc({
    String? cardName,
    double? price,
    String? image,
    int? quantity,
    String? updatedAt,
    String? cardID,
    String? branchUID,
    String? updatedBy,
    int? maxQuantity,
    int? filterByNum,

  }){
    emit(AppIncreaseQuantitySuccessState());

    CardModel cardModel = CardModel(

        cardName: cardName,
        cardUID:cardID,
        price:price ,
        image:image ,
        quantity:quantity ,
        updatedAt: updatedAt,
        updatedBy: updatedBy,
      maxQuantity:maxQuantity,
        filterByNum: filterByNum
    );


    FirebaseFirestore.instance.collection('branches').doc(branchUID).collection('cards').doc(cardID).update(cardModel.toMap()
    ).then((value) {


      getSingleBranchCards(branchID: branchUID!);

      print('Icrease ;Done');
    }).catchError((error){
      print('increase Quantity Error: ${error.toString()}');
    });

  }


  void decreaseCardQuantityAdminFunc({
    String? cardName,
    double? price,
    String? image,
    int? quantity,
    String? updatedAt,
    String? cardID,
    String? branchUID,
    String? updatedBy,
    int?  maxQuantity,
    int?  filterByNum,
     }){
    emit(AppDecreaseQuantitySuccessState());

    CardModel cardModel = CardModel(

      cardName: cardName,
      cardUID:cardID,
      price:price ,
      image:image ,
      quantity:quantity ,
      updatedAt: updatedAt,
      updatedBy: updatedBy,
        maxQuantity:maxQuantity,
      filterByNum: filterByNum
    );


    FirebaseFirestore.instance.collection('branches').doc(branchUID).collection('cards').doc(cardID).update(cardModel.toMap()
    ).then((value) {
      getSingleBranchCards(branchID: branchUID!);
      print('Decrease Done');
    }).catchError((error){
      print('Decrease Quantity Error: ${error.toString()}');
    });

  }
  BranchesModel? branchesModel;

  void getBranchData(){

    emit(AppGetBranchDataLoadingState());
    FirebaseFirestore.instance.collection('branches').doc('XiDb621YfWhgOjMRm1rx')
        .get()
        .then((value) {
      branchesModel = BranchesModel.fromJson(value.data()!);
      // for (var element in value.docs) {
      //   if(element.data()['relatedUsers'] ==userModel?.relatedBranchID) {
      //     cardModelList.add(CardModel.fromJson(element.data()));
      //   }
      // }
      print(branchesModel?.branchName);
      print(branchesModel?.relatedUsers?[0]);

      emit(AppGetBranchDataSuccessState());

    }).catchError((error){
      print('Branch Error Data: ${error.toString()}');
      emit(AppGetBranchDataErrorState(error.toString()));

    });

  }

  BranchesModel? singleBranchModel;
String? newCardSelectedBranchName ;
  void getSingleBranchData({required String singleBranchUID}){

    emit(AppGetSingleBranchDataLoadingState());
    FirebaseFirestore.instance.collection('branches').doc(singleBranchUID)
        .get()
        .then((value) {
      singleBranchModel = BranchesModel.fromJson(value.data()!);
      // for (var element in value.docs) {
      //   if(element.data()['relatedUsers'] ==userModel?.relatedBranchID) {
      //     cardModelList.add(CardModel.fromJson(element.data()));
      //   }
      // }
      newCardSelectedBranchName = singleBranchModel!.branchName!;
      selectedNewCardBranchUID = singleBranchModel!.branchUID!;

      print(newCardSelectedBranchName);
      print(singleBranchModel?.branchName);
      print(singleBranchModel?.branchUID);
      emit(AppGetSingleBranchDataSuccessState());

    }).catchError((error){
      print('Branch Error Data: ${error.toString()}');
      emit(AppGetSingleBranchDataErrorState(error.toString()));

    });

  }
  String? selectedBranchUID;
  String? selectedBranchName;
  void changeSelectedBranchUIDState(String selectedType){
    selectedBranchUID = selectedType;
    // emit(AppAddProductChangeProductCategoreyState());
    emit(AppSelectedBranchUIDChangeState());
  }
  String? selectedNewCardBranchUID;
  void changeNewCardSelectedBranchUIDState(String selectedType){
    selectedNewCardBranchUID = selectedType;
    // emit(AppAddProductChangeProductCategoreyState());
    emit(AppNewCardSelectedBranchUIDChangeState());
  }

  String? newCardUID;
  void addNewCard({
    required String cardName,
    required dynamic price,
    required dynamic quantity,
    required dynamic maxQuantity,
    required String selectedBranchID,
    required int filterByNum,
  }){
    emit(AppAddNewCardLoadingState());

    FirebaseFirestore.instance.collection('branches').doc(selectedNewCardBranchUID).collection('cards').add({
      'cardName':cardName,
      'price':price,
      'quantity':quantity,
      'maxQuantity':maxQuantity,
      'image':'assets/images/orange7.jpg',
      'updatedAt':'2022-09-27 18:40:133',
      'updatedBy':'Admin',
      'cardUID':'',
      'filterByNum':filterByNum,

    })
        .then((value) {
          print('valueUID :${value.id}');
          newCardUID = value.id;

          updateNewCardUID(value.id);

          emit(AppAddNewCardSuccessState());

    })
        .catchError((error){
      print(error.toString());
      emit(AppAddNewCardErrorState(error.toString()));
    });
  }
  void updateNewCardUID(String? valueID){
    FirebaseFirestore.instance.collection('branches').doc(selectedNewCardBranchUID).collection('cards').doc(valueID).update(
        {
          'cardUID':valueID
        }).then((value) {

          print('updated Done');
    }).catchError((error){
          print('UpdatedNewcardId Error: ${error.toString()}');
    });
  }

  List<BranchesModel> branchesModelList = [];

  void getBranchesData(){

    emit(AppGetBranchesDataLoadingState());
    FirebaseFirestore.instance.collection('branches').orderBy('branchName',descending: false)
        .get()
        .then((value) {

      for (var element in value.docs) {
        branchesModelList.add(BranchesModel.fromJson(element.data()));

      }

      print(branchesModelList[0].branchName);
      print(branchesModelList[0].relatedUsers?[0]);

      emit(AppGetBranchesDataSuccessState());

    }).catchError((error){
      print('Branches Error Data: ${error.toString()}');
      emit(AppGetBranchesDataErrorState(error.toString()));

    });

  }

  void backToAppLayout({required int bottomNavIndex,required BuildContext context}){

    navigateAndFinish(context, AppLayout());
    Future.delayed(Duration(seconds: 3),(){ChangeBottomNav(bottomNavIndex);});

    print(bottomNavIndex);

    emit(AppBackToLayoutChangeState());
  }



//   File profileImage;
//   final picker = ImagePicker();
//   Future<void> getProfileImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//     if(pickedFile != null) {
//       profileImage = File(pickedFile.path);
//       print(pickedFile.path);
//       emit(SocialProfileImagePickedSuccessState());
//
//     }else{
//       print('No Image Selected');
//       emit(SocialProfileImagePickedErrorState());
//     }
//   }
//
//   File coverImage;
//   Future<void> getCoverImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//     if(pickedFile != null) {
//      coverImage = File(pickedFile.path);
//      print(pickedFile.path);
//       emit(SocialCoverImagePickedSuccessState());
//
//
//     }else{
//       print('No Image Selected');
//       emit(SocialCoverImagePickedErrorState());
//     }
//   }
//
//
//   void upLoadProfileImage(){
//     emit(SocialUploadProfileImageLoadingState());
//     firebase_storage.FirebaseStorage.instance
//         .ref()
//         .child('users/${Uri.file(profileImage.path).pathSegments.last}').putFile(profileImage)
//         .then((value) {
//           value.ref.getDownloadURL()
//               .then((value) {
//             emit(SocialUploadProfileImageSuccessState());
//
//
//                 print(value);
//                 // updateUploadUserProfileImage(
//                 //   image: value,
//                 // );
//                 updateUser(
//
//                   image: value,
//
//                 );
//
//           })
//               .catchError((error){
//                 emit(SocialUploadProfileImageErrorState());
//           });
//     })
//         .catchError((error){
//       emit(SocialUploadProfileImageErrorState());
//     });
//   }
//
//
//
//
//
//   void updateUser({
//
//     String cover,
//     String image,
//   }){
//
//
//     SocialCreateUserModel model = SocialCreateUserModel(
//       name: userModel.name,
//       phone: userModel.phone,
//       email: userModel.email,
//       password: userModel.password,
//       image: image??userModel.image,
//       cover: cover??userModel.cover,
//       bio: userModel.bio,
//       uId: userModel.uId,
//
//       isUserAdmin: true,);
//     FirebaseFirestore.instance.collection('users').doc(userModel.uId).update(model.toMap())
//         .then((value) {
//
//       getUserData();
//     })
//         .catchError((error){
//       emit(SocialUserUpdateErrorState());
//     });
//   }
//
//   void upLoadCoverImage(){
//     emit(SocialUploadCoverImageLoadingState());
//
//     firebase_storage.FirebaseStorage.instance
//         .ref()
//         .child('users/${Uri.file(coverImage.path).pathSegments.last}').putFile(coverImage)
//         .then((value) {
//           value.ref.getDownloadURL()
//               .then((value) {
//                 emit(SocialUploadCoverImageSuccessState());
//
//                 print(value);
//                 updateUser(
//
//                   cover: value,
//
//                 );
//
//           })
//               .catchError((error){
//                 emit(SocialUploadCoverImageErrorState());
//           });
//     })
//         .catchError((error){
//       emit(SocialUploadCoverImageErrorState());
//     });
//   }
//
//   void updateUserInfo({
//     @required String name,
//     @required String phone,
//     @required String password,
//     @required String bio,
//
//
//     String cover,
//     String image,
//   }){
//
//
//     SocialCreateUserModel model = SocialCreateUserModel(
//       name: name,
//       phone: phone,
//       email: userModel.email,
//       password: password,
//       image: image??userModel.image,
//       cover: cover??userModel.cover,
//       bio: bio,
//       uId: userModel.uId,
//
//       isUserAdmin: true,);
//     FirebaseFirestore.instance.collection('users').doc(userModel.uId).update(model.toMap())
//         .then((value) {
//
//       getUserData();
//     })
//         .catchError((error){
//       emit(SocialUserUpdateErrorState());
//     });
//   }
//
//
//   File postImage;
//   Future<void> getPostImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//     if(pickedFile != null) {
//       postImage = File(pickedFile.path);
//       print(pickedFile.path);
//       emit(SocialPostImagePickedSuccessState());
//
//
//     }else{
//       print('No Image Selected');
//       emit(SocialPostImagePickedErrorState());
//     }
//   }
//   void removePostImage(){
//
//     postImage=null;
//     emit(SocialRemovePostImageErrorState());
//   }
//
//   void uploadPostImage({
//
//   @required String dateTime,
//   @required String text,
// }){
//     emit(SocialCreatePostLoadingState());
//     firebase_storage.FirebaseStorage.instance
//         .ref()
//         .child('posts/${Uri.file(postImage.path).pathSegments.last}')
//         .putFile(postImage)
//         .then((value) {
//       value.ref.getDownloadURL()
//           .then((value) {
//         //
//         createPost(
//           text: text,
//           postImage: value,
//           dateTime: dateTime
//         );
//
//
//         print(value);
//
//       })
//           .catchError((error){
//         emit(SocialCreatePostErrorState());
//       });
//     })
//         .catchError((error){
//       emit(SocialCreatePostErrorState());
//     });
//   }
//
//   void createPost({
//
//     @required String dateTime,
//     @required String text,
//     String postImage,
//   }){
//     emit(SocialCreatePostLoadingState());
//     PostModel model = PostModel(
//       name: userModel.name,
//       image: userModel.image,
//       dateTime: dateTime,
//       text: text,
//       uId: userModel.uId,
//
//       postImage: postImage??'',
//
//
//
//       );
//     FirebaseFirestore.instance
//         .collection('posts')
//         .add(model.toMap())
//         .then((value) {
//       emit(SocialCreatePostSuccessState());
//
//
//     })
//         .catchError((error){
//       emit(SocialCreatePostErrorState());
//     });
//   }
//   List<PostModel> posts=[];
//   List<String> postsId=[];
//   List<int> likesNumbers=[];
//   List<int> commentNumbers=[];
//   void getPosts() {
//     emit(SocialGetPostLoadingStates());
//
//      FirebaseFirestore.instance.collection('posts').orderBy('dateTime',descending: false).get().then((value) {
//       value.docs.forEach((element) {
//         element.reference.collection('comments').get().then((value) {
//           comment.add(value.docs.length);
//         });
//         element.reference.collection('likes').get().then((value) {
//
//           likesNumbers.add(value.docs.length);
//           postsId.add(element.id);
//           posts.add(PostModel.fromJson(element.data()));
//           emit(SocialGetPostSuccessStates());
//
//         }).catchError((error){});
//       });
//
//       emit(SocialGetPostSuccessStates());
//     }).catchError(
//           (error) {
//         print('error << $error >>');
//         emit(SocialGetPostErrorStates());
//       },
//     );
//   }
//   void likePost(String postId){
//     FirebaseFirestore.instance
//         .collection('posts')
//         .doc(postId)
//         .collection('likes')
//         .doc(userModel.uId)
//         .set({'like':true})
//         .then((value) {
//           emit(SocialLikePostSuccessState());
//     })
//         .catchError((error){
//       emit(SocialLikePostErrorState(error.toString()));
//
//     });
//
//
//   }
// List<SocialCreateUserModel> users;
//   void getUsers(){
//     users=[];
//     // emit(SocialGetPostLoadingStates());
//     FirebaseFirestore.instance.collection('users').get().then((value) {
//
//       value.docs.forEach((element) {
//         if(element.data()['uId']!=userModel.uId)
//
//         users.add(SocialCreateUserModel.fromJson(element.data()));
//       });
//       emit(SocialGetAllUserSuccessState());
//     })
// .catchError(
//           (error) {
//         print('error << $error >>');
//         emit(SocialGetAllUserErrorState(error.toString()));
//
//           },
//     );
//   }
//
// PostModel postModel;
//   void setCommentPost({
//     String uIdComment,
//     @required String textComment,
//     String imageComment,
//     String postId,
//     String dateTime,
//   }){
//     emit(SocialCommentPostLoadingState());
//     CommentModel commentModel = CommentModel(
//       dateTime: dateTime,
//       name: userModel.name,
//       textComment: textComment,
//       image: userModel.image,
//       uId: userModel.uId,
//       imageComment: imageComment,
//       postId: postId,
//
//     );
//     FirebaseFirestore.instance
//           .collection('posts')
//           .doc(uIdComment)
//     .collection('comments')
//     .add(commentModel.toMapComment())
//           .then((value) {
//
//
//         emit(SocialCommentPostSuccessState());
//       })
//           .catchError((error){
//         emit(SocialCommentPostErrorState(error.toString()));
//
//       });
//   }
//   File createCommentImage;
//   final createCommentPicker= ImagePicker();
//   Future<void> getCommentImage() async {
//     final pickedFile = await createCommentPicker.getImage(source: ImageSource.gallery);
//     if(pickedFile != null) {
//       createCommentImage = File(pickedFile.path);
//       print(pickedFile.path);
//       emit(SocialCreateCommentImageSuccessState());
//
//     }else{
//       print('No Image Selected');
//       emit(SocialCreateCommentImageErrorState());
//     }
//   }
//
//   void uploadImageComment(
//   {
//   @required String textComment,
//     @required String uIdComment,
//     String imageComment,
//     String dateTime,
//
//     String postId,})
//   {
//     firebase_storage.FirebaseStorage.instance.ref().child('Comments/${Uri.file(createCommentImage.path).pathSegments.last}').putFile(createCommentImage)
//         .then((value) {
//           print(value);
//           value.ref.getDownloadURL().then((value){
//             setCommentPost(
//               dateTime: dateTime,
//                 textComment: textComment,
//             uIdComment: uIdComment,
//             imageComment: value,
//             postId: postId);
//             emit(SocialUploadCommentCoverImageSuccessStates());
//
//
//           }).catchError((error){
//             emit(SocialUploadCommentCoverImageSuccessStates());
//
//
//           });
//
//     }).catchError((error){
//       print(error.toString());
//       emit(SocialUploadCommentCoverImageSuccessStates());
//     });
//
//   }
// CommentModel commentModel;
//   List<CommentModel> commentModelAdd = [];
//   List<String> postsIdCom = [];
//   List<int> comment = [];
//   void getComent({String userId,}){
//
//     // emit(SocialGetCommentLoadingStates());
//      FirebaseFirestore.instance.collection('posts').get().then((value) {
//       value.docs.forEach((element) {
//         element.reference.collection('comments').orderBy('dateTime',descending: false).snapshots().listen((event) {
//           commentModelAdd = [];
//           // comment.add(value.docs.length);
//           postsIdCom.add(element.id);
//           for(var values in event.docs)
//
//           commentModelAdd.add(CommentModel.fromJson(values.data()));
//         });
//       });
//       emit(SocialGetCommentSuccessStates());
//         }).catchError((error){
//           print(error.toString());
//           emit(SocialGetCommentErrorStates());
//     });
//       }
//
//







  }
