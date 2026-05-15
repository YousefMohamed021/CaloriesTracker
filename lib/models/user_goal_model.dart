class UserGoalModel {
  final String userId;
  final double targetCalories;
  final double targetProtein;
  final double targetCarbs;
  final double targetFats;
  final double weight;
  final double height;
  final int age;

  UserGoalModel({
    required this.userId,
    required this.targetCalories,
    required this.targetProtein,
    required this.targetCarbs,
    required this.targetFats,
    required this.weight,
    required this.height,
    required this.age,
  });

  factory UserGoalModel.fromJson(Map<String, dynamic> json) {
    return UserGoalModel(
      userId: json['userId'],
      targetCalories: json['targetCalories'].toDouble(),
      targetProtein: json['targetProtein'].toDouble(),
      targetCarbs: json['targetCarbs'].toDouble(),
      targetFats: json['targetFats'].toDouble(),
      weight: json['weight'].toDouble(),
      height: json['height'].toDouble(),
      age: json['age'].toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'targetCalories': targetCalories,
      'targetProtein': targetProtein,
      'targetCarbs': targetCarbs,
      'targetFats': targetFats,
      'weight': weight,
      'height': height,
      'age': age,
    };
  }
}
