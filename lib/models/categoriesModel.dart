import 'package:flutter/material.dart';

class CategoriesModel {
  String name;
  String image;
  Color boxColor;

  CategoriesModel(
      {required this.name, required this.image, required this.boxColor});

  static List<CategoriesModel> getCategories() {
    return <CategoriesModel>[
      CategoriesModel(
          name: 'IT',
          image: 'assets/images/software-development.png',
          boxColor: Colors.blueAccent),
      CategoriesModel(
          name: 'Design',
          image: 'assets/images/creation-de-sites-web.png',
          boxColor: Colors.redAccent),
      CategoriesModel(
          name: 'Marketing',
          image: 'assets/images/digital-marketing.png',
          boxColor: Colors.greenAccent),
      CategoriesModel(
          name: 'Finance',
          image: 'assets/images/croissance.png',
          boxColor: Colors.purpleAccent),
      CategoriesModel(
          name: 'Engineering',
          image: 'assets/images/civil-engineering.png',
          boxColor: Colors.orangeAccent),
      CategoriesModel(
          name: 'Health',
          image: 'assets/images/health-and-care.png',
          boxColor: Colors.pinkAccent),
      CategoriesModel(
          name: 'Education',
          image: 'assets/images/apprendre.png',
          boxColor: Colors.tealAccent),
      CategoriesModel(
          name: 'Sales',
          image: 'assets/images/croissance.png',
          boxColor: Colors.amberAccent),
      CategoriesModel(
          name: 'Service',
          image: 'assets/images/customer-review.png',
          boxColor: Colors.indigoAccent),
    ];
  }
}
