// To parse this JSON data, do
//
//     final payementModel = payementModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digirental_user_app/Models/user_model.dart';

NotificationModel payementModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String payementModelToJson(NotificationModel data) =>
    json.encode(data.toJson(data.notificationID.toString()));

class NotificationModel {
  NotificationModel(
      {this.userId,
      this.user,
      this.notificationTitle,
      this.notificationBody,
      this.notificationID,
      this.notificationDate

      //   this.paymentDate,
      });

  String? userId;
  UserModel? user;
  String? notificationTitle;
  String? notificationBody;

  String? notificationID;

  Timestamp? notificationDate;

  // Timestamp? paymentDate;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        userId: json["userID"],
        user: UserModel.fromJson(json["user"]),

        notificationID: json["notificationID"],
        notificationTitle: json["notificationTitle"],
        notificationBody: json["notificationBody"],

        notificationDate: json["notificationDate"],
        //  paymentDate: json["paymentDate"],
      );

  Map<String, dynamic> toJson(String docID) => {
        "userID": userId,
        "user": user!.toJson(docID),
        "notificationTitle": notificationTitle,
        "notificationBody": notificationBody,

        "notificationID": docID,

        "notificationDate": notificationDate,
        // "paymentDate": paymentDate,
      };
}
