import 'dart:math';

import '../models/family_member.dart';

class FamilyData {
  static List<FamilyMember> sampleFamily() {
    return [
      FamilyMember(
        id: 'm1',
        name: 'Grandfather James',
        role: 'Founder',
        generation: 0,
        childIds: ['m2', 'm3'],
        location: 'Lagos',
        note: 'The family patriarch who started the family legacy.',
      ),
      FamilyMember(
        id: 'm2',
        name: 'Aunt Mary',
        role: 'Matriarch',
        generation: 1,
        parentId: 'm1',
        childIds: ['m4'],
        location: 'Lagos',
        note: 'Keeps the family traditions alive.',
      ),
      FamilyMember(
        id: 'm3',
        name: 'Uncle Daniel',
        role: 'Mentor',
        generation: 1,
        parentId: 'm1',
        childIds: ['m5'],
        location: 'Abuja',
        note: 'Protects the family stories and values.',
      ),
      FamilyMember(
        id: 'm4',
        name: 'Grace',
        role: 'Grandchild',
        generation: 2,
        parentId: 'm2',
        childIds: ['m6'],
        location: 'London',
        note: 'Represents the new generation building on the family line.',
      ),
      FamilyMember(
        id: 'm5',
        name: 'Samuel',
        role: 'Grandchild',
        generation: 2,
        parentId: 'm3',
        childIds: [],
        location: 'Accra',
        note: 'Strong bond to the elders and family values.',
      ),
      FamilyMember(
        id: 'm6',
        name: 'Nina',
        role: 'Great Grandchild',
        generation: 3,
        parentId: 'm4',
        childIds: [],
        location: 'Toronto',
        note: 'The future branch of the family tree.',
      ),
    ];
  }

  static List<FamilyMember> ancestorsOf(
    FamilyMember member,
    List<FamilyMember> members,
  ) {
    final familyById = {for (final item in members) item.id: item};
    final ancestors = <FamilyMember>[];
    String? currentParentId = member.parentId;

    while (currentParentId != null) {
      final parent = familyById[currentParentId];
      if (parent == null) {
        break;
      }
      ancestors.add(parent);
      currentParentId = parent.parentId;
    }

    return ancestors;
  }

  static int totalMembers(List<FamilyMember> members) => members.length;

  static int maxGeneration(List<FamilyMember> members) {
    return members.map((member) => member.generation).fold(0, max);
  }
}
