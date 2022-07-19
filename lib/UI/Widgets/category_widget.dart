import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/Colors.dart';
import '../../Utils/res.dart';

class categoryWidget extends StatefulWidget {
  final String shopId;
  final String categoryId;
  final String categoryImage;
  final String categoryName;

  categoryWidget(
      this.shopId, this.categoryId, this.categoryImage, this.categoryName);

  @override
  State<categoryWidget> createState() => _categoryWidgetState();
}

class _categoryWidgetState extends State<categoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
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
              imageUrl: widget.categoryImage,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  SpinKitWave(
                      size: 30,
                      color: MyAppColors.appColor,
                      type: SpinKitWaveType.start),
              errorWidget: (context, url, error) => Icon(Icons.error)),
          const SizedBox(
            height: 10,
          ),
          Text(widget.categoryName,
              style: GoogleFonts.roboto(
                  // fontFamily: 'Gilroy',
                  //color: MyAppColors.appColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16)),
        ],
      ),
    );
  }
}

//
