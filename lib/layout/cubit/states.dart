


import 'package:cardsapp/models/user_data_model.dart';

abstract class AppCubitStates {}
class AppInitialState extends AppCubitStates{}

///######################### User Register States
class AppRegisterLoadingState extends AppCubitStates{}

class AppRegisterErrorState extends AppCubitStates{
  final String error;

  AppRegisterErrorState(this.error);
}

class AppCreateUserSuccessState extends AppCubitStates{}

class AppCreateUserErorrstate extends AppCubitStates{
  final String error;

  AppCreateUserErorrstate(this.error);
}
/// ##########################################################

class AppGetUserDataSuccessState extends AppCubitStates{}

class AppGetUserDataLoadingState extends AppCubitStates{}

class AppGetUserDataErrorState extends AppCubitStates{
  final String error;

  AppGetUserDataErrorState(this.error);

}
class AppGetSingleUserDataLoadingState extends AppCubitStates{}

class AppGetSingleUserDataSuccessState extends AppCubitStates{
  final UserDataModel userDataModel;

  AppGetSingleUserDataSuccessState(this.userDataModel);
}

class AppGetSingleUserDataErrorState extends AppCubitStates{
  final String error;

  AppGetSingleUserDataErrorState(this.error);

}
class AppChangeBottomNavState extends AppCubitStates{}

class AppGetAllUsersLoadingState extends AppCubitStates{}

class AppGetAllUsersSuccessState extends AppCubitStates{}

class AppGetAllUsersErrorState extends AppCubitStates{
  final String error;

  AppGetAllUsersErrorState(this.error);

}

class AppAddNewCardLoadingState extends AppCubitStates{}

class AppAddNewCardSuccessState extends AppCubitStates{}

class AppAddNewCardErrorState extends AppCubitStates{
  final String error;

  AppAddNewCardErrorState(this.error);

}

class AppGetBranchCardsLoadingState extends AppCubitStates{}

class AppGetBranchCardsSuccessState extends AppCubitStates{}

class AppGetBranchCardsErrorState extends AppCubitStates{
  final String error;

  AppGetBranchCardsErrorState(this.error);

}

class AppGetSingleBranchCardsLoadingState extends AppCubitStates{}

class AppGetSingleBranchCardsSuccessState extends AppCubitStates{}

class AppGetSingleBranchCardsErrorState extends AppCubitStates{
  final String error;

  AppGetSingleBranchCardsErrorState(this.error);

}

class AppIncreaseQuantitySuccessState extends AppCubitStates{}
class AppDecreaseQuantitySuccessState extends AppCubitStates{}


class AppGetBranchDataLoadingState extends AppCubitStates{}

class AppGetBranchDataSuccessState extends AppCubitStates{}

class AppGetBranchDataErrorState extends AppCubitStates{
  final String error;

  AppGetBranchDataErrorState(this.error);

}

class AppGetSingleBranchDataLoadingState extends AppCubitStates{}

class AppGetSingleBranchDataSuccessState extends AppCubitStates{}

class AppGetSingleBranchDataErrorState extends AppCubitStates{
  final String error;

  AppGetSingleBranchDataErrorState(this.error);

}


class AppGetBranchesDataLoadingState extends AppCubitStates{}

class AppGetBranchesDataSuccessState extends AppCubitStates{}

class AppGetBranchesDataErrorState extends AppCubitStates{
  final String error;

  AppGetBranchesDataErrorState(this.error);

}

class AppIsQuitChangeState extends AppCubitStates{}

class AppRegisterFormChangeState extends AppCubitStates{}

class AppBackToLayoutChangeState extends AppCubitStates{}

class AppSelectedBranchUIDChangeState extends AppCubitStates{}

class AppNewCardSelectedBranchUIDChangeState extends AppCubitStates{}

class AppcheckInternetConnectionSuccessState extends AppCubitStates{}
class AppcheckInternetConnectionErrorState extends AppCubitStates{}

class AppCheckIsAppWorkingLoadingState extends AppCubitStates{}

class AppCheckIsAppWorkingSuccessState extends AppCubitStates{}

class AppCheckIsAppWorkingErrorState extends AppCubitStates{
  final String error;

  AppCheckIsAppWorkingErrorState(this.error);

}






