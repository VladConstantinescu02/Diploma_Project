import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../models/meal_model.dart';

final downloadMealToDeviceProvider = Provider<DownloadMealToDevice>((ref) {
  return DownloadMealToDevice();
});

class DownloadMealToDevice {
  Future<void> generatePdf(Meal meal) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(children: [
          pw.Column(children: [
            pw.Padding(
            child: pw.Container(
              child:
              pw.Text(
                "🍽️ Meal card:",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ), padding: const pw.EdgeInsets.all(8),
            ),
            pw.Text(meal.title ?? 'Meal has no title',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24)),
          ]),
          pw.SizedBox(height: 16),
          pw.Column(children: [
            pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: pw.Container(
                width: 300,
                padding: const pw.EdgeInsets.only(bottom: 12),
                child: pw.Text(
                  meal.instructions ?? 'Meal has no instructions',
                  style: const pw.TextStyle(fontSize: 16),
                  textAlign: pw.TextAlign.left,
                ),
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Divider(height: 16.0 * 2),
            pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: pw.Container(
                width: 300,
                child: pw.UrlLink(
                  destination: meal.sourceUrl ?? '',
                  child: pw.Text(
                    meal.sourceUrl ?? 'Meal has no URL',
                    style: const pw.TextStyle(
                      color: PdfColors.blue,
                      decoration: pw.TextDecoration.underline,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ]),
      ),
    );

    final directory =
        await getApplicationDocumentsDirectory(); // app-safe location
    final filePath = '${directory.path}/${meal.title.replaceAll(' ', '_')}.pdf';
    final file = File(filePath);

    await file.writeAsBytes(await pdf.save());

    await OpenFile.open(filePath);

    if (kDebugMode) {
      print('PDF saved at $filePath');
    }
  }
}
