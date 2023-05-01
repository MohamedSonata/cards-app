class UserDataModel{
  String? userName;
  String? email;
  String? password;
  String? phoneNumber;
  String? image;
  String? relatedBranchID;
  String? branch;
  bool? isAdmin;
  bool? isQuit;
  String? uId;

  UserDataModel({this.userName,this.email,this.password,this.phoneNumber,this.image,this.relatedBranchID,this.branch,this.isAdmin,this.isQuit,this.uId});
  UserDataModel.fromJson(Map<String,dynamic>json){
    userName = json['userName'];
    email = json['email'];
    password = json['password'];
    phoneNumber = json['phoneNumber'];
    branch = json['branch'];
    isAdmin = json['isAdmin'];
    isQuit = json['isQuit'];
    image = json['image'];
    relatedBranchID = json['relatedBranchID'];
    uId = json['uId'];
  }
  Map<String, dynamic> toMap() {
    return {
      'userName':userName,
      'email':email,
      'phoneNumber':phoneNumber,
      'password':password,
      'uId':uId,
      'image':image,
      'isAdmin':isAdmin,
      'branch':branch,
      'relatedBranchID':relatedBranchID,
      'isQuit':isQuit,


    };
  }
}