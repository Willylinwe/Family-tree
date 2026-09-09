import 'package:flutter_test/flutter_test.dart';
import 'package:family_tree_app/data/family_data.dart';

void main() {
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
}
