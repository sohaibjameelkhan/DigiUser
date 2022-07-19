import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Models/product_Model.dart';
import '../Screens/ProductsSection/product_details.dart';

class ProductViewWidget extends StatefulWidget {
  final ProductModel productModel;
  final String productID;
  final String categoryID;
  final String productName;
  final String productPrice;
  final String productDescription;
  final String productQuantity;
  final String productImage;
  final int favouritecount;
  final String isFavourite;

  ProductViewWidget(
      this.productModel,
      this.productID,
      this.categoryID,
      this.productName,
      this.productPrice,
      this.productDescription,
      this.productQuantity,
      this.productImage,
      this.favouritecount,
      this.isFavourite);

  @override
  State<ProductViewWidget> createState() => _ProductViewWidgetState();
}

class _ProductViewWidgetState extends State<ProductViewWidget> {
  bool _isLiked = false;
  bool isLiked = false;

  like() async {
    await FirebaseFirestore.instance
        .collection("Likes")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("items")
        .doc(widget.productID)
        .set({'blogID': widget.productID}).whenComplete(() {
      FirebaseFirestore.instance
          .collection('ProductsCollection')
          .doc(widget.productID)
          .set({
        'favouriteCount': widget.favouritecount + 1,
        "isFavorite": true,
      }, SetOptions(merge: true)).whenComplete(() {
        _isLiked = true;

        setState(() {
          widget.favouritecount! + 1;
        });
        print(isLiked);
      });
    });
  }

  ///unlike Function
  unLike() async {
    await FirebaseFirestore.instance
        .collection("Likes")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("items")
        .doc(widget.productID)
        .delete()
        .whenComplete(() {
      FirebaseFirestore.instance
          .collection('ProductsCollection')
          .doc(widget.productID)
          .set({
        'favouriteCount':
            widget.favouritecount - 1 < 0 ? 0 : widget.favouritecount - 1,
        "isFavorite": false,
      }, SetOptions(merge: true)).whenComplete(() {
        _isLiked = false;
        setState(() {
          widget.favouritecount! - 1;
        });
      });
    });
  }

  ///check like
  _checkLiked() async {
    DocumentSnapshot mRef;
    mRef = await FirebaseFirestore.instance
        .collection('Likes')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('items')
        .doc(widget.productID)
        .get();
    if (mRef['blogID'] == null) {
      setState(() {
        isLiked = false;
      });
    } else {
      setState(() {
        isLiked = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkLiked();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          //Get.to(ProductDetails());
        },
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: GridTile(
              header: Row(
                children: [
                  // Text(
                  //   widget.productPrice,
                  //   style: TextStyle(fontWeight: FontWeight.bold),
                  //   textAlign: TextAlign.center,
                  // ),
                ],
              ),
              child: GestureDetector(
                  onTap: () {
                    Get.to(ProductDetails(
                        widget.productModel,
                        widget.productID,
                        widget.categoryID,
                        widget.productName,
                        widget.productPrice,
                        widget.productDescription,
                        widget.productQuantity,
                        widget.productImage));
                    // Navigator.of(context).pushNamed(ProductDetailScreen.routName,
                    //     arguments: products.id);
                  },
                  child: Image.network(
                    widget.productImage,
                    fit: BoxFit.cover,
                  )),
              footer: GridTileBar(
                leading: IconButton(
                    color: Colors.white,
                    icon:
                        Icon(_isLiked ? Icons.favorite : Icons.favorite_border),
                    onPressed: () {
                      if (_isLiked) {
                        setState(() {
                          unLike();
                        });
                      } else {
                        setState(() {
                          like();
                        });
                      }
                    }),
                // trailing: IconButton(
                //     icon: Icon(Icons.shopping_cart),
                //     onPressed: () {
                //       //  cart.addItem(products.id, products.price, products.title);
                //       //  Scaffold.of(context).hideCurrentSnackBar();
                //       //  Scaffold.of(context).showSnackBar(
                //       //     SnackBar(
                //       //       content: Text("Added item to cart"),
                //       //       duration: Duration(seconds: 3),
                //       //       action: SnackBarAction(
                //       //         label: "Undo",
                //       //         onPressed: () {
                //       //           cart.removeSingleItem(products.id);
                //       //         },
                //       //       ),
                //       //    ),
                //       //);
                //     }),
                backgroundColor: Colors.black54,
                title: Text(
                  widget.productName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
