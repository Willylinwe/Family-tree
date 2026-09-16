import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/family_member.dart';

class HealthReportScreen extends StatelessWidget {
  const HealthReportScreen({super.key, required this.members});

  final List<FamilyMember> members;

  String _buildCsv(List<FamilyMember> list) {
    // anonymized: no names, only id, generation, relation, cause category, visible flag
    final buffer = StringBuffer();
    buffer.writeln('id,generation,relationship,deathYear,causeCategory,causeNote,shared');
    for (final m in list.where((m) => m.status == LifeStatus.deceased)) {
      final causeCat = m.causeCategory?.value ?? '';
      final causeNote = m.causeOfDeath?.replaceAll(',', ';') ?? '';
      buffer.writeln('${m.id},${m.generation},"${m.relationshipRole}",${m.deathYear ?? ''},$causeCat,"$causeNote",${m.causeVisible}');
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final csv = _buildCsv(members);
    return Scaffold(
      appBar: AppBar(title: const Text('Anonymized health report')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Export anonymized health report for deceased relatives',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(csv),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    // copy to clipboard
                    try {
                      await Clipboard.setData(ClipboardData(text: csv));
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('CSV copied to clipboard')));
                    } catch (_) {
                      // platform may not support clipboard in tests
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cannot copy to clipboard')));
                    }
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy CSV'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    // save to file not implemented — show CSV dialog
                    await showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('CSV preview'),
                        content: SingleChildScrollView(child: SelectableText(csv)),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'))
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.save_alt),
                  label: const Text('Preview CSV'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
