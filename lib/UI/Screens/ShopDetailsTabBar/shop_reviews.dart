import 'package:cached_network_image/cached_network_image.dart';
import 'package:digirental_user_app/Services/review_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Models/Review_Model.dart';
import '../../../Utils/Colors.dart';
import '../../../res.dart';

class ShopReviews extends StatefulWidget {
  final String ownerId;

  ShopReviews({required this.ownerId});

  @override
  State<ShopReviews> createState() => _ShopReviewsState();
}

class _ShopReviewsState extends State<ShopReviews> {
  ReviewServices reviewServices = ReviewServices();

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
        value: reviewServices.streamShopReviewstHistory(widget.ownerId),
        initialData: [ReviewModel()],
        builder: (context, child) {
          List<ReviewModel> _orderList = context.watch<List<ReviewModel>>();
          return _orderList.isEmpty
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Text("No Reviews available",
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
                ))
              : _orderList[0].docId == null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: SpinKitWave(
                            color: Colors.green, type: SpinKitWaveType.start),
                      ),
                    )
                  : Scaffold(
                      body: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                // scrollDirection: Axis.horizontal,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _orderList.length,
                                itemBuilder: (_, i) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12, bottom: 6),
                                    child: Container(
                                      height: 120,
                                      width: double.infinity,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(17)),
                                        elevation: 4,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              child: Row(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      _orderList[i]
                                                                  .user!
                                                                  .userImage ==
                                                              null
                                                          ? CircleAvatar(
                                                              radius: 40,
                                                              backgroundImage:
                                                                  AssetImage(Res
                                                                      .personicon),
                                                            )
                                                          : CachedNetworkImage(
                                                              height: 45,
                                                              width: 45,
                                                              imageBuilder:
                                                                  (context, imageProvider) =>
                                                                      Container(
                                                                        width:
                                                                            45.0,
                                                                        height:
                                                                            45.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(50),
                                                                          image: DecorationImage(
                                                                              image: imageProvider,
                                                                              fit: BoxFit.cover),
                                                                        ),
                                                                      ),
                                                              imageUrl:
                                                                  _orderList[i]
                                                                      .user!
                                                                      .userImage
                                                                      .toString(),
                                                              fit: BoxFit.cover,
                                                              progressIndicatorBuilder: (context,
                                                                      url,
                                                                      downloadProgress) =>
                                                                  SpinKitWave(
                                                                      color: MyAppColors
                                                                          .appColor,
                                                                      size: 30,
                                                                      type: SpinKitWaveType
                                                                          .start),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Icon(Icons
                                                                      .error))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                              _orderList[i]
                                                                  .user!
                                                                  .fullName
                                                                  .toString(),
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                      //fontFamily: 'Gilroy',
                                                                      color: MyAppColors
                                                                          .blackcolor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          17)),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 2,
                                                      ),
                                                      Row(
                                                        children: [
                                                          RatingBar.builder(
                                                            initialRating:
                                                                _orderList[i]
                                                                    .servicerating!
                                                                    .toDouble(),
                                                            minRating: 1,
                                                            itemSize: 17,
                                                            direction:
                                                                Axis.horizontal,
                                                            allowHalfRating:
                                                                true,
                                                            itemCount: 5,
                                                            itemPadding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        0.0),
                                                            itemBuilder:
                                                                (context, _) =>
                                                                    Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                            onRatingUpdate:
                                                                (rating) {
                                                              print(rating);
                                                            },
                                                          ),
                                                          Text(
                                                              "(" +
                                                                  _orderList[i]
                                                                      .servicerating
                                                                      .toString() +
                                                                  ")",
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                      // fontFamily: 'Gilroy',
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          14)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Row(
                                                children: [
                                                  RichText(
                                                    textAlign: TextAlign.start,
                                                    text: TextSpan(
                                                        style:
                                                            GoogleFonts.roboto(
                                                                //fontFamily: 'Gilroy',
                                                                color: MyAppColors
                                                                    .blackcolor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 14),
                                                        text: _orderList[i]
                                                            .experiencedesc
                                                            .toString()),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                })
                          ],
                        ),
                      ),
                    );
        });
  }
}
