import 'package:flutter/material.dart';
import '../models/log_meal_model.dart';
import '../models/meal_model.dart';
import '../models/user_goal_model.dart';
import '../models/foodItem_model.dart';
import '../services/firestore_service.dart';
import '../services/local_storage_service.dart';
import '../services/food_api_service.dart';

class TrackerProvider extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();
  final LocalStorageService _localStorage = LocalStorageService();
  final FoodApiService _foodApi = FoodApiService();
  List<bool> weeklyStreak = [false, false, false, false, false, false, false];

  UserGoalModel? currentGoals;
  DailyLogModel? todayLog;
  bool isLoading = false;

  Future<void> loadData(String userId) async {
    isLoading = true;
    notifyListeners();

    currentGoals = await _localStorage.getUserGoals();
    String today = DateTime.now().toIso8601String().split('T').first;
    todayLog =
        await _firestore.getDailyLog(userId, today) ??
        DailyLogModel(dateId: today, userId: userId, meals: []);
    await calculateWeeklyStreak(userId);
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateGoals(UserGoalModel newGoals) async {
    currentGoals = newGoals;
    await _localStorage.saveUserGoals(newGoals);
    notifyListeners();
  }

  Future<void> scanAndLogMeal(
    String barcode,
    double grams,
    String userId,
  ) async {
    isLoading = true;
    notifyListeners();

    FoodItemModel? food = await _foodApi.fetchFoodByBarcode(barcode);

    if (food != null && todayLog != null) {
      MealModel newMeal = MealModel(
        foodItem: food,
        gramsConsumed: grams,
        timestamp: DateTime.now(),
      );

      todayLog!.meals.add(newMeal);
      await _firestore.saveDailyLog(todayLog!);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> calculateWeeklyStreak(String userId) async {
    List<bool> calculatedStreak = [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ];

    for (int i = 0; i < 7; i++) {
      DateTime pastDate = DateTime.now().subtract(Duration(days: i));
      String dateString = pastDate.toIso8601String().split('T').first;
      final pastLog = await _firestore.getDailyLog(userId, dateString);

      if (pastLog != null && pastLog.meals.isNotEmpty) {
        int dayIndex = pastDate.weekday == 7 ? 0 : pastDate.weekday;
        calculatedStreak[dayIndex] = true;
      }
    }
    weeklyStreak = calculatedStreak;
  }
}
