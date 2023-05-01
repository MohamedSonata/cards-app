class BranchesModel {
  String? branchName;
  String? branchUID;
  List<dynamic>? relatedUsers;

  BranchesModel({this.branchName,this.relatedUsers,this.branchUID});

BranchesModel.fromJson(Map<String,dynamic> json){
  branchName = json['branchName'];
  relatedUsers = json['relatedUsers'];
  branchUID = json['branchUID'];
 }
 Map<String,dynamic> toMap(){
  return {
    'branchName':branchName,
    'branchUID':branchUID,
    'relatedUsers':relatedUsers,

  };

}
}