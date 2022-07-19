import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digirental_user_app/Models/notification_model.dart';
import 'package:digirental_user_app/Services/notification_services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Helpers/BottomNavBar.dart';
import '../../../Helpers/helper.dart';
import '../../../Helpers/order_helper.dart';
import '../../../Models/cart_model.dart';
import '../../../Models/order_model.dart';
import '../../../Models/payement_Model.dart';
import '../../../Providers/cart_provider.dart';
import '../../../Services/cart_services.dart';
import '../../../Services/order_services.dart';
import '../../../Services/payement_services.dart';
import '../../../Tesing/stripe_payment_testing.dart';
import '../../../Utils/Colors.dart';
import '../../../res.dart';
import '../../Widgets/appbutton.dart';
import 'package:http/http.dart' as http;

import '../ChatSection/user_provider.dart';
import '../PushNotificationSection/notification_handler.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  CartServices _cartServices = CartServices();
  OrderServices _orderServices = OrderServices();
  PayementServices _payementServices = PayementServices();
  Map<String, dynamic>? paymentIntentData;
  NotificationServices notificationServices = NotificationServices();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context);
    var cartData = Provider.of<CartProvider>(context);

    print("User" + user.getUserDetails()!.userID.toString());
    return StreamProvider.value(
        value: _orderServices.fetchOrderDetails(),
        initialData: OrderModel(),
        builder: (context, child) {
          OrderModel ordermodel = context.watch<OrderModel>();
          // List<OrderModel> _orderList = context.watch<List<OrderModel>>();
          return StreamProvider.value(
              value: _cartServices.streamCartList(context),
              initialData: [CartModel()],
              builder: (context, child) {
                List<CartModel> _cartList = context.watch<List<CartModel>>();
                return Scaffold(
                  bottomNavigationBar: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      AppButton(
                        onTap: () async {
                          await makePayment(OrderModel(
                              cart: _cartList,
                              user: user.getUserDetails(),
                              totalBill:
                                  OrderHelper.orderPriceCalculator(context),
                              adminID: _cartList[0]
                                  .productDetails!
                                  .UserId
                                  .toString()));
                          // await OrderServices()
                          //     .placeOrder()
                          //     .then((value) async {
                          //   cartData.emptyMyLocalCart();
                          //   _cartList
                          //       .map((e) => _cartServices.emptyMyCart(
                          //           docID: e.docID.toString(),
                          //           userID: user
                          //               .getUserDetails()!
                          //               .docId
                          //               .toString()))
                          //       .toList();
                          // }).catchError((e) {
                          //   print("Error occurred!");
                          // }).whenComplete(() {
                          //   Get.to(Bottomnavigation());
                          // });
                        },
                        containerheight: 55,
                        text: "Place Order",
                      ),
                      SizedBox(
                        height: 15,
                      )
                    ],
                  ),
                  body: Column(
                    children: [
                      SizedBox(
                        height: 45,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                child: Center(
                                    child:
                                        SvgPicture.asset(Res.arrowbackgreen)),
                              ),
                            ),
                            SizedBox(
                              width: 60,
                            ),
                            Text("Order Summary",
                                style: GoogleFonts.roboto(
                                    // fontFamily: 'Gilroy',
                                    color: MyAppColors.blackcolor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Total Bill : ",
                              style: GoogleFonts.roboto(
                                  // fontFamily: 'Gilroy',
                                  color: MyAppColors.blackcolor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16)),
                          Text(
                              "\$" +
                                  OrderHelper.orderPriceCalculator(context)
                                      .toString(),
                              style: GoogleFonts.roboto(
                                  // fontFamily: 'Gilroy',
                                  color: MyAppColors.blackcolor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17)),
                        ],
                      ),
                      // ElevatedButton(
                      //   onPressed: () async {
                      //  Get.to(HomeScreen());
                      //   },
                      //   child: Center(child: Text("Place Order"),),
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          height: 530,
                          width: double.infinity,
                          child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(),
                              // scrollDirection: Axis.horizontal,
                              // physics: const NeverScrollableScrollPhysics(),
                              itemCount: _cartList.length,
                              itemBuilder: (_, i) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        // BoxShadow(
                                        //   color: Colors.grey.withOpacity(0.5),
                                        //   spreadRadius: 5,
                                        //   blurRadius: 7,
                                        //   offset: Offset(0,
                                        //       3), // changes position of shadow
                                        // ),
                                      ],
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    height: 120,
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  CachedNetworkImage(
                                                      height: 80,
                                                      width: 80,
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                            width: 50.0,
                                                            height: 55.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          13),
                                                              image: DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover),
                                                            ),
                                                          ),
                                                      imageUrl: _cartList[i]
                                                          .productDetails!
                                                          .productImage
                                                          .toString(),
                                                      fit: BoxFit.cover,
                                                      progressIndicatorBuilder: (context,
                                                              url,
                                                              downloadProgress) =>
                                                          SpinKitWave(
                                                              color: MyAppColors
                                                                  .appColor,
                                                              type:
                                                                  SpinKitWaveType
                                                                      .start),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error)),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          _cartList[i]
                                                              .productDetails!
                                                              .productName
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  // fontFamily: 'Gilroy',
                                                                  color: MyAppColors
                                                                      .blackcolor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      18)),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                          "\$" +
                                                              _cartList[i]
                                                                  .productDetails!
                                                                  .productPrice
                                                                  .toString(),
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  // fontFamily: 'Gilroy',
                                                                  color: MyAppColors
                                                                      .blackcolor
                                                                      .withOpacity(
                                                                          0.6),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      15)),
                                                      Row(
                                                        children: [
                                                          // IconButton(
                                                          //     onPressed: () {
                                                          //       // if (_cartList[i]
                                                          //       //         .productDetails!
                                                          //       //         .productPrice! >
                                                          //       //     1)
                                                          //       _cartServices.decrementProductQuantity(
                                                          //           context,
                                                          //           docID: _cartList[
                                                          //                   i]
                                                          //               .docID
                                                          //               .toString(),
                                                          //           updatedPrice:
                                                          //               _cartList[i]
                                                          //                   .productDetails!
                                                          //                   .productPrice!,
                                                          //           uid: user
                                                          //               .getUserDetails()!
                                                          //               .docId
                                                          //               .toString());
                                                          //     },
                                                          //     icon: Icon(
                                                          //       Icons.remove,
                                                          //       color: MyAppColors
                                                          //           .redcolor,
                                                          //     )),
                                                          Text("x " +
                                                              _cartList[i]
                                                                  .quantity
                                                                  .toString()),
                                                          // IconButton(
                                                          //     onPressed: () {
                                                          //       _cartServices.incrementProductQuantity(
                                                          //           context,
                                                          //           docID: _cartList[
                                                          //                   i]
                                                          //               .docID
                                                          //               .toString(),
                                                          //           updatedPrice:
                                                          //               _cartList[i]
                                                          //                   .productDetails!
                                                          //                   .productPrice!,
                                                          //           uid: user
                                                          //               .getUserDetails()!
                                                          //               .docId
                                                          //               .toString());
                                                          //     },
                                                          //     icon: Icon(
                                                          //       Icons.add,
                                                          //       color: Colors.green,
                                                          //     )),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  // _cartServices.deleteOneItem(
                                                  //     docID: _cartList[i]
                                                  //         .docID
                                                  //         .toString(),
                                                  //     userID: user
                                                  //         .getUserDetails()!
                                                  //         .docId
                                                  //         .toString());
                                                },
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text("Total :",
                                                            style: GoogleFonts
                                                                .roboto(
                                                                    // fontFamily: 'Gilroy',
                                                                    color: MyAppColors
                                                                        .blackcolor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        14)),
                                                        Text(
                                                            "\$" +
                                                                _cartList[i]
                                                                    .totalPrice
                                                                    .toString(),
                                                            style: GoogleFonts
                                                                .roboto(
                                                                    // fontFamily: 'Gilroy',
                                                                    color: MyAppColors
                                                                        .blackcolor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        13)),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 12,
                                                    ),
                                                    // Row(
                                                    //   children: [
                                                    //     Container(
                                                    //       height: 35,
                                                    //       width: 35,
                                                    //       decoration: BoxDecoration(
                                                    //           borderRadius:
                                                    //               BorderRadius
                                                    //                   .circular(17),
                                                    //           color: MyAppColors
                                                    //               .grey
                                                    //               .withOpacity(
                                                    //                   0.3)),
                                                    //       child: Icon(
                                                    //         Icons.delete,
                                                    //         color: MyAppColors
                                                    //             .redcolor,
                                                    //       ),
                                                    //     ),
                                                    //   ],
                                                    // ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })),
                    ],
                  ),
                );
              });
        });
  }

  Future<void> makePayment(OrderModel model) async {
    try {
      paymentIntentData = await createPaymentIntent(
          OrderHelper.orderPriceCalculator(context).toString(),
          'USD'); //json.decode(response.body);
      // print('Response body==>${response.body.toString()}');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  applePay: true,
                  googlePay: true,
                  testEnv: true,
                  style: ThemeMode.dark,
                  merchantCountryCode: 'US',
                  merchantDisplayName: 'ANNIE'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet(model);
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet(OrderModel model) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    var cartData = Provider.of<CartProvider>(context, listen: false);

    try {
      await Stripe.instance
          .presentPaymentSheet(
              parameters: PresentPaymentSheetParameters(
        clientSecret: paymentIntentData!['client_secret'],
        confirmPayment: true,
      ))
          .then((newValue) async {
        print('payment intent' + paymentIntentData!['id'].toString());
        print(
            'payment intent' + paymentIntentData!['client_secret'].toString());
        print('payment intent' + paymentIntentData!['amount'].toString());
        print('payment intent' + paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Paid successfully")));
        await OrderServices().placeOrder(model).then((value) {
          CartServices().streamCartList(context).first.then((value) {
            value
                .map((e) => _cartServices.emptyMyCart(
                    docID: e.docID.toString(),
                    userID: user.getUserDetails()!.docId.toString()))
                .toList();
          });

          cartData.emptyMyLocalCart();
        });
        _payementServices
            .createPayment(PayementModel(
          payementAmount: num.parse(paymentIntentData!['amount'].toString()),
          user: user.getUserDetails(),
          ownerID: model.cart![0].productDetails!.user!.userID.toString(),
          ownerName: model.cart![0].productDetails!.user!.fullName.toString(),
          ownerImage: model.cart![0].productDetails!.user!.userImage.toString(),
          payementDate: Timestamp.fromDate(DateTime.now()),
          userId: getUserID(),
          //  paymentDate:

          //  shopID: getUserID()
        ))
            .then((value) {
          NotificationHandler().oneToOneNotificationHelper(
              docID: model.cart![0].productDetails!.user!.userID.toString(),
              body: model.cart![0].productDetails!.productName.toString(),
              title: "You have Recieved Order from " +
                  model.user!.fullName.toString());
          Fluttertoast.showToast(msg: "Payment created");

          Get.to(Bottomnavigation(
            index: 0,
          ));
        }).whenComplete(() {
          // notificationServices.createNotification(
          //   NotificationModel(
          //       userId: getUserID(),
          //       notificationTitle: "Order Update",
          //       user: user.getUserDetails(),
          //
          //
          //       notificationDate: Timestamp.fromDate(DateTime.now()),
          //       notificationBody: "you have recieved order"),
          // );
        });

        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(
            OrderHelper.orderPriceCalculator(context).toString()),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51InnRlIdxBCh70xgaKAYuLVmO8DujZuSHV8y2P2dligGO0tbeNvhO7DKubYmF1YrnwjOTBFsH84u0XuckRJHi3Mg00usIiiw3f',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount));
    return a.toString();
  }

  num getProductUpdatedPrice({required num quantity, required num price}) {
    return quantity * price;
  }
}
