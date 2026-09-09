import 'package:flutter/material.dart';

import '../models/family_member.dart';

class DeceasedMembersBiographyScreen extends StatelessWidget {
  const DeceasedMembersBiographyScreen({
    super.key,
    required this.members,
  });

  final List<FamilyMember> members;

  @override
  Widget build(BuildContext context) {
    final deceasedMembers = members
        .where((member) => member.status == LifeStatus.deceased)
        .toList()
      ..sort((a, b) {
        final aYear = int.tryParse(a.deathYear ?? '9999') ?? 9999;
        final bYear = int.tryParse(b.deathYear ?? '9999') ?? 9999;
        return aYear.compareTo(bYear);
      });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Biography of the departed'),
        elevation: 0,
      ),
      body: deceasedMembers.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No deceased family members yet.\nAdd a loved one to begin the memorial story.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: deceasedMembers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final member = deceasedMembers[index];
                return Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          member.role,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey.shade700),
                        ),
                        const SizedBox(height: 12),
                        if (member.birthYear != null || member.deathYear != null)
                          Text(
                            _yearsLabel(member),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        if (member.causeOfDeath != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Cause of death: ${member.causeOfDeath!}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                        if (member.location != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Location: ${member.location!}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                        if (member.occupation != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Occupation: ${member.occupation!}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                        const SizedBox(height: 12),
                        Text(
                          _biographyText(member),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _yearsLabel(FamilyMember member) {
    final birth = member.birthYear;
    final death = member.deathYear;

    if (birth != null && death != null) {
      return '$birth - $death';
    }
    if (birth != null) {
      return 'Born $birth';
    }
    if (death != null) {
      return 'Died $death';
    }
    return 'Life story';
  }

  String _biographyText(FamilyMember member) {
    final description = StringBuffer();
    description.write('${member.name} was a ${member.role.toLowerCase()}.');

    if (member.location != null) {
      description.write(' They lived in ${member.location}.');
    }

    if (member.occupation != null) {
      description.write(' Their work was ${member.occupation!.toLowerCase()}.');
    }

    if (member.note != null && member.note!.trim().isNotEmpty) {
      description.write(' ${member.note!.trim()}');
    } else {
      description.write(' Their memory remains part of the family story.');
    }

    return description.toString();
  }
}
