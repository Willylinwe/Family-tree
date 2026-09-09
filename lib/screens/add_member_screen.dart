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

    return Scaffold(
      appBar: AppBar(title: const Text('Add family member'), elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create a new branch in your family tree',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add a person and connect them to a parent if you want to build the tree step by step. For a family foundation, start with a husband and wife pair and mark each person as alive or deceased.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
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
                  decoration: const InputDecoration(
                    labelText: 'Role or relationship',
                    prefixIcon: Icon(Icons.badge_outlined),
                    hintText: 'Example: Grandmother, Son, Aunt',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _relationshipController,
                  decoration: const InputDecoration(
                    labelText: 'Relationship role',
                    prefixIcon: Icon(Icons.family_restroom_outlined),
                    hintText: 'Example: Husband, Wife, Son, Daughter',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _occupationController,
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
                  controller: _causeOfDeathController,
                  decoration: const InputDecoration(
                    labelText: 'Cause of death',
                    prefixIcon: Icon(Icons.medical_services_outlined),
                    hintText: 'Example: Heart disease, accident, stroke',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _locationController,
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
                const SizedBox(height: 12),
                SwitchListTile.adaptive(
                  value: _isAlive,
                  onChanged: (value) => setState(() => _isAlive = value),
                  title: const Text('Living person'),
                  subtitle: const Text('Turn this off if this person is deceased.'),
                ),
                const SizedBox(height: 12),
                if (widget.allMembers.isNotEmpty)
                  DropdownButtonFormField<String>(
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
                const SizedBox(height: 20),
                if (widget.forceFounder)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'This member will start a new generation branch without selecting a parent.',
                    ),
                  )
                else if (widget.allMembers.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text('This will become the family founder.'),
                  )
                else
                  SwitchListTile.adaptive(
                    value: _isFounder,
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
                const SizedBox(height: 8),
                if (!_isFounder && widget.allMembers.isNotEmpty)
                  DropdownButtonFormField<String>(
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
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveMember,
                    icon: const Icon(Icons.check),
                    label: const Text('Save member'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
