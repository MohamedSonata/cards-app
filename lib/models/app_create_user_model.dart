class AppUserCreateModel{
  String? userName;
  String? email;
  String? phoneNumber;
  String? password;
  String? uId;
  String? image;
  String? relatedBranchID;
  String? branch;
  bool? isAdmin;
  bool? isQuit;

  AppUserCreateModel({
    this.userName,
    this.email,
    this.phoneNumber,
    this.password,
    this.uId,
    this.isAdmin,
    this.image,
    this.branch,
    this.relatedBranchID,
  this.isQuit
  });

  AppUserCreateModel.fromJson(Map<String, dynamic> json){

    userName = json['userName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
    uId = json['uId'];
    image = json['image'];
    isAdmin = json['isAdmin'];
    branch = json['branch'];
    relatedBranchID = json['relatedBranchID'];
    isQuit = json['isQuit'];

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