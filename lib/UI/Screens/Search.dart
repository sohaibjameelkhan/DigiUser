// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, prefer_collection_literals

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../Models/product_Model.dart';
import '../../Services/product_services.dart';
import '../../Utils/Colors.dart';
import '../../Utils/res.dart';
import '../Widgets/product_view_widget.dart';

class Search extends StatefulWidget {
  const Search(
      {Key? key,
      menuScreenContext,
      bool? hideStatus,
      Null Function()? onScreenHideButtonPressed})
      : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Set<Marker> _marker = Set<Marker>();
  ProductServices _productServices = ProductServices();

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Favourite Products",
                    style: GoogleFonts.roboto(
                        // fontFamily: 'Gilroy',
                        color: MyAppColors.blackcolor,
                        fontWeight: FontWeight.w600,
                        fontSize: 20)),
              ],
            ),
          ),
          SizedBox(
            height: 20,
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
                        child: Text("Add Products to Favourite",
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
                                  size: 30,
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 2),
          //   child: Container(
          //     height: 590,
          //     width: double.infinity,
          //     //   color: Colors.red,
          //     child: GoogleMap(
          //       zoomControlsEnabled: true,
          //       myLocationButtonEnabled: true,
          //       zoomGesturesEnabled: true,
          //
          //       myLocationEnabled: true,
          //
          //       //   markers: ,
          //       mapType: MapType.normal,
          //       markers: _marker,
          //       initialCameraPosition: _kGooglePlex,
          //       //   initialCameraPosition: _initialCameraPosition,
          //       // initialCameraPosition: CameraPosition(
          //       //   zoom: 4,
          //       //   target: LatLng(widget.latitude, widget.longititude),
          //       // ),
          //       //  markers: ,
          //       onMapCreated: (GoogleMapController controller) {
          //         _controller.complete(controller);
          //       },
          //     ),
          //     // floatingActionButton: FloatingActionButton.extended(
          //     //   onPressed: _goToTheLake,
          //     //   label: Text('To the lake!'),
          //     //   icon: Icon(Icons.directions_boat),
          //     // ),
          //   ),
          // )
        ],
      ),
    ));
  }
}
