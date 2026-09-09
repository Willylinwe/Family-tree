import 'package:flutter/material.dart';

import '../models/family_member.dart';

class FamilyLineageMapScreen extends StatelessWidget {
  const FamilyLineageMapScreen({
    super.key,
    required this.members,
  });

  final List<FamilyMember> members;

  @override
  Widget build(BuildContext context) {
    final groupedByGeneration = <int, List<FamilyMember>>{};
    for (final member in members) {
      groupedByGeneration.putIfAbsent(member.generation, () => []).add(member);
    }

    final generations = groupedByGeneration.keys.toList()..sort();
    final maxGeneration = generations.isEmpty ? 0 : generations.last;
    final generationColors = <Color>[
      const Color(0xFFEEF6FF),
      const Color(0xFFEAFBF2),
      const Color(0xFFFFF3E6),
      const Color(0xFFF3ECFF),
      const Color(0xFFEAF9FF),
      const Color(0xFFFCEAF6),
    ];

    final cardWidth = 180.0;
    final cardHeight = 150.0;
    final gap = 18.0;
    final generationGap = 26.0;
    final xStart = 32.0;
    final yStart = 18.0;
    final maxMembersInAnyGeneration = generations.isEmpty
        ? 1
        : generations
            .map((generation) => groupedByGeneration[generation]!.length)
            .reduce((a, b) => a > b ? a : b);

    final chartWidth =
        (maxMembersInAnyGeneration * (cardWidth + gap)) + (xStart * 2) + 60;
    final chartHeight =
        ((maxGeneration + 1) * (cardHeight + generationGap + 50)) + 60;

    final nodePositions = <String, Offset>{};
    final parentConnections = <_ParentConnection>[];

    for (var generationIndex = 0; generationIndex <= maxGeneration; generationIndex++) {
      final generationMembers = groupedByGeneration[generationIndex] ?? const <FamilyMember>[];
      for (var memberIndex = 0; memberIndex < generationMembers.length; memberIndex++) {
        final member = generationMembers[memberIndex];
        final x = xStart + (memberIndex * (cardWidth + gap));
        final y = yStart + (generationIndex * (cardHeight + generationGap + 42));
        nodePositions[member.id] = Offset(x + (cardWidth / 2), y + (cardHeight / 2));

        if (member.parentId != null) {
          final parent = members.firstWhere(
            (candidate) => candidate.id == member.parentId,
            orElse: () => member,
          );
          if (parent.id != member.id) {
            final parentGen = parent.generation;
            final parentMembers = groupedByGeneration[parentGen] ?? <FamilyMember>[];
            final parentIndex = parentMembers.indexWhere((candidate) => candidate.id == parent.id);
            if (parentIndex >= 0) {
              final parentX = xStart + (parentIndex * (cardWidth + gap));
              final parentY = yStart + (parentGen * (cardHeight + generationGap + 42));
              parentConnections.add(
                _ParentConnection(
                  from: Offset(parentX + (cardWidth / 2), parentY + cardHeight),
                  to: Offset(x + (cardWidth / 2), y),
                ),
              );
            }
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Family lineage map'),
        elevation: 0,
      ),
      body: members.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No family members yet.\nStart from a founder to build your lineage.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : InteractiveViewer(
              minScale: 0.7,
              maxScale: 1.8,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CustomPaint(
                  painter: _LineageConnectionPainter(
                    connections: parentConnections,
                  ),
                  child: SizedBox(
                    width: chartWidth,
                    height: chartHeight,
                    child: Column(
                      children: [
                        for (var generationIndex = 0; generationIndex <= maxGeneration; generationIndex++) ...[
                          Container(
                            width: chartWidth,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            decoration: BoxDecoration(
                              color: generationColors[generationIndex % generationColors.length],
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.black.withValues(alpha: 0.04),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Generation $generationIndex',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (final member in groupedByGeneration[generationIndex] ?? const <FamilyMember>[]) ...[
                                      Padding(
                                        padding: const EdgeInsets.only(right: 18),
                                        child: SizedBox(
                                          width: cardWidth,
                                          height: cardHeight,
                                          child: _LineageMemberCard(
                                            member: member,
                                            isAncestor: member.parentId == null,
                                            parentName: _resolveParentName(member, members),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  String _resolveParentName(FamilyMember member, List<FamilyMember> allMembers) {
    if (member.parentId == null) return 'Founder';
    final parent = allMembers.firstWhere(
      (candidate) => candidate.id == member.parentId,
      orElse: () => const FamilyMember(
        id: 'unknown',
        name: 'Unknown parent',
        role: 'Relative',
        generation: 0,
      ),
    );
    return parent.name;
  }
}

class _LineageMemberCard extends StatelessWidget {
  const _LineageMemberCard({
    required this.member,
    required this.parentName,
    this.isAncestor = false,
  });

  final FamilyMember member;
  final String parentName;
  final bool isAncestor;

  @override
  Widget build(BuildContext context) {
    final borderColor = isAncestor
        ? Colors.amber.shade700
        : member.isAlive
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
            : Colors.grey.shade500;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isAncestor
            ? Colors.amber.shade50
            : member.isAlive
                ? Colors.white
                : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: isAncestor ? 2.2 : 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: isAncestor
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade700,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Ancestor',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: member.isAlive
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade700,
                    child: Text(
                      member.initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      member.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                member.role,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 6),
              Text(
                'Generation ${member.generation}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 6),
              Text(
                'Parent: $parentName',
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (member.location != null) ...[
                const SizedBox(height: 6),
                Text(
                  member.location!,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ParentConnection {
  const _ParentConnection({required this.from, required this.to});

  final Offset from;
  final Offset to;
}

class _LineageConnectionPainter extends CustomPainter {
  const _LineageConnectionPainter({required this.connections});

  final List<_ParentConnection> connections;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.indigo.withValues(alpha: 0.42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    for (final connection in connections) {
      final path = Path();
      final start = connection.from;
      final end = connection.to;
      final middleY = (start.dy + end.dy) / 2;

      path.moveTo(start.dx, start.dy);
      path.lineTo(start.dx, middleY);
      path.lineTo(end.dx, middleY);
      path.lineTo(end.dx, end.dy);

      canvas.drawPath(path, paint);

      final dotPaint = Paint()..color = Colors.indigo.withValues(alpha: 0.62);
      canvas.drawCircle(start, 4, dotPaint);
      canvas.drawCircle(end, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LineageConnectionPainter oldDelegate) => true;
}
