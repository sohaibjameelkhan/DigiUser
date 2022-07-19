
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/cart_provider.dart';

class OrderHelper {
  static num orderPriceCalculator(BuildContext context) {
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    num total = 0;
    cartProvider.getCartList.map((e) {
      total += e.totalPrice!;
    }).toList();
    return total;
  }
}
