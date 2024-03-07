import 'package:construction/common/colors.dart';
import 'package:construction/models/organize.dart';
import 'package:construction/person/screens/RestaurantDetailsScreen.dart';
import 'package:construction/person/screens/RestaurantHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:construction/services/organizeService.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RestaurantListScreenState createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  final _restaurantService = OrganizeService('market');
  List<Organize>? _restaurants;
  TextEditingController _searchController = TextEditingController();
  List<Organize>? _filteredRestaurants;

  @override
  void initState() {
    super.initState();
    _getAllRestaurants();
  }

  _getAllRestaurants() async {
    List<Organize> restaurants = await _restaurantService.getAllOrganizes();
    setState(() {
      _restaurants = restaurants;
      _filteredRestaurants = restaurants;
    });
  }

  void _filterRestaurants(String searchTerm) {
    setState(() {
      _filteredRestaurants = _restaurants?.where((restaurant) {
        return restaurant.name!
            .toLowerCase()
            .contains(searchTerm.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 50,
            child: Center(
              child: const Text(
                'EAT ON CAMPUS',
                style: TextStyle(
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
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search for a restaurant or cafe',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                controller: _searchController,
                onChanged: (searchTerm) {
                  _filterRestaurants(searchTerm);
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: _filteredRestaurants != null
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: ListView.separated(
                      itemCount: _filteredRestaurants!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => RestaurantHomeScreen(
                                  restaurant: _filteredRestaurants![index],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 16,
                              ),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              _filteredRestaurants![index]
                                                  .picture!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _filteredRestaurants![index].name!,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      _filteredRestaurants![index].openingTime!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                    ),
                  )
                : Center(child: const CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
