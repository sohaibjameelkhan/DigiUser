import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digirental_user_app/Models/notification_model.dart';

import '../Models/Review_Model.dart';

class NotificationServices {
  ///Create Notificaion
  Future createNotification(NotificationModel notificationModel) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection("NotificationCollection").doc();
    return await docRef.set(notificationModel.toJson(docRef.id));
  }

  ///Stream Notifications
  Stream<List<NotificationModel>> streamNotifications(String myId) {
    return FirebaseFirestore.instance
        .collection('NotificationCollection')
        .where('ownerID', isEqualTo: myId)
        .snapshots()
        .map((list) => list.docs
            .map((singleDoc) => NotificationModel.fromJson(singleDoc.data()))
            .toList());
  }

  ///Stream Reviews
  Stream<List<ReviewModel>> streamShopReviewstHistory(String ownerId) {
    return FirebaseFirestore.instance
        .collection('ReviewsCollection')
        .where("ownerID", isEqualTo: ownerId)
        .snapshots()
        .map((list) => list.docs
            .map((singleDoc) => ReviewModel.fromJson(singleDoc.data()))
            .toList());
  }
}
