import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/foodItem_model.dart';

class FoodApiService {
  Future<FoodItemModel?> fetchFoodByBarcode(String barcode) async {
    final url = Uri.parse(
      'https://world.openfoodfacts.org/api/v0/product/$barcode.json',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 1) {
          return FoodItemModel.fromJson(data['product'], barcode);
        } else {
          print('Product not found in Open Food Facts database.');
          return null;
        }
      } else {
        print('API Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Network or Parsing Error: $e');
      return null;
    }
  }
}
