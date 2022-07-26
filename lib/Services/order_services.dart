import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/order_model.dart';


class OrderServices {
  ///Place Order
  Future placeOrder(OrderModel orderModel) async {
    DocumentReference _docRef =
        FirebaseFirestore.instance.collection('orderCollection').doc();
    return await _docRef.set(orderModel.toJson(
      userID: orderModel.user!.docId.toString(),
      orderID: _docRef.id.toString(),
    ));
  }

  ///Fetch Order Detail
  Stream<OrderModel> fetchOrderDetails() {
    return FirebaseFirestore.instance
        .collection("orderCollection")
        .doc()
        .snapshots()
        .map((userData) => OrderModel.fromJson(userData.data()!));
  }

  ///Get My Orders
  Stream<List<OrderModel>> streamMyOrders(String myID) {
    print(myID);
    return FirebaseFirestore.instance
        .collection('orderCollection')
        .where('user.docID', isEqualTo: myID)
        .snapshots()
        .map((list) => list.docs
            .map((singleDoc) => OrderModel.fromJson(singleDoc.data()))
            .toList());
  }

  ///Get My Processed Orders

  Stream<List<OrderModel>> streamMyProcessedOrders(String myID) {
    return FirebaseFirestore.instance
        .collection('orderCollection')
        .where('user.docID', isEqualTo: myID)
        .where('isProcessed', isEqualTo: true)
        .snapshots()
        .map((list) => list.docs
            .map((singleDoc) => OrderModel.fromJson(singleDoc.data()))
            .toList());
  }

  ///Get My Completed Orders

  Stream<List<OrderModel>> streamMyCompletedOrders(String myID) {
    return FirebaseFirestore.instance
        .collection('orderCollection')
        .where('user.docID', isEqualTo: myID)
        .where('isCompleted', isEqualTo: true)
        .snapshots()
        .map((list) => list.docs
            .map((singleDoc) => OrderModel.fromJson(singleDoc.data()))
            .toList());
  }

  ///Get My Pending Orders

  Stream<List<OrderModel>> streamMyPendingOrders(String myID) {
    return FirebaseFirestore.instance
        .collection('orderCollection')
        .where('user.docID', isEqualTo: myID)
        .where('isPending', isEqualTo: true)
        .snapshots()
        .map((list) => list.docs
            .map((singleDoc) => OrderModel.fromJson(singleDoc.data()))
            .toList());
  }

  ///Get My Cancelled Orders

  Stream<List<OrderModel>> streamMyCancelledOrders(String myID) {
    return FirebaseFirestore.instance
        .collection('orderCollection')
        .where('user.docID', isEqualTo: myID)
        .where('isCancelled', isEqualTo: true)
        .snapshots()
        .map((list) => list.docs
            .map((singleDoc) => OrderModel.fromJson(singleDoc.data()))
            .toList());
  }
}
