// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Models/order_model.dart';
import '../../../Services/order_services.dart';
import '../../../Utils/Colors.dart';
import '../../../res.dart';

class ActiveOrders extends StatefulWidget {
  const ActiveOrders({Key? key}) : super(key: key);

  @override
  State<ActiveOrders> createState() => _ActiveOrdersState();
}

class _ActiveOrdersState extends State<ActiveOrders> {
  OrderServices _orderServices = OrderServices();

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
        value: _orderServices
            .streamMyPendingOrders(FirebaseAuth.instance.currentUser!.uid),
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
                      "Pending Orders : " + _orderList.length.toString(),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 1),
                            child: Container(
                              height: 160,
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
                                    SizedBox(
                                      height: 10,
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
                                                              .cart![0]
                                                              .productDetails!
                                                              .user!
                                                              .userImage
                                                              .toString(),
                                                        ) as ImageProvider),
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
                                                        .cart![0]
                                                        .productDetails!
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
                                              Text("In Pending ",
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
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Row(
                                        children: [
                                          Text("Due in 1h 32min ",
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
