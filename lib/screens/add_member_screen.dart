import 'package:flutter/material.dart';

import '../models/family_member.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({
    super.key,
    required this.allMembers,
    required this.onSave,
    this.forceFounder = false,
  });

  final List<FamilyMember> allMembers;
  final ValueChanged<FamilyMember> onSave;
  final bool forceFounder;

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _relationshipController = TextEditingController(text: 'Family member');
  final _occupationController = TextEditingController();
  final _birthYearController = TextEditingController();
  final _deathYearController = TextEditingController();
  final _causeOfDeathController = TextEditingController();
  CauseCategory? _selectedCauseCategory;
  bool _shareCause = true;
  final _locationController = TextEditingController();
  final _noteController = TextEditingController();

  bool _isFounder = true;
  bool _isAlive = true;
  String? _selectedParentId;
  String? _selectedSpouseId;

  @override
  void initState() {
    super.initState();
    if (widget.forceFounder) {
      _isFounder = true;
    } else if (widget.allMembers.isNotEmpty) {
      _isFounder = false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _relationshipController.dispose();
    _occupationController.dispose();
    _birthYearController.dispose();
    _deathYearController.dispose();
    _causeOfDeathController.dispose();
    _locationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add family member'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create a new branch',
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add a family member and connect them to a parent or founder when you are ready.',
                            style: textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Basic details',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Full name',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _roleController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Role or relationship',
                              prefixIcon: Icon(Icons.badge_outlined),
                              hintText: 'Example: Grandmother, Son, Aunt',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _relationshipController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Relationship role',
                              prefixIcon: Icon(Icons.family_restroom_outlined),
                              hintText: 'Example: Husband, Wife, Son, Daughter',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _occupationController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Occupation',
                              prefixIcon: Icon(Icons.work_outline),
                              hintText: 'Example: Teacher, Farmer, Caregiver',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _birthYearController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    labelText: 'Birth year',
                                    prefixIcon: Icon(Icons.cake_outlined),
                                    hintText: 'YYYY',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _deathYearController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    labelText: 'Death year',
                                    prefixIcon: Icon(Icons.nights_stay_outlined),
                                    hintText: 'YYYY',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _locationController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Location',
                              prefixIcon: Icon(Icons.location_on_outlined),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _noteController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Short note',
                              prefixIcon: Icon(Icons.notes_outlined),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Life details',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SwitchListTile.adaptive(
                            value: _isAlive,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (value) => setState(() => _isAlive = value),
                            title: const Text('Living person'),
                            subtitle: const Text(
                              'Turn this off if this person is deceased.',
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (!_isAlive) ...[
                            DropdownButtonFormField<CauseCategory>(
                              key: ValueKey(_selectedCauseCategory?.name ?? 'cause-none'),
                              initialValue: _selectedCauseCategory,
                              decoration: const InputDecoration(
                                labelText: 'Cause category',
                                prefixIcon: Icon(Icons.label_important_outline),
                              ),
                              items: CauseCategory.values
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c.label),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) => setState(() => _selectedCauseCategory = v),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _causeOfDeathController,
                              decoration: const InputDecoration(
                                labelText: 'Cause of death (notes)',
                                prefixIcon: Icon(Icons.medical_services_outlined),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SwitchListTile.adaptive(
                              value: _shareCause,
                              contentPadding: EdgeInsets.zero,
                              onChanged: (v) => setState(() => _shareCause = v),
                              title: const Text('Share cause of death with family'),
                              subtitle: const Text('Turn off to keep cause private'),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (widget.allMembers.isNotEmpty)
                            DropdownButtonFormField<String>(
                              key: ValueKey(_selectedSpouseId ?? 'spouse-none'),
                              initialValue: _selectedSpouseId,
                              decoration: const InputDecoration(
                                labelText: 'Spouse or partner',
                                prefixIcon: Icon(Icons.favorite_outline),
                              ),
                              items: widget.allMembers
                                  .map(
                                    (member) => DropdownMenuItem(
                                      value: member.id,
                                      child: Text(member.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) => setState(() => _selectedSpouseId = value),
                            ),
                          if (widget.allMembers.isNotEmpty) const SizedBox(height: 12),
                          if (widget.forceFounder)
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                'This member will start a new generation branch without selecting a parent.',
                                style: textTheme.bodyMedium,
                              ),
                            )
                          else if (widget.allMembers.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                'This will become the family founder.',
                                style: textTheme.bodyMedium,
                              ),
                            )
                          else
                            SwitchListTile.adaptive(
                              value: _isFounder,
                              contentPadding: EdgeInsets.zero,
                              onChanged: (value) {
                                setState(() {
                                  _isFounder = value;
                                  if (_isFounder) {
                                    _selectedParentId = null;
                                  }
                                });
                              },
                              title: const Text('Make this person the founder'),
                              subtitle: const Text(
                                'Turn this on if this person starts a new branch.',
                              ),
                            ),
                          const SizedBox(height: 12),
                          if (!_isFounder && widget.allMembers.isNotEmpty)
                            DropdownButtonFormField<String>(
                              key: ValueKey(_selectedParentId ?? 'parent-none'),
                              initialValue: _selectedParentId,
                              decoration: const InputDecoration(
                                labelText: 'Choose parent',
                                prefixIcon: Icon(Icons.family_restroom_outlined),
                              ),
                              items: widget.allMembers
                                  .map(
                                    (member) => DropdownMenuItem(
                                      value: member.id,
                                      child: Text(member.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedParentId = value;
                                });
                              },
                              validator: (value) {
                                if (!_isFounder && value == null) {
                                  return 'Please select a parent';
                                }
                                return null;
                              },
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _openFamilyHistoryDialog,
                            icon: const Icon(Icons.history_edu_outlined),
                            label: const Text('Family history'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _saveMember,
                            icon: const Icon(Icons.check),
                            label: const Text('Save member'),
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
      ),
    );
  }

  Future<void> _openFamilyHistoryDialog() async {
    final controller = TextEditingController(text: _noteController.text);
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Family history'),
          content: SizedBox(
            width: double.maxFinite,
            child: TextField(
              controller: controller,
              maxLines: 8,
              minLines: 5,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Add notes about family traditions, stories, milestones, and memories...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Save note'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        _noteController.text = result.trim();
        _noteController.selection = TextSelection.fromPosition(
          TextPosition(offset: _noteController.text.length),
        );
      });
    }
  }

  void _saveMember() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final role = _roleController.text.trim().isEmpty
        ? 'Family member'
        : _roleController.text.trim();
    final relationshipRole = _relationshipController.text.trim().isEmpty
        ? 'Family member'
        : _relationshipController.text.trim();
    final occupation = _occupationController.text.trim();
    final birthYear = _birthYearController.text.trim();
    final deathYear = _deathYearController.text.trim();
    final causeOfDeath = _causeOfDeathController.text.trim();
    final causeCategory = _selectedCauseCategory;
    final shareCause = _shareCause;
    final location = _locationController.text.trim();
    final note = _noteController.text.trim();

    final newMemberId = 'm${DateTime.now().millisecondsSinceEpoch}';
    final newMember = FamilyMember(
      id: newMemberId,
      name: name,
      role: role,
      generation: _isFounder || widget.allMembers.isEmpty
          ? 0
          : _generationOfParent(_selectedParentId!),
      parentId: _isFounder || widget.allMembers.isEmpty
          ? null
          : _selectedParentId,
      childIds: const [],
      location: location.isEmpty ? null : location,
      note: note.isEmpty ? null : note,
      relationshipRole: relationshipRole,
      status: _isAlive ? LifeStatus.alive : LifeStatus.deceased,
      spouseId: _selectedSpouseId,
      occupation: occupation.isEmpty ? null : occupation,
      birthYear: birthYear.isEmpty ? null : birthYear,
      deathYear: deathYear.isEmpty ? null : deathYear,
      causeOfDeath: causeOfDeath.isEmpty ? null : causeOfDeath,
      causeCategory: causeCategory,
      causeVisible: shareCause,
    );

    widget.onSave(newMember);
    Navigator.pop(context);
  }

  int _generationOfParent(String parentId) {
    final parent = widget.allMembers.firstWhere(
      (member) => member.id == parentId,
      orElse: () => widget.allMembers.first,
    );
    return parent.generation + 1;
  }
}
