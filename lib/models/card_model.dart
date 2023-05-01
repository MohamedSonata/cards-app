class CardModel {
  String? cardName;
  String? image;
  dynamic price;
  int? quantity;
  int? maxQuantity;
  String? updatedAt;
  String? updatedBy;
  String? cardUID;
  int? filterByNum;

  CardModel({this.cardName,this.image,this.price,this.quantity,this.updatedAt,this.cardUID,this.updatedBy,this.maxQuantity,this.filterByNum});

  CardModel.fromJson(Map<String,dynamic> json){
    cardName = json['cardName'];
    image = json['image'];
    price = json['price'];
    quantity = json['quantity'];
    cardUID = json['cardUID'];
    updatedAt = json['updatedAt'];
    updatedBy = json['updatedBy'];
    maxQuantity = json['maxQuantity'];
    filterByNum = json['filterByNum'];
  }
  Map<String,dynamic> toMap(){
    return {
      'cardName':cardName,
      'image':image,
      'price':price,
      'cardUID':cardUID,
      'quantity':quantity,
      'updatedAt':updatedAt,
      'updatedBy':updatedBy,
      'maxQuantity':maxQuantity,
      'filterByNum':filterByNum,

    };

  }
}