import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../models/log_meal_model.dart';
import '../models/meal_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<MealModel> _allMeals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllHistory();
  }

  // Get all past logs
  Future<void> _fetchAllHistory() async {
    setState(() => _isLoading = true);

    try {
      final userId = AuthService().currentUser!.uid;

      // Get every daily log document for this user
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('daily_logs')
          .get();

      List<MealModel> fetchedMeals = [];
      for (var doc in snapshot.docs) {
        final dailyLog = DailyLogModel.fromJson(doc.data());
        fetchedMeals.addAll(dailyLog.meals);
      }
      fetchedMeals.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      setState(() {
        _allMeals = fetchedMeals;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching history: $e");
      setState(() => _isLoading = false);
    }
  }

  // Format date
  String _formatDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    return "$day-$month-${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(
            color: Color(0xFF4A5548),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1B802E)),
            )
          : _allMeals.isEmpty
          ? const Center(
              child: Text(
                'No meals logged yet.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _allMeals.length,
              itemBuilder: (context, index) {
                final meal = _allMeals[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left side: Food Name and Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meal.foodItem.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${meal.gramsConsumed.toInt()}g • ${_formatDate(meal.timestamp)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Right side: Calories
                      Text(
                        '${meal.calculatedCalories.toInt()} kcal',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B802E),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
