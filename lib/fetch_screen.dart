import 'package:e_commerce/consts/consts.dart';
import 'package:e_commerce/consts/firebase_consts.dart';
import 'package:e_commerce/providers/cart_provider.dart';
import 'package:e_commerce/screens/bottom_bar_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'providers/orders_provider.dart';
import 'providers/product_provider.dart';
import 'providers/wishlist_provider.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({super.key});

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  var images = Consts.authImagesPaths;

  @override
  void initState() {
    super.initState();
    images.shuffle();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.delayed(const Duration(microseconds: 5), () async {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final wishListProvider =
          Provider.of<WishListProvider>(context, listen: false);
      final ordersProvider =
          Provider.of<OrdersProvider>(context, listen: false);
      final User? user = authInstance.currentUser;
      if (user == null) {
        await productProvider.fetchProducts();
        cartProvider.clearCart();
        wishListProvider.clearWishList();
        ordersProvider.clearOrders();
      } else {
        await productProvider.fetchProducts();
        await cartProvider.fetchCart();
        await wishListProvider.fetchWishList();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomBarScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(images[0], fit: BoxFit.cover, height: double.infinity),
          Container(color: Colors.black.withOpacity(0.7)),
          const Center(child: SpinKitFadingCircle(color: Colors.white))
        ],
      ),
    );
  }
}
