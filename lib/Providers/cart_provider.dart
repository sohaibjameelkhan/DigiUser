

import 'package:flutter/material.dart';

import '../Models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> _list = [];

  void saveCartData(CartModel cartModel) {
    _list.add(cartModel);
    notifyListeners();
  }

  List<CartModel> get getCartList => _list;

  void emptyMyLocalCart() {
    _list.clear();
    notifyListeners();
  }
}
