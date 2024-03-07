import 'package:construction/models/food.dart';
import 'package:construction/models/organize.dart';
import 'package:construction/services/SharedPreferencesHelper.dart';
import 'package:construction/services/food_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final Organize restaurant;

  const RestaurantDetailsScreen({Key? key, required this.restaurant})
      : super(key: key);

  @override
  _RestaurantDetailsScreenState createState() =>
      _RestaurantDetailsScreenState(restaurant: restaurant);
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  final Organize restaurant;
  _RestaurantDetailsScreenState({required this.restaurant});
  final FoodService foodService = FoodService();
  final List<String> categories = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];
  String selectedCategory = 'Breakfast';
  Map<String, int> quantities = {};

  final SharedPreferencesHelper _sharedPreferencesHelper =
      SharedPreferencesHelper();
  @override
  void initState() {
    super.initState();
    _getQuantities();
  }

  Future<void> _saveQuantity(String foodId, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(foodId, quantity);
  }

  Future<void> _getQuantities() async {
    quantities = await _sharedPreferencesHelper.getQuantities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            child: Image.network(
              widget.restaurant.picture!,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = categories[index];
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        fontSize: 18,
                        color: selectedCategory == categories[index]
                            ? Colors.green
                            : Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Food>>(
                future: foodService.getFoodsByCategory(
                    restaurant.id!, selectedCategory),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Food>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        Food food = snapshot.data![index];
                        if (food != null) {
                          // If the food quantity is not present in the quantities map, set it to 0
                          if (!quantities.containsKey(food.foodId)) {
                            quantities[food.foodId!] = 0;
                          }
                          return Padding(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            if (quantities[food.foodId] != 0) {
                                              setState(() {
                                                // Decrement the quantity value
                                                int currentQuantity =
                                                    quantities[food.foodId]!;
                                                currentQuantity =
                                                    currentQuantity - 1;
                                                quantities[food.foodId!] =
                                                    currentQuantity;
                                                // Save the updated value to SharedPreferences
                                                _saveQuantity(food.foodId!,
                                                    currentQuantity);
                                              });
                                            }
                                          },
                                        ),
                                        Text(
                                            quantities[food.foodId].toString()),
                                        IconButton(
                                            icon: Icon(Icons.add_circle),
                                            onPressed: () {
                                              setState(() {
                                                int currentQuantity =
                                                    quantities[food.foodId]!;
                                                currentQuantity =
                                                    currentQuantity + 1;
                                                quantities[food.foodId!] =
                                                    currentQuantity;
                                                _saveQuantity(food.foodId!,
                                                    currentQuantity);
                                              });
                                            }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const Center(child: Text("Not found food"));
                        }
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  } else {
                    // ignore: prefer_const_constructors
                    return Center(
                      child: const CircularProgressIndicator(),
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}
