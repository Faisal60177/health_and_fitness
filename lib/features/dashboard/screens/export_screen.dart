import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/step_repository.dart';
import '../../../data/repositories/food_repository.dart';
import '../../../data/repositories/weight_repository.dart';
import '../../../data/repositories/sleep_repository.dart';

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  bool _isExporting = false;
  String? _lastExportPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Export data',
            style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Export your health data',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Choose a format to export the last 30 days of data.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),

            // PDF export card
            _ExportCard(
              icon: Icons.picture_as_pdf_rounded,
              title: 'PDF Report',
              desc: 'A formatted health summary with all stats and highlights',
              color: const Color(0xFFEF5350),
              buttonLabel: 'Export PDF',
              isLoading: _isExporting,
              onTap: _exportPdf,
            ),
            const SizedBox(height: 16),

            // CSV export card
            _ExportCard(
              icon: Icons.table_chart_rounded,
              title: 'CSV Spreadsheet',
              desc: 'Raw data for each tracker, compatible with Excel or Sheets',
              color: AppColors.success,
              buttonLabel: 'Export CSV',
              isLoading: _isExporting,
              onTap: _exportCsv,
            ),

            if (_lastExportPath != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.success.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.success, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Exported successfully',
                        style: const TextStyle(color: AppColors.success),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _exportPdf() async {
    setState(() => _isExporting = true);
    try {
      // Load all data
      final steps   = await StepRepository().getRecentDays(30);
      final weights = await WeightRepository().getHistory();
      final sleeps  = await SleepRepository().getRecentNights(30);
      final foods   = await FoodRepository().getLogsForDate(
          DateTime.now().subtract(const Duration(days: 30)));

      // Build PDF using dart_pdf
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (context) => [
            // Title
            pw.Text('Health & Fitness Report',
                style: pw.TextStyle(
                    fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.Text(
              'Generated ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey),
            ),
            pw.SizedBox(height: 20),

            // Steps summary
            pw.Text('Step Summary (Last 30 days)',
                style: pw.TextStyle(
                    fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            if (steps.isNotEmpty) ...[
              pw.Text('Total steps: ${steps.fold(0, (s, e) => s + e.stepCount)}'),
              pw.Text('Daily average: ${(steps.fold(0, (s, e) => s + e.stepCount) / steps.length).toStringAsFixed(0)} steps'),
              pw.Text('Goal achieved ${steps.where((e) => e.goalReached).length} / ${steps.length} days'),
            ] else
              pw.Text('No step data recorded'),
            pw.SizedBox(height: 16),

            // Weight summary
            pw.Text('Weight Log',
                style: pw.TextStyle(
                    fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            if (weights.isNotEmpty)
              pw.Table.fromTextArray(
                headers: ['Date', 'Weight (kg)'],
                data: weights.take(10).map((w) => [
                  '${w.date.day}/${w.date.month}/${w.date.year}',
                  w.weightKg.toStringAsFixed(1),
                ]).toList(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              )
            else
              pw.Text('No weight data recorded'),
            pw.SizedBox(height: 16),

            // Sleep summary
            pw.Text('Sleep Summary',
                style: pw.TextStyle(
                    fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            if (sleeps.isNotEmpty) ...[
              pw.Text('Average sleep: ${(sleeps.fold(0.0, (s, l) => s + l.durationHours) / sleeps.length).toStringAsFixed(1)} hours'),
              pw.Text('Average quality: ${(sleeps.fold(0.0, (s, l) => s + l.qualityRating) / sleeps.length).toStringAsFixed(1)} / 5'),
            ] else
              pw.Text('No sleep data recorded'),
          ],
        ),
      );

      // Save and share
      final dir  = await getTemporaryDirectory();
      final file = File('${dir.path}/health_report.pdf');
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'My Health Report',
      );

      setState(() {
        _isExporting = false;
        _lastExportPath = file.path;
      });
    } catch (e) {
      setState(() => _isExporting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  Future<void> _exportCsv() async {
    setState(() => _isExporting = true);
    try {
      final steps   = await StepRepository().getRecentDays(30);
      final weights = await WeightRepository().getHistory();
      final sleeps  = await SleepRepository().getRecentNights(30);

      // Build CSV data
      final stepRows = [
        ['Date', 'Steps', 'Goal', 'Reached'],
        ...steps.map((e) => [
          '${e.date.year}-${e.date.month}-${e.date.day}',
          e.stepCount,
          e.dailyGoal,
          e.goalReached ? 'Yes' : 'No',
        ]),
      ];

      final weightRows = [
        ['Date', 'Weight (kg)', 'Notes'],
        ...weights.map((w) => [
          '${w.date.year}-${w.date.month}-${w.date.day}',
          w.weightKg,
          w.notes,
        ]),
      ];

      final sleepRows = [
        ['Date', 'Duration (h)', 'Quality', 'Bed time', 'Wake time'],
        ...sleeps.map((s) => [
          '${s.date.year}-${s.date.month}-${s.date.day}',
          s.durationHours.toStringAsFixed(1),
          s.qualityLabel,
          '${s.bedTime.hour}:${s.bedTime.minute.toString().padLeft(2, '0')}',
          '${s.wakeTime.hour}:${s.wakeTime.minute.toString().padLeft(2, '0')}',
        ]),
      ];

      // Combine all into one CSV with section headers
      final allRows = [
        ['=== STEPS ==='],
        ...stepRows,
        [''],
        ['=== WEIGHT ==='],
        ...weightRows,
        [''],
        ['=== SLEEP ==='],
        ...sleepRows,
      ];

      final csvString =  Csv().encoder.convert(
        allRows.map((row) => row.map((e) => e.toString()).toList()).toList(),
      );
      final dir  = await getTemporaryDirectory();
      final file = File('${dir.path}/health_data.csv');
      await file.writeAsString(csvString);

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'My Health Data',
      );

      setState(() {
        _isExporting = false;
        _lastExportPath = file.path;
      });
    } catch (e) {
      setState(() => _isExporting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }
}

class _ExportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final Color color;
  final String buttonLabel;
  final bool isLoading;
  final VoidCallback onTap;

  const _ExportCard({
    required this.icon, required this.title, required this.desc,
    required this.color, required this.buttonLabel,
    required this.isLoading, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceMuted),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(desc, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: isLoading ? null : onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: isLoading
                ? const SizedBox(width: 14, height: 14,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white))
                : Text(buttonLabel,
                style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}



