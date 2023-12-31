import 'package:e_commerce/providers/cart_provider.dart';
import 'package:e_commerce/providers/wishlist_provider.dart';
import 'package:e_commerce/services/utils.dart';
import 'package:e_commerce/widgets/heart_button.dart';
import 'package:e_commerce/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../consts/dialog_box.dart';
import '../consts/firebase_consts.dart';
import '../inner_screens/product_details.dart';
import '../models/products_models.dart';
import 'price_widget.dart';

class OnSaleWidget extends StatefulWidget {
  const OnSaleWidget({Key? key}) : super(key: key);

  @override
  State<OnSaleWidget> createState() => _OnSaleWidgetState();
}

class _OnSaleWidgetState extends State<OnSaleWidget> {
  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<ProductModel>(context);
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    final wishListProvider = Provider.of<WishListProvider>(context);
    bool? isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    bool? isInWishList =
        wishListProvider.getWishListItems.containsKey(productModel.id);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: size.height * 0.58,
        width: size.width * 0.43,
        child: Material(
          color: Theme.of(context).cardColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.pushNamed(context, ProductDetailsScreen.routeName,
                  arguments: productModel.id);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FancyShimmerImage(
                        imageUrl: productModel.imageUrl,
                        height: size.width * 0.22,
                        width: size.width * 0.22,
                        boxFit: BoxFit.fill,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          TextWidget(
                            text: productModel.isBulk ? '1KG' : '1PC',
                            color: color,
                            textSize: 22,
                            isTitle: true,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: isInCart
                                    ? null
                                    : () async {
                                        final User? user =
                                            authInstance.currentUser;
                                        if (user == null) {
                                          AlertDialogs.errorDialog(
                                            subtitle:
                                                'No user found. Please login first.',
                                            context: context,
                                          );
                                          return;
                                        }
                                        await cartProvider.addToCart(
                                            context: context,
                                            productId: productModel.id,
                                            quantity: 1);
                                        cartProvider.fetchCart();
                                      },
                                child: Icon(
                                  isInCart ? IconlyBold.bag2 : IconlyLight.bag2,
                                  size: 22,
                                  color: isInCart ? Colors.green : color,
                                ),
                              ),
                              HeartButton(
                                productId: productModel.id,
                                isInWishList: isInWishList,
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  PriceWidget(
                    salePrice: productModel.salePrice,
                    price: productModel.price,
                    textPrice: '1',
                    isOnSale: true,
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    flex: 6,
                    child: TextWidget(
                      text: productModel.title,
                      maxLines: 1,
                      color: color,
                      textSize: 20,
                      isTitle: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
