// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:digirental_user_app/Services/order_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../../Models/order_model.dart';
import '../../../Utils/Colors.dart';
import '../../../Utils/res.dart';
import '../feedback.dart';

class CancelledOrders extends StatefulWidget {
  const CancelledOrders({Key? key}) : super(key: key);

  @override
  State<CancelledOrders> createState() => _CancelledOrdersState();
}

class _CancelledOrdersState extends State<CancelledOrders> {
  OrderServices _orderServices = OrderServices();

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
        value: _orderServices
            .streamMyCancelledOrders(FirebaseAuth.instance.currentUser!.uid),
        initialData: [OrderModel()],
        builder: (context, child) {
          List<OrderModel> _orderList = context.watch<List<OrderModel>>();
          return Scaffold(
              backgroundColor: MyAppColors.whitecolor,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Cancelled Orders : " + _orderList.length.toString(),
                      style: GoogleFonts.roboto(
                          // fontFamily: 'Gilroy',
                          color: MyAppColors.blackcolor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        // scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _orderList.length,
                        itemBuilder: (_, i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              height: 180,
                              width: double.infinity,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13)),
                                elevation: 6,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Row(
                                        children: [
                                          Stack(
                                            children: [
                                              _orderList[i]
                                                          .cart![0]
                                                          .productDetails!
                                                          .productImage
                                                          .toString() ==
                                                      null
                                                  ? CircleAvatar(
                                                      radius: 40,
                                                      backgroundImage:
                                                          AssetImage(Res
                                                              .invitefriendbanner),
                                                    )
                                                  : CachedNetworkImage(
                                                      height: 50,
                                                      width: 80,
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                            width: 50.0,
                                                            height: 80.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7),
                                                              image: DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover),
                                                            ),
                                                          ),
                                                      imageUrl: _orderList[i]
                                                          .cart![0]
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
                                                              size: 30,
                                                              type:
                                                                  SpinKitWaveType
                                                                      .start),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error))
                                            ],
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "\$" +
                                                      _orderList[i]
                                                          .totalBill
                                                          .toString(),
                                                  style: GoogleFonts.roboto(
                                                      // fontFamily: 'Gilroy',
                                                      color: MyAppColors
                                                          .blackcolor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 18)),
                                              Text(
                                                  _orderList[i]
                                                      .cart![0]
                                                      .productDetails!
                                                      .productName
                                                      .toString(),
                                                  style: GoogleFonts.roboto(
                                                      // fontFamily: 'Gilroy',
                                                      color: MyAppColors
                                                          .blackcolor
                                                          .withOpacity(0.9),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 13)),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 35,
                                                width: 35,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                                _orderList[i]
                                                                    .user!
                                                                    .userImage
                                                                    .toString())
                                                            as ImageProvider),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            33)),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0),
                                                child: Text(
                                                    _orderList[i]
                                                        .user!
                                                        .fullName
                                                        .toString(),
                                                    style: GoogleFonts.roboto(
                                                        // fontFamily: 'Gilroy',
                                                        color: MyAppColors
                                                            .blackcolor
                                                            .withOpacity(0.9),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15)),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text("Completed ",
                                                  style: GoogleFonts.roboto(
                                                      // fontFamily: 'Gilroy',
                                                      color:
                                                          MyAppColors.appColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 11)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              // InkWell(
                                              //   onTap: () {
                                              //     pushNewScreen(context,
                                              //         screen: FeedbackScreen(
                                              //           userId: _orderList[i]
                                              //               .cart![0]
                                              //               .productDetails!
                                              //               .user!
                                              //               .userID
                                              //               .toString(),
                                              //         ));
                                              //   },
                                              //   child: Container(
                                              //     height: 40,
                                              //     width: 100,
                                              //     decoration: BoxDecoration(
                                              //         borderRadius:
                                              //         BorderRadius.circular(
                                              //             9),
                                              //         color:
                                              //         MyAppColors.appColor),
                                              //     child: Center(
                                              //       child: Text("Give Review",
                                              //           style:
                                              //           GoogleFonts.roboto(
                                              //             // fontFamily: 'Gilroy',
                                              //               color: MyAppColors
                                              //                   .whitecolor
                                              //                   .withOpacity(
                                              //                   0.9),
                                              //               fontWeight:
                                              //               FontWeight
                                              //                   .w700,
                                              //               fontSize: 14)),
                                              //     ),
                                              //   ),
                                              // )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Row(
                                        children: [
                                          Text("14 Feb 2022 ",
                                              style: GoogleFonts.roboto(
                                                  // fontFamily: 'Gilroy',
                                                  color: MyAppColors.blackcolor
                                                      .withOpacity(0.9),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15)),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                  ],
                ),
              ));
        });
  }
}
