import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Models/categoriesModel.dart';
import '../../Services/category_services.dart';
import '../../Utils/Colors.dart';
import '../../Utils/res.dart';
import '../Screens/shop_details.dart';

class ShopCardWidget extends StatefulWidget {
  final String ShopName;
  final String shopID;
  final String FullName;
  final String RentalUserImage;
  final String RenatlUserID;
  final String useruserID;
  final String shopStatus;

// final String RentalUserID;

  ShopCardWidget(this.ShopName, this.shopID, this.FullName,
      this.RentalUserImage, this.RenatlUserID, this.useruserID, this.shopStatus

      //  ,this.RentalUserID

      );

  @override
  State<ShopCardWidget> createState() => _ShopCardWidgetState();
}

class _ShopCardWidgetState extends State<ShopCardWidget> {
  CategoryServices _categoryServices = CategoryServices();

  @override
  Widget build(BuildContext context) {
    print(widget.RenatlUserID);
    return InkWell(
      onTap: () {
        Get.to(ServiceManProfile(
          widget.RenatlUserID, widget.FullName,
          widget.RentalUserImage, widget.useruserID, widget.shopID,widget.shopStatus

          // widget.RentalUserID
        ));
      },
      child: Container(
        height: 285,
        width: MediaQuery.of(context).size.width,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 15.0, left: 10, top: 10, right: 10),
                          child: GestureDetector(
                            onTap: () {
                              //  Get.to(ServiceManProfile());
                            },
                            child: CachedNetworkImage(
                                height: 50,
                                width: 50,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(33),
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                imageUrl: widget.RentalUserImage,
                                fit: BoxFit.cover,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        SpinKitWave(
                                            color: MyAppColors.appColor,
                                            type: SpinKitWaveType.start),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.ShopName.toString(),
                                  style: GoogleFonts.roboto(
                                      // fontFamily: 'Gilroy',
                                      color: MyAppColors.blue,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                              Row(
                                children: [
                                  Text(widget.FullName,
                                      style: GoogleFonts.roboto(
                                          // fontFamily: 'Gilroy',
                                          //color: MyAppColors.blue,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16)),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                        color: MyAppColors.blue,
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    child: Center(
                                      child: SvgPicture.asset(Res.tickmark),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  RatingBar.builder(
                                    itemSize: 15,
                                    initialRating: 3,
                                    minRating: 1,
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
                                          fontSize: 13)),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.favorite_outline_outlined),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  color: MyAppColors.blue,
                  height: 0.2,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              StreamProvider.value(
                  value:
                      CategoryServices().streamlimitCategories(widget.shopID),
                  initialData: [CategoriesModel()],
                  builder: (context, child) {
                    //     contactListDB = context.watch<List<EventModel>>();
                    List<CategoriesModel> list =
                        context.watch<List<CategoriesModel>>();
                    return list.isEmpty
                        ? Center(
                            child: Padding(
                            padding: const EdgeInsets.only(top: 100.0),
                            child: Text("No Categories Available",
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20)),
                          ))
                        : list[0].categoryId == null
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 50.0),
                                  child: SpinKitWave(
                                      color: Colors.green,
                                      type: SpinKitWaveType.start),
                                ),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: list.length,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, i) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                list[i].categoryName.toString(),
                                                style: GoogleFonts.roboto(
                                                    // fontFamily: 'Gilroy',
                                                    // color: Colors.grey,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 17)),
                                            Text("\$10-35\$",
                                                style: GoogleFonts.roboto(
                                                    // fontFamily: 'Gilroy',
                                                    // color: Colors.grey,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 17)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  );
                                });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
