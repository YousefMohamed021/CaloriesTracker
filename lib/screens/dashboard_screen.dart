import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../providers/tracker_provider.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'user_goal_screen.dart';
import 'package:weekly_streak/weekly_streak.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId = AuthService().currentUser?.uid;

      if (userId != null) {
        final tracker = Provider.of<TrackerProvider>(context, listen: false);
        await tracker.loadData(userId);

        if (tracker.currentGoals == null && mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const UserGoalScreen()),
          );
        }
      }
    });
  }

  // Helper widget for macros
  Widget _buildMacroRow(
    String title,
    double consumed,
    double target,
    Color progressColor,
  ) {
    double percent = target > 0 ? (consumed / target).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '${consumed.toInt()} / ${target.toInt()} g',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearPercentIndicator(
            lineHeight: 12.0,
            percent: percent,
            backgroundColor: Colors.grey[200]!,
            progressColor: progressColor,
            barRadius: const Radius.circular(10),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          // Sign Out Button
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black87),
            onPressed: () async {
              await AuthService().signOut();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Consumer<TrackerProvider>(
        builder: (context, tracker, child) {
          if (tracker.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
            );
          }

          // Fetch the data from the provider
          final goals = tracker.currentGoals;
          final log = tracker.todayLog;

          double targetCals = goals?.targetCalories ?? 2100;
          double consumedCals = log?.totalCalories ?? 0;
          double calPercent = targetCals > 0
              ? (consumedCals / targetCals).clamp(0.0, 1.0)
              : 0.0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Text(
                  'Calories Today',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),

                // Circular Calorie Indicator
                CircularPercentIndicator(
                  radius: 120.0,
                  lineWidth: 18.0,
                  percent: calPercent,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.grey[200]!,
                  progressColor: const Color(0xFF4CAF50),
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${consumedCals.toInt()}',
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '/ ${targetCals.toInt()} kcal',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Macro Bars
                _buildMacroRow(
                  'Protein',
                  log?.totalProtein ?? 0,
                  goals?.targetProtein ?? 120,
                  const Color(0xFF4285F4),
                ),
                _buildMacroRow(
                  'Carbs',
                  log?.totalCarbs ?? 0,
                  goals?.targetCarbs ?? 250,
                  const Color(0xFFFF8C00),
                ),
                _buildMacroRow(
                  'Fats',
                  log?.totalFat ?? 0,
                  goals?.targetFats ?? 65,
                  const Color(0xFFFFB300),
                ),
                // Custom Widget
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Weekly Streak',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      WeeklyStreakBubbles(
                        streak: tracker.weeklyStreak,
                        activeColor: const Color(0xFF4CAF50),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
