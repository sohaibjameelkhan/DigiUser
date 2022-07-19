// ignore_for_file: prefer_const_constructors, avoid_print, sized_box_for_whitespace

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:get/get.dart';

import '../../Helpers/helper.dart';
import '../../Utils/Colors.dart';
import '../../Utils/res.dart';
import 'ChatSection/messages.dart';
import 'ShopDetailsTabBar/about_shop.dart';
import 'ShopDetailsTabBar/shop_products.dart';
import 'ShopDetailsTabBar/shop_reviews.dart';

class ServiceManProfile extends StatefulWidget {
  final UserID;
  final RentalShopUserName;
  final RentalShopUserImage;
  final UseruserID;
  final ShopId;
  final String shopstatus;

  //final RentalUserId;

  ServiceManProfile(this.UserID, this.RentalShopUserName,
      this.RentalShopUserImage, this.UseruserID, this.ShopId, this.shopstatus
      //this.RentalUserId
      );

  @override
  State<ServiceManProfile> createState() => _ServiceManProfileState();
}

class _ServiceManProfileState extends State<ServiceManProfile> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        //  backgroundColor: MyAppColors.bgcolor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                child: SvgPicture.asset(Res.arrowbackgreen)),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.favorite_outline_outlined),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Stack(
                          children: [
                            CachedNetworkImage(
                                height: 80,
                                width: 80,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      width: 80.0,
                                      height: 80.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(17),
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                imageUrl: widget.RentalShopUserImage,
                                fit: BoxFit.cover,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        SpinKitWave(
                                            color: MyAppColors.appColor,
                                            type: SpinKitWaveType.start),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error)),

                            // Positioned.fill(
                            //   top: -50,
                            //   child: Align(
                            //     alignment: Alignment.bottomRight,
                            //     child: Container(
                            //       height: 40,
                            //       width: 40,
                            //       decoration: BoxDecoration(
                            //         shape: BoxShape.circle,
                            //         color: MyAppColors.Lightgrey,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text(widget.RentalShopUserName,
                                style: GoogleFonts.roboto(
                                    //fontFamily: 'Gilroy',
                                    color: MyAppColors.blackcolor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 21)),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: MyAppColors.blue,
                                  borderRadius: BorderRadius.circular(40)),
                              child: Center(
                                child: SvgPicture.asset(Res.tickmark),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          children: [
                            RatingBar.builder(
                              initialRating: 3,
                              minRating: 1,
                              itemSize: 23,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 0.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                            Text(" 4.9 (206 Reviews)",
                                style: GoogleFonts.roboto(
                                    // fontFamily: 'Gilroy',
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 7,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text("Shop Level :",
                              style: GoogleFonts.roboto(
                                  // fontFamily: 'Gilroy',
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15)),
                          SizedBox(
                            width: 20,
                          ),
                          Text(widget.shopstatus.toString(),
                              style: GoogleFonts.roboto(
                                  // fontFamily: 'Gilroy',
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(MessagesView(
                            myID: getUserID(),
                            receiverID: widget.UserID,
                            name: widget.RentalShopUserName,
                          ));
                        },
                        child: Container(
                          height: 42,
                          width: 125,
                          decoration: BoxDecoration(
                            color: MyAppColors.appColor,
                              border: Border.all(
                                  width: 2, color: MyAppColors.appColor),
                              borderRadius: BorderRadius.circular(13)),
                          child: Center(
                            child: Text("Send Message",
                                style: GoogleFonts.roboto(
                                    // fontFamily: 'Gilroy',
                                    color: MyAppColors.whitecolor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 0.5,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: MyAppColors.blue),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  child: TabBar(
                    unselectedLabelColor: MyAppColors.Lightgrey,
                    labelColor: MyAppColors.appColor,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: MyAppColors.appColor,
                    tabs: [
                      Tab(
                        text: "Products",
                      ),
                      Tab(text: "Reviews"),
                      // Tab(
                      //   text: "About Shop",
                      // ),
                    ],
                  ),
                ),
                Container(
                  height: 650,
                  width: double.infinity,
                  child: TabBarView(
                    children: [
                      ShopProducts(
                        RentalUserId: widget.UseruserID,

                        // ShopID: widget.ShopId,
                      ),
                      ShopReviews(
                        ownerId: widget.UserID,
                      ),
                      //  AboutShop(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
