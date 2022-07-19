// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Models/cart_model.dart';
import '../../../Models/product_Model.dart';
import '../../../Providers/cart_provider.dart';
import '../../../Services/cart_services.dart';
import '../../../Utils/Colors.dart';
import '../../../Utils/res.dart';
import '../../Widgets/appbutton.dart';
import '../ChatSection/user_provider.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel productModel;
  final String productID;
  final String categoryID;
  final String productName;
  final String productPrice;
  final String productDescription;
  final String productQuantity;
  final String productImage;

  ProductDetails(
      this.productModel,
      this.productID,
      this.categoryID,
      this.productName,
      this.productPrice,
      this.productDescription,
      this.productQuantity,
      this.productImage);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int quantity = 1;
  CartServices _cartServices = CartServices();

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 15,
          ),
          AppButton(
            onTap: () {
              _cartServices
                  .streamSpecificProduct(
                      widget.productModel.productId.toString(),
                      userProvider.getUserDetails()!.docId.toString())
                  .first
                  .then((value) {

                if (value.isEmpty) {
                  cartProvider.saveCartData(CartModel(
                      quantity: quantity,
                      totalPrice: quantity * widget.productModel.productPrice!,
                      uID: userProvider.getUserDetails()!.docId,
                      productDetails: widget.productModel));

                  _cartServices
                      .addToCart(context,
                          model: CartModel(
                              quantity: quantity,
                              totalPrice:
                                  quantity * widget.productModel.productPrice!,
                              uID: userProvider.getUserDetails()!.docId,
                              productDetails: widget.productModel),
                          uid: userProvider.getUserDetails()!.docId.toString())
                      .whenComplete(() {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Item Added to Cart Sucessfully")));
                  });
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Product already in cart"),
                        );
                      });
                }
              });
            },
            containerheight: 55,
            text: "Add to Cart",
          ),
          SizedBox(
            height: 15,
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
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
                      child:
                          Center(child: SvgPicture.asset(Res.arrowbackgreen)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 70,
                ),
                Text("Products Details",
                    style: GoogleFonts.roboto(
                        // fontFamily: 'Gilroy',
                        color: MyAppColors.blackcolor,
                        fontWeight: FontWeight.w600,
                        fontSize: 20)),
              ],
            ),
          ),
          SizedBox(
            height: 23,
          ),
          CachedNetworkImage(
              height: 200,
              width: double.infinity,
              imageBuilder: (context, imageProvider) => Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
              imageUrl: widget.productImage,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  SpinKitWave(
                      color: MyAppColors.appColor, type: SpinKitWaveType.start),
              errorWidget: (context, url, error) => Icon(Icons.error)),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(widget.productName.toString(),
                        style: GoogleFonts.roboto(
                            // fontFamily: 'Gilroy',
                            color: MyAppColors.blackcolor,
                            fontWeight: FontWeight.w600,
                            fontSize: 18)),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Quantity : " + widget.productQuantity.toString(),
                        style: GoogleFonts.roboto(
                            // fontFamily: 'Gilroy',
                            color: MyAppColors.blackcolor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16)),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                Text("\$ " + widget.productPrice.toString(),
                    style: GoogleFonts.roboto(
                        // fontFamily: 'Gilroy',
                        color: MyAppColors.blackcolor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18)),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Container(
                  child: RichText(
                      maxLines: 4,
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                          text: widget.productDescription,
                          //'Round up every debit transaction to the nearest hundered and save the change which is distributed across all active bucket',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 14,
                              fontWeight: FontWeight.w500))),
                  height: 70,
                  width: 320,
                ),
              ],
            ),
          ),

          Row(
            children: [
              IconButton(
                  onPressed: () {
                    if (quantity > 1) quantity--;
                    setState(() {});
                  },
                  icon: Icon(Icons.remove)),
              Text(quantity.toString()),
              IconButton(
                  onPressed: () {
                    quantity++;
                    setState(() {});
                  },
                  icon: Icon(Icons.add)),
            ],
          ),
          Text((quantity * widget.productModel.productPrice!).toString()),
        ],
      ),
    );
  }
}
