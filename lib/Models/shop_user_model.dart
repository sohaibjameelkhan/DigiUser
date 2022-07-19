// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

ShopUserModel userModelFromJson(String str) => ShopUserModel.fromJson(json.decode(str));

String userModelToJson(ShopUserModel data) => json.encode(data.docId.toString());

class ShopUserModel {
  ShopUserModel(
      {this.userID,
        this.docId,
        this.fullName,
        this.userEmail,
        this.isapprove,
        this.userImage,
        this.password,
        this.PhoneNumber,
      this.shopStatus
      });

  String? userID;
  String? docId;
  String? fullName;
  String? userEmail;
  bool? isapprove;
  String? userImage;
  String? password;
  String? PhoneNumber;
  String? shopStatus;

  factory ShopUserModel.fromJson(Map<String, dynamic> json) => ShopUserModel(
    userID: json["userID"],
    docId: json["docID"],
    fullName: json["fullName"],
    userEmail: json["userEmail"],
    isapprove: json["isapprove"],
    userImage: json["userImage"],
    password: json["password"],
    PhoneNumber: json["PhoneNumber"],
    shopStatus: json["shopStatus"],
  );

  Map<String, dynamic> toJson(String docID) => {
    "userID": userID,
    "docID": docID,
    "fullName": fullName,
    "userEmail": userEmail,
    "isapprove": isapprove,
    "userImage": userImage,
    "password": password,
    "PhoneNumber": PhoneNumber,
    "shopStatus": shopStatus,
  };
}
