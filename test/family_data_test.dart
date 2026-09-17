import 'package:flutter_test/flutter_test.dart';
import 'package:family_tree_app/controllers/family_controller.dart';
import 'package:family_tree_app/data/family_data.dart';
import 'package:family_tree_app/models/family_member.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('FamilyData', () {
    test('builds a multi-generation family tree with a root member', () {
      final members = FamilyData.sampleFamily();

      expect(members.isNotEmpty, isTrue);
      expect(members.where((member) => member.parentId == null).length, 1);
      expect(members.length, greaterThan(5));
    });

    test('finds ancestors for a grandchild correctly', () {
      final members = FamilyData.sampleFamily();
      final grandchild = members.firstWhere((member) => member.id == 'm4');

      final ancestors = FamilyData.ancestorsOf(grandchild, members);

      expect(ancestors.map((member) => member.id), ['m2', 'm1']);
    });
  });

  group('FamilyController', () {
    test('removes a created member and cleans up parent and spouse links', () async {
      final controller = FamilyController();
      final founder = FamilyMember(
        id: 'founder',
        name: 'Ava',
        role: 'Founder',
        generation: 0,
      );
      final spouse = FamilyMember(
        id: 'spouse',
        name: 'Ben',
        role: 'Spouse',
        generation: 0,
      );
      final child = FamilyMember(
        id: 'child',
        name: 'Cara',
        role: 'Daughter',
        generation: 1,
        parentId: founder.id,
        spouseId: spouse.id,
      );

      await controller.addMember(founder);
      await controller.addMember(spouse);
      await controller.addMember(child);

      await controller.removeMember(child.id);

      expect(controller.getMemberById(child.id), isNull);
      expect(controller.getMemberById(founder.id)!.childIds, isEmpty);
      expect(controller.getMemberById(spouse.id)!.spouseId, isNull);
    });
  });
}
