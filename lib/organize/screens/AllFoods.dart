import 'package:construction/common/colors.dart';
import 'package:construction/models/food.dart';
import 'package:construction/organize/screens/FoodDetailsScreen.dart';
import 'package:construction/services/food_service.dart';
import 'package:construction/services/userService.dart';
import 'package:flutter/material.dart';

class AllFoods extends StatefulWidget {
  const AllFoods({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AllFoodsState createState() => _AllFoodsState();
}

class _AllFoodsState extends State<AllFoods> {
  final FoodService foodService = FoodService();
  List<Food>? _Foods;
  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    _getAllFoods();
  }

  _getAllFoods() async {
    Map<String, dynamic> user = await userService.getCurrentUser();
    String? restaurantId = user['id'];
    List<Food> Foods = await foodService.getAllFoods(restaurantId!);
    setState(() {
      _Foods = Foods;
    });
  }

  void _filterFoods(String searchTerm) {
    List<Food> filteredFoods =
        _Foods!.where((food) => food.name!.contains(searchTerm)).toList();
    setState(() {
      _Foods = filteredFoods;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 50,
            // ignore: prefer_const_constructors
            child: Center(
              // ignore: prefer_const_constructors
              child: Text(
                'EAT ON CAMPUS',
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                    fontFamily: 'Times new roman'),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search for a Foods',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onChanged: (value) {
                  _filterFoods(value);
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _Foods != null
                ? ListView.separated(
                    itemCount: _Foods!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FoodDetailsScreen(
                                food: _Foods![index],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          child: Padding(
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
                                          image: NetworkImage(
                                              _Foods![index].picture!),
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
                                          _Foods![index].name!,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          _Foods![index].category!,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          '${_Foods![index].price}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.red,
                                      onPressed: () async {
                                        foodService
                                            .deleteFood(_Foods![index].foodId!);
                                        _getAllFoods();
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 16);
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
