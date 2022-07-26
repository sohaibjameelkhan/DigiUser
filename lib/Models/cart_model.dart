



import 'package:digirental_user_app/Models/product_Model.dart';

class CartModel {
  String? uID;
  num? quantity;
  num? totalPrice;
  num? sortTime;
  String? docID;
  ProductModel? productDetails;

  CartModel({
    this.quantity,
    this.totalPrice,
    this.sortTime,
    this.docID,
    this.uID,
    this.productDetails,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    totalPrice = json['totalPrice'];
    sortTime = json['sortTime'];
    docID = json['docID'];
    uID = json['uID'];
    productDetails = json['productDetails'] != null
        ? new ProductModel.fromJson(json['productDetails'])
        : null;
  }

  Map<String, dynamic> toJson(String docID) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantity'] = this.quantity;
    data['totalPrice'] = this.totalPrice;
    data['sortTime'] = this.sortTime;
    data['uID'] = this.uID;
    data['docID'] = docID;
    if (this.productDetails != null) {
      data['productDetails'] =
          this.productDetails!.toJson(productDetails!.productId.toString());
    }

    return data;
  }
}
