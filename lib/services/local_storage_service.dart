import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_goal_model.dart';

class LocalStorageService {
  static const String _goalsKey = 'user_goals';

  Future<void> saveUserGoals(UserGoalModel goals) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(goals.toJson());
    await prefs.setString(_goalsKey, jsonString);
  }

  Future<UserGoalModel?> getUserGoals() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_goalsKey);

    if (jsonString != null) {
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      return UserGoalModel.fromJson(jsonMap);
    }
    return null;
  }
}
