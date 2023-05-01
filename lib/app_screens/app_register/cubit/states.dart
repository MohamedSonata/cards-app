

abstract class AppRegisterStates {}
class AppRegisterinitialstate extends AppRegisterStates{}

class AppRegisterLoadingstate extends AppRegisterStates{}

class AppRegisterSuccessState extends AppRegisterStates {}

class AppRegisterErorrstate extends AppRegisterStates{
  final String error;


  AppRegisterErorrstate(this.error,);


}


class AppCreateUserSuccessState extends AppRegisterStates {}

class AppCreateUserErorrstate extends AppRegisterStates{
  final String error;


  AppCreateUserErorrstate(this.error,);


}
class AppRegisterChangePasswordVisibilityState extends AppRegisterStates{}
