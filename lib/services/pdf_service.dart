import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import './firestore_service.dart';

class PDFService {
  final FirestoreService _firestoreService = FirestoreService();

  Future<pw.Document> generateDailyLogPDF(String userId, String dateId) async {
    final log = await _firestoreService.getDailyLog(userId, dateId);

    if (log == null) {
      throw Exception('No log found for the specified date.');
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Daily Log - ${log.dateId}',
              style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Calories : ${log.totalCalories}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24),
            ),
            pw.Text(
              'Protein : ${log.totalProtein}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24),
            ),
            pw.Text(
              'Carbs : ${log.totalCarbs}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24),
            ),
            pw.Text(
              'Fats : ${log.totalFat}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24),
            ),
          ],
        ),
      ),
    );

    return pdf;
  }
}
