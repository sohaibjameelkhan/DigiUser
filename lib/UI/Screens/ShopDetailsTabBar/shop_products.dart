
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Models/product_Model.dart';
import '../../../Services/product_services.dart';
import '../../Widgets/product_view_widget.dart';

class ShopProducts extends StatefulWidget {
  final String RentalUserId;

  ShopProducts({required this.RentalUserId});

  @override
  State<ShopProducts> createState() => _ShopProductsState();
}

class _ShopProductsState extends State<ShopProducts> {
  ProductServices _productServices = ProductServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            StreamProvider.value(
                value: _productServices.streamonlyProducts(widget.RentalUserId),
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
