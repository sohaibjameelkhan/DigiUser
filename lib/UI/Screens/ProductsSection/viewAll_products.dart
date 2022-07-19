import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Helpers/BottomNavBar.dart';
import '../../../Models/product_Model.dart';
import '../../../Services/product_services.dart';
import '../../../Utils/Colors.dart';
import '../../../Utils/res.dart';
import '../../Widgets/product_view_widget.dart';

class ViewAllProducts extends StatefulWidget {
  const ViewAllProducts({Key? key}) : super(key: key);

  @override
  State<ViewAllProducts> createState() => _ViewAllProductsState();
}

class _ViewAllProductsState extends State<ViewAllProducts> {
  ProductServices _productServices = ProductServices();
  TextEditingController _searchController = TextEditingController();
  List<ProductModel> searchedContact = [];

  List<ProductModel> contactList = [];

  bool isSearchingAllow = false;
  bool isSearched = false;
  List<ProductModel> contactListDB = [];

  void _searchedContacts(String val) async {
    print(contactListDB.length);
    searchedContact.clear();
    for (var i in contactListDB) {
      var lowerCaseString = i.productName.toString().toLowerCase() +
          " " +
          i.productName.toString().toLowerCase() +
          i.productName.toString();

      var defaultCase = i.productName.toString() +
          " " +
          i.productName.toString() +
          i.productName.toString();

      if (lowerCaseString.contains(val) || defaultCase.contains(val)) {
        searchedContact.add(i);
      } else {
        setState(() {
          isSearched = true;
        });
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                      Get.to(Bottomnavigation(
                        index: 0,
                      ));
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
                  Text("All Products",
                      style: GoogleFonts.roboto(
                          // fontFamily: 'Gilroy',
                          color: MyAppColors.blackcolor,
                          fontWeight: FontWeight.w600,
                          fontSize: 20)),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 52,
              width: 320,
              decoration: BoxDecoration(
                  color: MyAppColors.bgtextfieldcolor,
                  borderRadius: BorderRadius.circular(13)),
              child: TextFormField(
                onChanged: (val) {
                  _searchedContacts(val);
                  setState(() {});
                },
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 25, top: 15),
                    hintText: "Search Products... ",
                    hintStyle: GoogleFonts.roboto(
                        // fontFamily: 'Gilroy',
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: SvgPicture.asset(
                        Res.searchicon,
                        height: 2,
                        width: 2,
                      ),
                    ),
                    border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            StreamProvider.value(
                value: _productServices.streamProducts(),
                initialData: [ProductModel()],
                builder: (context, child) {
                  contactListDB = context.watch<List<ProductModel>>();
                  List<ProductModel> list = context.watch<List<ProductModel>>();
                  return list.isEmpty
                      ? Center(
                          child: Padding(
                          padding: const EdgeInsets.only(top: 100.0),
                          child: Text("Add Products",
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
                                    color: Colors.blue,
                                    type: SpinKitWaveType.start),
                              ),
                            )
                          : list.isEmpty
                              ? Center(child: Text("No Data"))
                              : searchedContact.isEmpty
                                  ? isSearched == true
                                      ? Center(child: Text("NO Data"))
                                      : Container(
                                          // height: 550,
                                          // width: MediaQuery.of(context).size.width,

                                          child: GridView.builder(
                                              itemCount: list.length,
                                              shrinkWrap: true,
                                              padding: EdgeInsets.only(),
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              gridDelegate:
                                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent: 300,
                                                childAspectRatio: 1,
                                                mainAxisExtent: 170,
                                              ),
                                              itemBuilder: (context, i) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: ProductViewWidget(
//  list[i].productId.toString(),
                                                      list[i],
                                                      list[i]
                                                          .productId
                                                          .toString(),
                                                      list[i]
                                                          .categoryId
                                                          .toString(),
                                                      list[i]
                                                          .productName
                                                          .toString(),
                                                      list[i]
                                                          .productPrice
                                                          .toString(),
                                                      list[i]
                                                          .productDesc
                                                          .toString(),
                                                      list[i]
                                                          .productquantity
                                                          .toString(),
                                                      list[i]
                                                          .productImage
                                                          .toString(),
                                                      list[i].favouriteCount!,
                                                      list[i]
                                                          .isFavorite
                                                          .toString()),
                                                );
                                              }))
                                  : Container(
                                      // height: 550,
                                      // width: MediaQuery.of(context).size.width,

                                      child: GridView.builder(
                                          itemCount: list.length,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.only(),
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 300,
                                            childAspectRatio: 1,
                                            mainAxisExtent: 170,
                                          ),
                                          itemBuilder: (context, i) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: ProductViewWidget(
//  list[i].productId.toString(),
                                                  searchedContact[i],
                                                  searchedContact[i]
                                                      .productId
                                                      .toString(),
                                                  searchedContact[i]
                                                      .categoryId
                                                      .toString(),
                                                  searchedContact[i]
                                                      .productName
                                                      .toString(),
                                                  searchedContact[i]
                                                      .productPrice
                                                      .toString(),
                                                  searchedContact[i]
                                                      .productDesc
                                                      .toString(),
                                                  searchedContact[i]
                                                      .productquantity
                                                      .toString(),
                                                  searchedContact[i]
                                                      .productImage
                                                      .toString(),
                                                  searchedContact[i]
                                                      .favouriteCount!,
                                                  searchedContact[i]
                                                      .isFavorite
                                                      .toString()),
                                            );
                                          }));
                })
          ],
        ),
      ),
    );
  }
}
