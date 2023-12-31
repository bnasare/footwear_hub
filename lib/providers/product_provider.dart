import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/products_models.dart';

class ProductProvider extends ChangeNotifier {
  static List<ProductModel> productsList = [];
  List<ProductModel> searchList = productsList;

  List<ProductModel> get getProducts {
    return productsList;
  }

  List<ProductModel> get getOnSaleProducts {
    return productsList.where((element) => element.isOnSale).toList();
  }

  Future<void> fetchProducts() async {
    await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot productSnapshot) {
      productsList.clear();

      for (var element in productSnapshot.docs) {
        productsList.insert(
          0,
          ProductModel(
            id: element.get('id'),
            title: element.get('title'),
            imageUrl: element.get('imageUrl'),
            productCategoryName: element.get('productCategoryName'),
            price: double.parse(element.get('price')),
            salePrice: element.get('salePrice'),
            isOnSale: element.get('isOnSale'),
            isBulk: element.get('isBulk'),
          ),
        );
      }
    });
    notifyListeners();
  }

  ProductModel findProdById(String productId) {
    return productsList.firstWhere((element) => element.id == productId);
  }

  List<ProductModel> findByCategory(String categoryName) {
    List<ProductModel> categoryList = productsList
        .where((element) => element.productCategoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return categoryList;
  }

  List<ProductModel> searchQuery(String searchText) {
    List<ProductModel> searchList = productsList
        .where(
          (element) => element.title.toLowerCase().contains(
                searchText.toLowerCase(),
              ),
        )
        .toList();
    return searchList;
  }

  // static final List<ProductModel> productsList = [
  //   // Adidas
  //   ProductModel(
  //     id: 'Adidas1',
  //     title: 'Adidas Ultra Boost',
  //     price: 129.99,
  //     salePrice: 99.99,
  //     imageUrl: 'https://cdn.flightclub.com/750/TEMPLATE/349320/1.jpg',
  //     productCategoryName: 'Adidas',
  //     isOnSale: true,
  //     isSingle: true,
  //   ),
  //   ProductModel(
  //     id: 'Adidas2',
  //     title: 'Adidas Superstar',
  //     price: 89.99,
  //     salePrice: 69.99,
  //     imageUrl: 'https://m.media-amazon.com/images/I/71SObVJbR-L._SX700_.jpg',
  //     productCategoryName: 'Adidas',
  //     isOnSale: false,
  //     isSingle: true,
  //   ),
  //   // Nike
  //   ProductModel(
  //     id: 'Nike1',
  //     title: 'Nike Air Max',
  //     price: 139.99,
  //     salePrice: 119.99,
  //     imageUrl:
  //         'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/4cc253d2-6c9b-40b4-924c-e87b75c43614/air-max-scorpion-flyknit-shoes-ZWsC0D.png',
  //     productCategoryName: 'Nike',
  //     isOnSale: true,
  //     isSingle: true,
  //   ),
  //   ProductModel(
  //     id: 'Nike2',
  //     title: 'Nike Roshe Run',
  //     price: 79.99,
  //     salePrice: 59.99,
  //     imageUrl:
  //         'https://static.nike.com/a/images/t_default/czjd6ldflyzx5ev12yxw/roshe-one-womens-shoe-ol9k1O.png',
  //     productCategoryName: 'Nike',
  //     isOnSale: false,
  //     isSingle: true,
  //   ),
  //   // Fashion
  //   ProductModel(
  //     id: 'KennethCole1',
  //     title: 'Kenneth Cole Classic Loafer',
  //     price: 149.99,
  //     salePrice: 129.99,
  //     imageUrl:
  //         'https://m.media-amazon.com/images/I/41ixFKrJDqL._AC_UY1000_.jpg',
  //     productCategoryName: 'Fashion',
  //     isOnSale: true,
  //     isSingle: true,
  //   ),
  //   ProductModel(
  //     id: 'KennethCole2',
  //     title: 'Kenneth Cole Reaction',
  //     price: 149.99,
  //     salePrice: 129.99,
  //     imageUrl:
  //         'https://di2ponv0v5otw.cloudfront.net/posts/2022/09/25/6330de0fc5df6cff5570ad12/m_6330de844bc655d4df13c8fd.jpg',
  //     productCategoryName: 'Fashion',
  //     isOnSale: true,
  //     isSingle: true,
  //   ),
  //   // Heels
  //   ProductModel(
  //     id: 'Heels1',
  //     title: 'High Heel Stiletto',
  //     price: 59.99,
  //     salePrice: 39.99,
  //     imageUrl: 'https://shoeiq.com/wp-content/uploads/stiletto-heels.jpg',
  //     productCategoryName: 'Heels',
  //     isOnSale: true,
  //     isSingle: true,
  //   ),
  //   // Timberland
  //   ProductModel(
  //     id: 'Timberland1',
  //     title: 'Timberland Waterproof Boot',
  //     price: 179.99,
  //     salePrice: 149.99,
  //     imageUrl:
  //         'https://www.ubuy.com.gh/productimg/?image=aHR0cHM6Ly9tLm1lZGlhLWFtYXpvbi5jb20vaW1hZ2VzL0kvNzFEdTVNT2pYMEwuX0FDX1VMMTUwMF8uanBn.jpg',
  //     productCategoryName: 'Timberland',
  //     isOnSale: true,
  //     isSingle: true,
  //   ),
  //   // Puma
  //   ProductModel(
  //     id: 'Puma1',
  //     title: 'Puma Running Shoe',
  //     price: 99.99,
  //     salePrice: 79.99,
  //     imageUrl:
  //         'https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_450,h_450/global/192257/12/sv01/fnd/SEA/fmt/png',
  //     productCategoryName: 'Puma',
  //     isOnSale: true,
  //     isSingle: true,
  //   ),
  // ];
}
