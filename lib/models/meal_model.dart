import 'foodItem_model.dart';

class MealModel {
  final FoodItemModel foodItem;
  final double gramsConsumed;
  final DateTime timestamp;
  final double calculatedCalories;
  final double calculatedProtein;
  final double calculatedCarbs;
  final double calculatedFat;

  MealModel({
    required this.foodItem,
    required this.gramsConsumed,
    required this.timestamp,
  }) : calculatedCalories = (foodItem.baseCalories / 100) * gramsConsumed,
       calculatedProtein = (foodItem.baseProtein / 100) * gramsConsumed,
       calculatedCarbs = (foodItem.baseCarbs / 100) * gramsConsumed,
       calculatedFat = (foodItem.baseFat / 100) * gramsConsumed;

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      foodItem: FoodItemModel.fromFirestore(json['foodItem']),
      gramsConsumed: json['gramsConsumed'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodItem': foodItem.toJson(),
      'gramsConsumed': gramsConsumed,
      'timestamp': timestamp.toIso8601String(),
      'calculatedCalories': calculatedCalories,
      'calculatedProtein': calculatedProtein,
      'calculatedCarbs': calculatedCarbs,
      'calculatedFat': calculatedFat,
    };
  }
}
