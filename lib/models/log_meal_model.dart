import 'meal_model.dart';

class DailyLogModel {
  final String dateId;
  final String userId;
  final List<MealModel> meals;

  DailyLogModel({
    required this.dateId,
    required this.userId,
    required this.meals,
  });

  double get totalCalories =>
      meals.fold(0, (sum, meal) => sum + meal.calculatedCalories);
  double get totalProtein =>
      meals.fold(0, (sum, meal) => sum + meal.calculatedProtein);
  double get totalCarbs =>
      meals.fold(0, (sum, meal) => sum + meal.calculatedCarbs);
  double get totalFat => meals.fold(0, (sum, meal) => sum + meal.calculatedFat);

  factory DailyLogModel.fromJson(Map<String, dynamic> json) {
    var mealList = json['meals'] as List;
    List<MealModel> parsedMeals = mealList
        .map((i) => MealModel.fromJson(i))
        .toList();

    return DailyLogModel(
      dateId: json['dateId'],
      userId: json['userId'],
      meals: parsedMeals,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateId': dateId,
      'userId': userId,
      'meals': meals.map((meal) => meal.toJson()).toList(),
    };
  }
}
