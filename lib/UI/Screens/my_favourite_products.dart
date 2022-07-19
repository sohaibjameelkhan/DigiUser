
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Models/product_Model.dart';
import '../../Services/product_services.dart';
import '../../Utils/Colors.dart';
import '../../Utils/res.dart';
import '../Widgets/product_view_widget.dart';

class MyFavouriteProducts extends StatefulWidget {
  const MyFavouriteProducts({Key? key}) : super(key: key);

  @override
  State<MyFavouriteProducts> createState() => _MyFavouriteProductsState();
}

class _MyFavouriteProductsState extends State<MyFavouriteProducts> {
  ProductServices _productServices = ProductServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 45,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
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
                        child:
                            Center(child: SvgPicture.asset(Res.arrowbackgreen)),
                      ),
                    ),
                  ),
                  Text("Favourite Products",
                      style: GoogleFonts.roboto(
                          // fontFamily: 'Gilroy',
                          color: MyAppColors.blackcolor,
                          fontWeight: FontWeight.w600,
                          fontSize: 20)),
                  Text("",
                      style: GoogleFonts.roboto(
                          // fontFamily: 'Gilroy',
                          color: MyAppColors.blackcolor,
                          fontWeight: FontWeight.w600,
                          fontSize: 20)),
                ],
              ),
            ),
            StreamProvider.value(
                value: _productServices.streamonlyFavouriteProducts(
                    FirebaseAuth.instance.currentUser!.uid),
                initialData: [ProductModel()],
                builder: (context, child) {
                  //     contactListDB = context.watch<List<EventModel>>();
                  List<ProductModel> list = context.watch<List<ProductModel>>();
                  return list.isEmpty
                      ? Center(
                          child: Padding(
                          padding: const EdgeInsets.only(top: 100.0),
                          child: Text("No Product Available",
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20)),
                        ))
                      : list[0].productId == null
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 50.0),
                                child: SpinKitWave(
                                    color: Colors.green,
                                    type: SpinKitWaveType.start),
                              ),
                            )
                          : GridView.builder(
                              itemCount: list.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 400,
                              ),
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: ProductViewWidget(
                                      //  list[i].productId.toString(),
                                      list[i],
                                      list[i].productId.toString(),
                                      list[i].categoryId.toString(),
                                      list[i].productName.toString(),
                                      list[i].productPrice.toString(),
                                      list[i].productDesc.toString(),
                                      list[i].productquantity.toString(),
                                      list[i].productImage.toString(),
                                      list[i].favouriteCount!,
                                      list[i].isFavorite.toString()),
                                );
                              });
                }),
          ],
        ),
      ),
    );
  }
}
