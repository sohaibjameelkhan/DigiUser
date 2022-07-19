// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Helpers/order_price_calculator.dart';
import '../../../Models/cart_model.dart';
import '../../../Providers/cart_provider.dart';
import '../../../Services/cart_services.dart';
import '../../../Services/order_services.dart';
import '../../../Utils/Colors.dart';
import '../../../Utils/res.dart';
import '../../Widgets/appbutton.dart';
import '../ChatSection/user_provider.dart';
import '../OrderSection/order_details.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  CartServices _cartServices = CartServices();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context);
    var cartData = Provider.of<CartProvider>(context);
    print("User" + user.getUserDetails()!.userID.toString());

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
                      // await OrderServices()
                      //     .placeOrder(OrderModel(
                      //         cart: _cartList,
                      //         user: user.getUserDetails(),
                      //         totalBill:
                      //             OrderHelper.orderPriceCalculator(context),
                      //         adminID: '1'))
                      //     .then((value) async {
                      //   cartData.emptyMyLocalCart();
                      //   _cartList
                      //       .map((e) => _cartServices.emptyMyCart(
                      //           docID: e.docID.toString(),
                      //           userID:
                      //               user.getUserDetails()!.docId.toString()))
                      //       .toList();
                      // }).catchError((e) {
                      //   print("Error occurred!");
                      // });
                      Get.to(OrderDetails());
                    },
                    containerheight: 55,
                    text: "Process to CheckOut",
                  ),
                  SizedBox(
                    height: 15,
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 45,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 4,
                                child: Center(
                                    child:
                                        SvgPicture.asset(Res.arrowbackgreen)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 90,
                          ),
                          Text("My Cart",
                              style: GoogleFonts.roboto(
                                  // fontFamily: 'Gilroy',
                                  color: MyAppColors.blackcolor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20)),
                          Text("")

                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                        height: 580,
                        width: double.infinity,
                        child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(),
                            // scrollDirection: Axis.horizontal,
                            // physics: const NeverScrollableScrollPhysics(),
                            itemCount: _cartList.length,
                            itemBuilder: (_, i) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  height: 120,
                                  width: double.infinity,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                    elevation: 4,
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
                                                          IconButton(
                                                              onPressed: () {
                                                                // if (_cartList[i]
                                                                //         .productDetails!
                                                                //         .productPrice! >
                                                                //     1)
                                                                _cartServices.decrementProductQuantity(
                                                                    context,
                                                                    docID: _cartList[
                                                                            i]
                                                                        .docID
                                                                        .toString(),
                                                                    updatedPrice: _cartList[
                                                                            i]
                                                                        .productDetails!
                                                                        .productPrice!,
                                                                    uid: user
                                                                        .getUserDetails()!
                                                                        .docId
                                                                        .toString());
                                                              },
                                                              icon: Icon(
                                                                Icons.remove,
                                                                color: MyAppColors
                                                                    .redcolor,
                                                              )),
                                                          Text(_cartList[i]
                                                              .quantity
                                                              .toString()),
                                                          IconButton(
                                                              onPressed: () {
                                                                _cartServices.incrementProductQuantity(
                                                                    context,
                                                                    docID: _cartList[
                                                                            i]
                                                                        .docID
                                                                        .toString(),
                                                                    updatedPrice: _cartList[
                                                                            i]
                                                                        .productDetails!
                                                                        .productPrice!,
                                                                    uid: user
                                                                        .getUserDetails()!
                                                                        .docId
                                                                        .toString());
                                                              },
                                                              icon: Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .green,
                                                              )),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _cartServices.deleteOneItem(
                                                      docID: _cartList[i]
                                                          .docID
                                                          .toString(),
                                                      userID: user
                                                          .getUserDetails()!
                                                          .docId
                                                          .toString());
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
                                                                            .w600,
                                                                    fontSize:
                                                                        13)),
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
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height: 35,
                                                          width: 35,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          17),
                                                              color: MyAppColors
                                                                  .grey
                                                                  .withOpacity(
                                                                      0.3)),
                                                          child: Icon(
                                                            Icons.delete,
                                                            color: MyAppColors
                                                                .redcolor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })),
                  ],
                ),
              ));
        });
  }

  num getProductUpdatedPrice({required num quantity, required num price}) {
    return quantity * price;
  }
}
