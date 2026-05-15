import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/log_meal_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveDailyLog(DailyLogModel log) async {
    try {
      await _db
          .collection('users')
          .doc(log.userId)
          .collection('daily_logs')
          .doc(log.dateId)
          .set(log.toJson(), SetOptions(merge: true));
    } catch (e) {
      print('Error saving to Firestore: $e');
    }
  }

  Future<DailyLogModel?> getDailyLog(String userId, String dateId) async {
    try {
      DocumentSnapshot doc = await _db
          .collection('users')
          .doc(userId)
          .collection('daily_logs')
          .doc(dateId)
          .get();

      if (doc.exists) {
        return DailyLogModel.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error fetching from Firestore: $e');
    }
    return null;
  }
}
