import 'package:flutter/material.dart';

class Cardmodel {
  String title;
  String jobDescription;
  String description;
  String image;

  Cardmodel({required this.title, required this.description, required this.image, required this.jobDescription});
  
  static List<Cardmodel> getCards() {
    return <Cardmodel>[
      Cardmodel(
          title: 'Software Development',
          description: 'Tunis, Tunisia',
          jobDescription: "lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua  ",
          image: 'assets/images/meta.png'),
      Cardmodel(
          title: 'Design',
          description: 'Tunis, Tunisia',
          jobDescription: "lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua  ",
          image: 'assets/images/EY.svg'),
      Cardmodel(
          title: 'Marketing',
          description: 'Tunis, Tunisia',
          jobDescription: "lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua  ",
          image: 'assets/images/marketing.svg'),
      Cardmodel(
          title: 'Finance',
          description: 'Tunis, Tunisia',
          jobDescription: "lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua  ",
          image: 'assets/images/Nvidia.svg'),
      
    ];
  }
}