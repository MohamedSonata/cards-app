


import '../../models/user_data_model.dart';

abstract class AppLoginStates {}
class AppLogininitialstate extends AppLoginStates{}

class AppLoginLoadingstate extends AppLoginStates{}

class AppLoginSuccessState extends AppLoginStates {
  final String uId;

  AppLoginSuccessState(this.uId);

}

class AppLoginErorrstate extends AppLoginStates{
  final String error;

  AppLoginErorrstate(this.error);
}
class AppLChangePasswordVisibilitystate extends AppLoginStates{}


