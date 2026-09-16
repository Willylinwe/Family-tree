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
    final rootMembers = _controller.rootMembers;
    final colorScheme = Theme.of(context).colorScheme;
    final isInitialLoading = _controller.isLoading && _controller.members.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Family Tree'),
        elevation: 0,
        actions: [
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
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatsCard(
                          title: 'Generations',
                          value: '$maxGen',
                          icon: Icons.timeline,
                          color: AppTheme.accentColor,
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
                    Text(
                      'Family members',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    if (rootMembers.length > 1)
                      Text(
                        'Family branches',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ...rootMembers.map(
                      (member) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: MemberCard(
                          member: member,
                          onTap: () => _openMemberDetails(member),
                        ),
                      ),
                    ),
                    if (rootMembers.isNotEmpty) ...[
                      const Divider(height: 24),
                      Text(
                        'Other family members',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                    ..._controller.members
                        .where((member) => member.parentId != null)
                        .map(
                          (member) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: MemberCard(
                              member: member,
                              onTap: () => _openMemberDetails(member),
                            ),
                          ),
                        ),
                  ],
                ],
              ),
            ),
            if (isInitialLoading)
              const Positioned.fill(
                child: IgnorePointer(
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

  void _openMemberDetails(FamilyMember member) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemberDetailsScreen(
          member: member,
          allMembers: _controller.members,
        ),
      ),
    );
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
