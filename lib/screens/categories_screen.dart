// ignore_for_file: must_be_immutable

import 'package:e_commerce/services/utils.dart';
import 'package:e_commerce/widgets/categories_widget.dart';
import 'package:e_commerce/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({Key? key}) : super(key: key);

  List<Color> gridColors = [
    const Color(0xff53B175),
    const Color(0xffF8A44C),
    const Color(0xffF7A593),
    const Color(0xffD3B0E0),
    const Color(0xffFDE598),
    const Color(0xffB7DFF5),
  ];

  List<Map<String, dynamic>> catInfo = [
    {
      'imgPath': 'assets/images/cat/fruits.jpeg',
      'catText': 'Adidas',
    },
    {
      'imgPath': 'assets/images/cat/veg.jpeg',
      'catText': 'Puma',
    },
    {
      'imgPath': 'assets/images/cat/spinach.jpeg',
      'catText': 'Nike',
    },
    {
      'imgPath': 'assets/images/cat/nuts.jpeg',
      'catText': 'Timberland',
    },
    {
      'imgPath': 'assets/images/cat/spices.jpeg',
      'catText': 'Heels',
    },
    {
      'imgPath': 'assets/images/cat/grains.jpeg',
      'catText': 'Fashion',
    },
  ];
  @override
  Widget build(BuildContext context) {
    final utils = Utils(context);
    Color color = utils.color;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: TextWidget(
            text: 'Categories',
            color: color,
            textSize: 24,
            isTitle: true,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 240 / 250,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: List.generate(6, (index) {
              return CategoriesWidget(
                catText: catInfo[index]['catText'],
                imgPath: catInfo[index]['imgPath'],
                passedColor: gridColors[index],
              );
            }),
          ),
        ));
  }
}
