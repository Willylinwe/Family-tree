import 'package:flutter/material.dart';

import '../models/family_member.dart';
import '../theme/app_theme.dart';
import '../widgets/member_widgets.dart';

class MemberDetailsScreen extends StatelessWidget {
  const MemberDetailsScreen({
    super.key,
    required this.member,
    required this.allMembers,
  });

  final FamilyMember member;
  final List<FamilyMember> allMembers;

  @override
  Widget build(BuildContext context) {
    final parent = _findMemberById(member.parentId);
    final siblings = parent == null
        ? <FamilyMember>[]
        : allMembers
            .where((m) => m.parentId == parent.id && m.id != member.id)
            .toList();
    final children = allMembers
        .where((m) => member.childIds.contains(m.id))
        .toList();
    final spouse = _findMemberById(member.spouseId);

    return Scaffold(
      appBar: AppBar(title: const Text('Family profile'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  MemberAvatarWidget(member: member, size: 100),
                  const SizedBox(height: 16),
                  Text(
                    member.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      member.role,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'About this person'),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(context, 'Role', member.role),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      context,
                      'Relationship',
                      member.relationshipRole,
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      context,
                      'Generation',
                      'Generation ${member.generation}',
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(context, 'Status', member.statusLabel),
                    if (member.occupation != null) ...[
                      const SizedBox(height: 10),
                      _buildInfoRow(context, 'Occupation', member.occupation!),
                    ],
                    if (member.birthYear != null) ...[
                      const SizedBox(height: 10),
                      _buildInfoRow(context, 'Birth year', member.birthYear!),
                    ],
                    if (member.deathYear != null) ...[
                      const SizedBox(height: 10),
                      _buildInfoRow(context, 'Death year', member.deathYear!),
                    ],
                    if (!member.causeVisible)
                      const SizedBox.shrink()
                    else if (member.causeOfDeath != null || member.causeCategory != null) ...[
                      const SizedBox(height: 10),
                      _buildInfoRow(
                        context,
                        'Cause of death',
                        member.causeOfDeath ?? member.causeCategory?.label ?? 'Unknown',
                      ),
                    ],
                    if (member.location != null) ...[
                      const SizedBox(height: 10),
                      _buildInfoRow(context, 'Location', member.location!),
                    ],
                    if (member.spouseId != null) ...[
                      const SizedBox(height: 10),
                      _buildInfoRow(
                        context,
                        'Spouse',
                        spouse?.name ?? 'Linked partner',
                      ),
                    ],
                    if (member.note != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        'Note',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        member.note!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (parent != null || siblings.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildSectionTitle(context, 'Immediate family'),
              const SizedBox(height: 8),
              if (parent != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: MemberCard(
                    member: parent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MemberDetailsScreen(
                            member: parent,
                            allMembers: allMembers,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (siblings.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  'Siblings',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...siblings.map(
                  (sibling) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: MemberCard(
                      member: sibling,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MemberDetailsScreen(
                              member: sibling,
                              allMembers: allMembers,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ],
            if (children.isNotEmpty || spouse != null) ...[
              const SizedBox(height: 24),
              _buildSectionTitle(context, 'Partners & children'),
              const SizedBox(height: 8),
              if (spouse != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: MemberCard(
                    member: spouse,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MemberDetailsScreen(
                            member: spouse,
                            allMembers: allMembers,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (children.isNotEmpty)
                ...children.map(
                  (child) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: MemberCard(
                      member: child,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MemberDetailsScreen(
                              member: child,
                              allMembers: allMembers,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  FamilyMember? _findMemberById(String? memberId) {
    if (memberId == null) return null;
    for (final member in allMembers) {
      if (member.id == memberId) return member;
    }
    return null;
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(width: 8),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
