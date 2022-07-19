// ignore_for_file: prefer_const_constructors, avoid_print, prefer_final_fields

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../Models/add_shop_model.dart';
import '../../Models/categoriesModel.dart';
import '../../Models/product_Model.dart';
import '../../Models/shop_user_model.dart';
import '../../Models/user_model.dart';
import '../../Services/category_services.dart';
import '../../Services/product_services.dart';
import '../../Services/shop_services.dart';
import '../../Services/shop_user_services.dart';
import '../../Services/user_services.dart';
import '../../Utils/Colors.dart';
import '../../Utils/res.dart';
import '../Widgets/category_widget.dart';
import '../Widgets/product_widget.dart';
import '../Widgets/shop_card_widget.dart';
import 'CartSection/Cart_View_Screen.dart';
import 'ProductsSection/viewAll_products.dart';
import 'AuthSection/my_profile.dart';
import 'shop_details.dart';

class Home extends StatefulWidget {
  const Home(
      {Key? key,
      menuScreenContext,
      bool? hideStatus,
      Null Function()? onScreenHideButtonPressed})
      : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CategoryServices _categoryServices = CategoryServices();
  ProductServices _productServices = ProductServices();
  AddShopServices _shopServices = AddShopServices();
  ShopUserServices _userServicesRental = ShopUserServices();
  UserServices _userServicesuser = UserServices();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) _initFcm();
    super.initState();
  }

  Future<void> _initFcm() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    _firebaseMessaging.getToken().then((token) {
      FirebaseFirestore.instance.collection('deviceTokens').doc(uid).set(
        {
          'deviceTokens': token,
        },
      );
    });
  }

  int activeindex = 0;
  final urlImages = [
    // Res.mobileapplication,
    // Res.easypaisa,
    // Res.shopping,
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: StreamProvider.value(
            value: _userServicesuser
                .fetchUserRecord(FirebaseAuth.instance.currentUser!.uid),
            initialData: UserModel(),
            builder: (context, child) {
              UserModel model = context.watch<UserModel>();
              return Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(MyProfileScreen());
                              },
                              child: Container(
                                child: Stack(
                                  children: [
                                    model.userImage == null
                                        ? CircleAvatar(
                                            radius: 25,
                                            backgroundImage:
                                                AssetImage(Res.personicon),
                                          )
                                        : CachedNetworkImage(
                                            height: 50,
                                            width: 50,
                                            imageBuilder: (context,
                                                    imageProvider) =>
                                                Container(
                                                  width: 50.0,
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                            imageUrl:
                                                model.userImage.toString(),
                                            fit: BoxFit.cover,
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                SpinKitWave(
                                                    color: MyAppColors.appColor,
                                                    size: 30,
                                                    type:
                                                        SpinKitWaveType.start),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error))
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(model.fullName.toString(),
                                style: GoogleFonts.roboto(
                                    // fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24)),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(CartView());
                          },
                          child: Icon(
                            Icons.shopping_cart,
                            color: MyAppColors.appColor,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 7,
                          child: InkWell(
                            onTap: () {
                              pushNewScreen(context,
                                  withNavBar: true, screen: ViewAllProducts());
                            },
                            child: Container(
                              height: 52,
                              width: 295,
                              decoration: BoxDecoration(
                                  color: MyAppColors.bgtextfieldcolor,
                                  borderRadius: BorderRadius.circular(13)),
                              child: TextFormField(
                                readOnly: true,
                                onTap: () {
                                  pushNewScreen(context,
                                      withNavBar: true,
                                      screen: ViewAllProducts());
                                },
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        left: 25, top: 15),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 140,
                      width: MediaQuery.of(context).size.width,
                      child: CarouselSlider.builder(
                        itemCount: urlImages.length,
                        options: CarouselOptions(
                          viewportFraction: 1,
                          autoPlay: true,
                          aspectRatio: 2.0,
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason) =>
                              setState(() => activeindex = index),
                        ),
                        itemBuilder: (context, index, realIdx) {
                          return Container(
                            child: Center(
                                child: Image.network(urlImages[index],
                                    fit: BoxFit.fill, width: 1000)),
                          );
                        },
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  buildIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Categories",
                            style: GoogleFonts.roboto(
                                // fontFamily: 'Gilroy',
                                //color: MyAppColors.appColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 20)),
                        Text("View all",
                            style: GoogleFonts.roboto(
                                // fontFamily: 'Gilroy',
                                color: MyAppColors.blue,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                                fontSize: 15)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  StreamProvider.value(
                      value: _categoryServices.streamCategories(),
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
                            : list[0].shopId == null
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 30.0),
                                      child: SpinKitWave(
                                          color: Colors.green,
                                          type: SpinKitWaveType.start),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(left: 7),
                                    child: Container(
                                      //color: Colors.green,
                                      height: 90,
                                      width: double.infinity,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: list.length,
                                          shrinkWrap: true,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (context, i) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Container(
                                                // color: Colors.red,
                                                child: categoryWidget(
                                                  list[i].shopId.toString(),
                                                  list[i].categoryId.toString(),
                                                  list[i]
                                                      .categoryImage
                                                      .toString(),
                                                  list[i]
                                                      .categoryName
                                                      .toString(),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  );
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Products on Rent",
                            style: GoogleFonts.roboto(
                                // fontFamily: 'Gilroy',
                                //color: MyAppColors.appColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 20)),
                        InkWell(
                          onTap: () {
                            Get.to(ViewAllProducts());
                          },
                          child: Text("View all",
                              style: GoogleFonts.roboto(
                                  // fontFamily: 'Gilroy',
                                  color: MyAppColors.blue,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  StreamProvider.value(
                      value: _productServices.streamProducts(),
                      initialData: [ProductModel()],
                      builder: (context, child) {
                        //     contactListDB = context.watch<List<EventModel>>();
                        List<ProductModel> list =
                            context.watch<List<ProductModel>>();
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
                                          size: 30,
                                          type: SpinKitWaveType.start),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(left: 1),
                                    child: Container(
                                      height: 90,
                                      width: double.infinity,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: list.length,
                                          shrinkWrap: true,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (context, i) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: ProductWidget(
                                                //  list[i].productId.toString(),
                                                list[i].categoryId.toString(),
                                                list[i].productName.toString(),
                                                list[i].productPrice.toString(),
                                                list[i]
                                                    .productquantity
                                                    .toString(),
                                                list[i].productDesc.toString(),
                                                list[i].productImage.toString(),
                                              ),
                                            );
                                          }),
                                    ),
                                  );
                      }),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Rental Shops",
                            style: GoogleFonts.roboto(
                                // fontFamily: 'Gilroy',
                                //color: MyAppColors.appColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 20)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  StreamProvider.value(
                      value: _shopServices.streamShops(),
                      initialData: [AddShopModel()],
                      builder: (context, child) {
                        //     contactListDB = context.watch<List<EventModel>>();
                        List<AddShopModel> list =
                            context.watch<List<AddShopModel>>();
                        return list.isEmpty
                            ? Center(
                                child: Padding(
                                padding: const EdgeInsets.only(top: 100.0),
                                child: Text("No Past Event Available",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20)),
                              ))
                            : list[0].shopID == null
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 50.0),
                                      child: SpinKitWave(
                                          color: Colors.green,
                                          size: 30,
                                          type: SpinKitWaveType.start),
                                    ),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: list.length,
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, i) {
                                      return StreamProvider.value(
                                          value: _userServicesRental
                                              .fetchUserRecord(
                                                  list[i].userID.toString()),
                                          initialData: ShopUserModel(),
                                          builder: (context, child) {
                                            ShopUserModel _userrentalModel =
                                                context.watch<ShopUserModel>();
                                            // return StreamProvider.value(
                                            //     value: _productServices
                                            //         .streamonlyProducts(
                                            //             list[i].userID.toString()),
                                            //     initialData: ProductModel(),
                                            //     builder: (context, child) {
                                            //       ProductModel _productmodel =
                                            //           context.watch<ProductModel>();
                                            return StreamProvider.value(
                                              value: _userServicesuser
                                                  .fetchUserRecord(list[i]
                                                      .userID
                                                      .toString()),
                                              initialData: UserModel(),
                                              builder: (context, child) {
                                                UserModel _useruserModel =
                                                    context.watch<UserModel>();

                                                return Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: ShopCardWidget(
                                                      //  list[i].productId.toString(),
                                                      list[i]
                                                          .shopName
                                                          .toString(),
                                                      list[i].shopID.toString(),
                                                      _userrentalModel.fullName
                                                          .toString(),
                                                      _userrentalModel.userImage
                                                          .toString(),
                                                      _userrentalModel.userID
                                                          .toString(),
                                                      _useruserModel.userID
                                                          .toString(),
                                                      _userrentalModel
                                                          .shopStatus
                                                          .toString()
                                                      //  _productmodel.UserId.toString()

                                                      // list[i].productPrice.toString(),
                                                      // list[i].productquantity.toString(),
                                                      // list[i].productDesc.toString(),
                                                      // list[i].productImage.toString(),
                                                      ),
                                                );
                                              },
                                            );
                                          });
                                    });
                        //    });
                      }),
                ],
              );
            }),
      ),
    ));
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeindex,
        count: urlImages.length,
        effect: WormEffect(
            dotHeight: 11, dotWidth: 11, activeDotColor: MyAppColors.appColor),
      );
}
