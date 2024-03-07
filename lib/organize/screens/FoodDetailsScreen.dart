import 'package:construction/models/food.dart';
import 'package:flutter/material.dart';

class FoodDetailsScreen extends StatelessWidget {
  final Food food;

  const FoodDetailsScreen({Key? key, required this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(food.name.toString())),
      body: Column(
        children: [
          Image.network(food.picture!),
          Text(food.name.toString()),
          Text(food.category.toString()),
          Text(food.price.toString()),
        ],
      ),
    );
  }
}