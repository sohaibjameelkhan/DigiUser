import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/Colors.dart';
import '../../Utils/res.dart';

class ProductWidget extends StatefulWidget {
  final String categoryId;

  // final String productId;

  final String productName;
  final String productprice;
  final String productquantity;
  final String productdescription;
  final String productImage;

  ProductWidget(this.categoryId, this.productName, this.productprice,
      this.productquantity, this.productdescription, this.productImage);

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        children: [
          Column(
            children: [
              CachedNetworkImage(
                  height: 50,
                  width: 60,
                  imageBuilder: (context, imageProvider) => Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                  imageUrl: widget.productImage,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      SpinKitWave(
                          color: MyAppColors.appColor,
                          type: SpinKitWaveType.start),
                  errorWidget: (context, url, error) => Icon(Icons.error)),
              const SizedBox(
                height: 10,
              ),
              Text(widget.productName,
                  style: GoogleFonts.roboto(
                      // fontFamily: 'Gilroy',
                      //color: MyAppColors.appColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}

//
