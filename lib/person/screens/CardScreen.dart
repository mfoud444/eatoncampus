import 'package:construction/common/widgets/CustomIconButton.dart';
import 'package:construction/models/food.dart';
import 'package:construction/models/organize.dart';
import 'package:construction/services/SharedPreferencesHelper.dart';
import 'package:construction/services/food_service.dart';
import 'package:construction/person/screens/AllTables.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardScreen extends StatefulWidget {
  final Organize restaurant;

  const CardScreen({required this.restaurant});
  @override
  _CardScreenState createState() => _CardScreenState(restaurant: restaurant);
}

class _CardScreenState extends State<CardScreen> {
  final Organize restaurant;
  _CardScreenState({required this.restaurant});
  final FoodService _foodService = FoodService();
  final SharedPreferencesHelper _sharedPreferencesHelper =
      SharedPreferencesHelper();
  late Map<String, int> _quantities;
  double _total = 0;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _getQuantities();
  }

  Future<void> _getQuantities() async {
    _quantities = await _sharedPreferencesHelper.getQuantities();
  }

  Future<void> _updateQuantity(String foodId, int quantity) async {
    await _sharedPreferencesHelper.saveQuantity(foodId, quantity);
    _getQuantities();
    setState(() {});
  }

  _sendOrder() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getFoods(),
        builder: (BuildContext context, AsyncSnapshot<List<Food>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Icon(Icons.remove_shopping_cart,
                        size: 60, color: Colors.grey),
                    const SizedBox(height: 20),
                    const Text("Your cart is empty",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
              );
            }
            snapshot.data!.forEach((food) {
              _total += (food.price! * _quantities[food.foodId]!);
            });
            return ListView.builder(
              itemCount: snapshot.data!.length + 1, // changed
              itemBuilder: (BuildContext context, int index) {
                if (index == snapshot.data!.length) {
                  // added
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text('$_total RS',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomIconButton(
                          label: 'Complete Order',
                          icon: Icons.arrow_forward,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TableScreen(restaurant: restaurant),
                            ),
                          ),
                          isLoading: _isLoading,
                        ),
                      ],
                    ),
                  );
                } else {
                  final Food food = snapshot.data![index];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 16,
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(food.picture!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      food.name!.toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${food.price} RS',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.remove_circle),
                                      onPressed: () {
                                        if (_quantities[food.foodId] != 0) {
                                          final int newQuantity =
                                              _quantities[food.foodId]! - 1;
                                          _updateQuantity(
                                              food.foodId!, newQuantity);
                                        }
                                      },
                                    ),
                                    Text(_quantities[food.foodId].toString()),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle),
                                      onPressed: () {
                                        final int newQuantity =
                                            _quantities[food.foodId]! + 1;
                                        _updateQuantity(
                                            food.foodId!, newQuantity);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      color: Colors.red,
                                      onPressed: () async {
                                        await _sharedPreferencesHelper
                                            .remove(food.foodId!);
                                        _getQuantities();
                                        setState(() {});
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<List<Food>> _getFoods() async {
    final Map<String, int> quantities =
        await _sharedPreferencesHelper.getQuantities();
    final List<Food> foods = [];
    for (String foodId in quantities.keys) {
      final bool containsFoodId =
          await _sharedPreferencesHelper.containsFoodId(foodId);
      if (containsFoodId) {
        final List<Food> foodList = await _foodService.getFoodsById(foodId);
        for (Food food in foodList) {
          if (food.restaurantId == restaurant.id) {
            foods.add(food);
          }
        }
      }
    }
    return foods;
  }
}
