import 'package:shared_preferences/shared_preferences.dart';

class  SharedPreferencesHelper {
  Future<void> saveQuantity(String foodId, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(foodId, quantity);
  }
  
 Future<void> remove(String foodId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(foodId);
  }
  Future<Map<String, int>> getQuantities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, int> quantities = {};
    prefs.getKeys().forEach((String key) {
      quantities[key] = prefs.getInt(key)!;
    });
    return quantities;
  }

  Future<bool> containsFoodId(String foodId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(foodId);
  }
}
