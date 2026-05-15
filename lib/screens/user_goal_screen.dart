import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tracker_provider.dart';
import '../services/auth_service.dart';
import '../models/user_goal_model.dart';
import 'main_navigation.dart';

class UserGoalScreen extends StatefulWidget {
  const UserGoalScreen({super.key});

  @override
  State<UserGoalScreen> createState() => _UserGoalScreenState();
}

class _UserGoalScreenState extends State<UserGoalScreen> {
  // Input Controllers
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  // Dropdown Default States
  String _selectedGender = 'Male';
  String _selectedActivity = 'Moderately Active';
  String _selectedGoal = 'Maintain Weight';

  void _calculateAndSave() async {
    if (_ageController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _heightController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields!')));
      return;
    }

    try {
      double weight = double.parse(_weightController.text);
      double height = double.parse(_heightController.text);
      int age = int.parse(_ageController.text);
      double bmr;

      // {Harris-Benedict} BMR Equations for Male & Female
      if (_selectedGender == 'Male') {
        bmr = (13.397 * weight) + (4.799 * height) - (5.677 * age) + 88.362;
      } else {
        bmr = (9.247 * weight) + (3.098 * height) - (4.330 * age) + 447.593;
      }

      // Activity Multipliers
      double multiplier = 1.55; // Default: Moderately Active
      if (_selectedActivity == 'Sedentary') multiplier = 1.2;
      if (_selectedActivity == 'Lightly Active') multiplier = 1.375;
      if (_selectedActivity == 'Very Active') multiplier = 1.725;
      if (_selectedActivity == 'Extra Active') multiplier = 1.9;

      double targetCalories = bmr * multiplier;
      if (_selectedGoal == 'Lose Weight') targetCalories -= 500;
      if (_selectedGoal == 'Gain Weight') targetCalories += 300;

      // Macros Split (30% Protein, 40% Carbs, 30% Fats)
      double targetProtein = (targetCalories * 0.30) / 4;
      double targetCarbs = (targetCalories * 0.40) / 4;
      double targetFats = (targetCalories * 0.30) / 9;

      // Get current user
      final userId = AuthService().currentUser?.uid ?? 'guest';

      final newGoal = UserGoalModel(
        userId: userId,
        targetCalories: targetCalories,
        targetProtein: targetProtein,
        targetCarbs: targetCarbs,
        targetFats: targetFats,
        weight: weight,
        height: height,
        age: age,
      );

      await Provider.of<TrackerProvider>(
        context,
        listen: false,
      ).updateGoals(newGoal);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigation()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numbers only.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Determine Your Goal',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Gender & Age
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Gender',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _selectedGender,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                              items: ['Male', 'Female']
                                  .map(
                                    (val) => DropdownMenuItem(
                                      value: val,
                                      child: Text(val),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedGender = val!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Age',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '25',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            suffixText: 'years',
                            filled: true,
                            fillColor: const Color(0xFFF5F5F5),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Weight & Height
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Weight',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '75',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            suffixText: 'kg',
                            filled: true,
                            fillColor: const Color(0xFFF5F5F5),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Height',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _heightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '175',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            suffixText: 'cm',
                            filled: true,
                            fillColor: const Color(0xFFF5F5F5),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Activity Level
              const Text(
                'Activity Level',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedActivity,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    items:
                        [
                              'Sedentary',
                              'Lightly Active',
                              'Moderately Active',
                              'Very Active',
                              'Extra Active',
                            ]
                            .map(
                              (val) => DropdownMenuItem(
                                value: val,
                                child: Text(val),
                              ),
                            )
                            .toList(),
                    onChanged: (val) =>
                        setState(() => _selectedActivity = val!),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Goal
              const Text(
                'Your Goal',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedGoal,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    items: ['Lose Weight', 'Maintain Weight', 'Gain Weight']
                        .map(
                          (val) =>
                              DropdownMenuItem(value: val, child: Text(val)),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => _selectedGoal = val!),
                  ),
                ),
              ),

              const Spacer(),
              // Calculate Button
              ElevatedButton(
                onPressed: _calculateAndSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Calculate',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
