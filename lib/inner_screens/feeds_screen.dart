import 'package:e_commerce/widgets/feeds_items_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../models/products_models.dart';
import '../providers/product_provider.dart';
import '../services/utils.dart';
import '../widgets/empty_prod.dart';
import '../widgets/text_widget.dart';

class FeedsScreen extends StatefulWidget {
  static const routeName = "/FeedsScreen";
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  List<ProductModel> listProductSearch = [];

  final TextEditingController? searchTextController = TextEditingController();
  final FocusNode searchTextFocusNode = FocusNode();
  @override
  void dispose() {
    searchTextController!.dispose();
    searchTextFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final productProvider = Provider.of<ProductProvider>(context);
    List<ProductModel> allProducts = productProvider.getProducts;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            IconlyLight.arrowLeft2,
            color: color,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: TextWidget(
          text: 'All Products',
          color: color,
          textSize: 20.0,
          isTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: kBottomNavigationBarHeight,
              child: TextField(
                focusNode: searchTextFocusNode,
                controller: searchTextController,
                onChanged: (value) {
                  setState(() {
                    listProductSearch = productProvider.searchQuery(value);
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.greenAccent, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.greenAccent, width: 1),
                  ),
                  hintText: "What's in your mind",
                  prefixIcon: const Icon(Icons.search),
                  suffix: IconButton(
                    onPressed: () {
                      searchTextController!.clear();
                      searchTextFocusNode.unfocus();
                      setState(() {
                        listProductSearch.clear();
                      });
                    },
                    icon: Icon(
                      Icons.close,
                      color: searchTextFocusNode.hasFocus ? Colors.red : color,
                    ),
                  ),
                ),
              ),
            ),
          ),
          searchTextController!.text.isNotEmpty && listProductSearch.isEmpty
              ? const EmptyProductScreen(
                  text:
                      'No products matched your search. Please try a different keyword')
              : GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  padding: EdgeInsets.zero,
                  childAspectRatio: 0.7,
                  children: List.generate(
                      searchTextController!.text.isNotEmpty
                          ? listProductSearch.length
                          : allProducts.length, (index) {
                    return ChangeNotifierProvider.value(
                        value: searchTextController!.text.isNotEmpty
                            ? listProductSearch[index]
                            : allProducts[index],
                        child: const FeedsWidget());
                  }),
                ),
        ]),
      ),
    );
  }
}
