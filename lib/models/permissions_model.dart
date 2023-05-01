class PermissionsModel{
  bool? isAppWorking;
  PermissionsModel({this.isAppWorking});
  PermissionsModel.fromJson(Map<String,dynamic> json){
    isAppWorking = json['isAppWorking'];

  }
}