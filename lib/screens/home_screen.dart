import 'package:flutter/material.dart';

import '../models/family_member.dart';
import '../screens/add_member_screen.dart';
import '../screens/deceased_members_biography_screen.dart';
import '../screens/family_lineage_map_screen.dart';
import '../screens/member_details_screen.dart';
import '../screens/health_report_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/member_widgets.dart';
import '../widgets/stats_card.dart';
import '../controllers/family_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FamilyController _controller = FamilyController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
    _loadSaved();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final totalMembers = _controller.totalMembers;
    final maxGen = _controller.maxGeneration;
    final totalGenerations = _controller.members.isEmpty ? 0 : maxGen + 1;
    final rootMembers = _controller.rootMembers;
    final colorScheme = Theme.of(context).colorScheme;
    final isInitialLoading = _controller.isLoading && _controller.members.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Family Tree'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _openFamilyLineageMap,
            icon: const Icon(Icons.account_tree_outlined),
            tooltip: 'View generations',
          ),
          IconButton(
            onPressed: _openAddMemberScreen,
            icon: const Icon(Icons.person_add_alt_1_rounded),
            tooltip: 'Add family member',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddMemberScreen,
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Add member'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor,
                          const Color(0xFFE9B949),
                          AppTheme.accentColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.18),
                          blurRadius: 14,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Start your family story',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create a family tree from scratch, preserve your roots, and begin from the elders when you want to protect your ancestry for generations.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.92),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _openAddMemberScreen,
                              icon: const Icon(Icons.family_restroom),
                              label: const Text('Create my family tree'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppTheme.accentColor,
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: _openAddGenerationScreen,
                              icon: const Icon(Icons.hub_outlined),
                              label: const Text('Start from ancestors'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white54),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: _openDeceasedBiographies,
                              icon: const Icon(Icons.auto_stories_outlined),
                              label: const Text('Biography of the departed'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white54),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: _openFamilyLineageMap,
                              icon: const Icon(Icons.account_tree_outlined),
                              label: const Text('Family lineage map'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white54),
                              ),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: _openHealthReport,
                              icon: const Icon(Icons.health_and_safety_outlined),
                              label: const Text('Anonymized health report'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white54),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: StatsCard(
                          title: 'Members',
                          value: '$totalMembers',
                          icon: Icons.groups_2,
                          color: colorScheme.primary,
                          onTap: _openMembersDirectory,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatsCard(
                          title: 'Generations',
                          value: '$totalGenerations',
                          icon: Icons.timeline,
                          color: AppTheme.accentColor,
                          onTap: _openGenerationsSummary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_controller.members.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.group_add_outlined,
                            size: 48,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No family member yet',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the button below to start building your family tree from scratch.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  else ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Generations view',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Your family members are organized in generations on a separate screen, away from the dashboard.',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          FilledButton.icon(
                            onPressed: _openGenerationsSummary,
                            icon: const Icon(Icons.account_tree_outlined),
                            label: const Text('Open'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isInitialLoading)
              IgnorePointer(
                child: const SizedBox.expand(
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openAddMemberScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMemberScreen(
          allMembers: _controller.members,
          onSave: (member) => _controller.addMember(member),
        ),
      ),
    );
  }

  void _openAddGenerationScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMemberScreen(
          allMembers: _controller.members,
          onSave: (member) => _controller.addMember(member),
          forceFounder: true,
        ),
      ),
    );
  }

  Future<void> _loadSaved() async {
    await _controller.loadMembers();
  }

  void _openMembersDirectory() {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => MembersDirectoryScreen(
          members: _controller.members,
        ),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  void _openMemberDetails(FamilyMember member) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemberDetailsScreen(
          member: member,
          allMembers: _controller.members,
          onDelete: _deleteMember,
        ),
      ),
    );
  }

  Future<void> _deleteMember(String memberId) async {
    await _controller.removeMember(memberId);
  }

  void _openDeceasedBiographies() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeceasedMembersBiographyScreen(
          members: _controller.members,
        ),
      ),
    );
  }

  void _openGenerationsSummary() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenerationsSummaryScreen(
          members: _controller.members,
        ),
      ),
    );
  }

  void _openFamilyLineageMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FamilyLineageMapScreen(
          members: _controller.members,
        ),
      ),
    );
  }

  void _openHealthReport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HealthReportScreen(members: _controller.members),
      ),
    );
  }
}

class GenerationsSummaryScreen extends StatelessWidget {
  const GenerationsSummaryScreen({
    super.key,
    required this.members,
  });

  final List<FamilyMember> members;

  @override
  Widget build(BuildContext context) {
    final totalGenerations = members.isEmpty ? 0 : (members.map((member) => member.generation).reduce((a, b) => a > b ? a : b) + 1);
    final totalPopulation = members.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generations'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Generations',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryMetricCard(
                          label: 'Generations',
                          value: '$totalGenerations',
                          subtitle: 'So far',
                          color: AppTheme.primaryColor,
                          icon: Icons.timeline,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _SummaryMetricCard(
                          label: 'Total population',
                          value: '$totalPopulation',
                          subtitle: 'Family members',
                          color: AppTheme.accentColor,
                          icon: Icons.groups_2_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryMetricCard extends StatelessWidget {
  const _SummaryMetricCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class MembersDirectoryScreen extends StatelessWidget {
  const MembersDirectoryScreen({
    super.key,
    required this.members,
  });

  final List<FamilyMember> members;

  @override
  Widget build(BuildContext context) {
    final groupedByGeneration = <int, List<FamilyMember>>{};
    for (final member in members) {
      groupedByGeneration.putIfAbsent(member.generation, () => <FamilyMember>[]).add(member);
    }

    final generations = groupedByGeneration.keys.toList()..sort();
    final totalGenerations = members.isEmpty ? 0 : (members.map((member) => member.generation).reduce((a, b) => a > b ? a : b) + 1);
    final orderedMembers = <MapEntry<int, List<FamilyMember>>>[];
    for (final generation in generations) {
      final generationMembers = [...groupedByGeneration[generation]!]
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      orderedMembers.add(MapEntry(generation, generationMembers));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Members',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: members.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'No family members yet.\nAdd a member to begin your directory.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: orderedMembers.length,
                    itemBuilder: (context, generationIndex) {
                      final generation = orderedMembers[generationIndex].key;
                      final generationMembers = orderedMembers[generationIndex].value;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                showDialog<void>(
                                  context: context,
                                  builder: (dialogContext) {
                                    final generationCount = generationMembers.length;
                                    return AlertDialog(
                                      title: Text('Generation $generation'),
                                      content: Text(
                                        'This generation has $generationCount member${generationCount == 1 ? '' : 's'} in the family.\n\nTotal generations in this family: $totalGenerations.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(dialogContext),
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Generation $generation',
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.info_outline,
                                      size: 18,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...generationMembers.map(
                              (member) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: InkWell(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MemberDetailsScreen(
                                        member: member,
                                        allMembers: members,
                                      ),
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Theme.of(context).colorScheme.outlineVariant,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        MemberAvatarWidget(member: member, size: 42),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                member.name,
                                                style: Theme.of(context).textTheme.titleMedium,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                member.role,
                                                style: Theme.of(context).textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Gen $generation',
                                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
