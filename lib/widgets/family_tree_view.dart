import 'package:flutter/material.dart';

import '../models/family_member.dart';

class FamilyTreeView extends StatelessWidget {
  const FamilyTreeView({
    super.key,
    required this.members,
    required this.selectedMember,
    required this.onSelected,
  });

  final List<FamilyMember> members;
  final FamilyMember selectedMember;
  final ValueChanged<FamilyMember> onSelected;

  @override
  Widget build(BuildContext context) {
    final root = members.firstWhere((member) => member.parentId == null);
    return _FamilyNode(
      member: root,
      members: members,
      selectedMember: selectedMember,
      onSelected: onSelected,
    );
  }
}

class _FamilyNode extends StatelessWidget {
  const _FamilyNode({
    required this.member,
    required this.members,
    required this.selectedMember,
    required this.onSelected,
  });

  final FamilyMember member;
  final List<FamilyMember> members;
  final FamilyMember selectedMember;
  final ValueChanged<FamilyMember> onSelected;

  @override
  Widget build(BuildContext context) {
    final children = members
        .where((item) => member.childIds.contains(item.id))
        .toList();
    final isSelected = member.id == selectedMember.id;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => onSelected(member),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primaryContainer
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: colorScheme.primary,
                  child: Text(
                    member.initials,
                    style: TextStyle(color: colorScheme.onPrimary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${member.role} • Gen ${member.generation}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (children.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 8),
            child: Column(
              children: children
                  .map(
                    (child) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _FamilyNode(
                        member: child,
                        members: members,
                        selectedMember: selectedMember,
                        onSelected: onSelected,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}
