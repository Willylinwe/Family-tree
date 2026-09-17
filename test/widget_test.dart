// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:family_tree_app/main.dart' as app;
import 'package:family_tree_app/models/family_member.dart';
import 'package:family_tree_app/screens/home_screen.dart';
import 'package:family_tree_app/widgets/stats_card.dart';

void main() {
  testWidgets('renders the family app home screen', (tester) async {
    await tester.pumpWidget(const app.FamilyTreeApp());

    expect(find.text('My Family Tree'), findsOneWidget);
    expect(find.text('Start your family story'), findsOneWidget);
  });

  testWidgets('shows the deceased members biography action', (tester) async {
    await tester.pumpWidget(const app.FamilyTreeApp());

    expect(find.text('Biography of the departed'), findsOneWidget);
  });

  testWidgets('shows the family lineage map action', (tester) async {
    await tester.pumpWidget(const app.FamilyTreeApp());

    expect(find.text('Family lineage map'), findsOneWidget);
  });

  testWidgets('shows the Members stat card and directory route', (tester) async {
    await tester.pumpWidget(const app.FamilyTreeApp());

    final statsCard = find.byType(StatsCard);
    expect(statsCard, findsAtLeastNWidgets(1));

    await tester.ensureVisible(statsCard.first);
    await tester.pump();
    await tester.tap(statsCard.first);
    await tester.pump();

    expect(find.byType(MembersDirectoryScreen), findsOneWidget);
    expect(find.text('Members'), findsAtLeastNWidgets(2));
  });

  testWidgets('shows the generations summary route without member cards', (tester) async {
    await tester.pumpWidget(const app.FamilyTreeApp());

    final statsCards = find.byType(StatsCard);
    expect(statsCards, findsAtLeastNWidgets(2));

    await tester.ensureVisible(statsCards.at(1));
    await tester.pump();
    await tester.tap(statsCards.at(1));
    await tester.pumpAndSettle();

    expect(find.byType(GenerationsSummaryScreen), findsOneWidget);
    expect(find.text('Generations'), findsAtLeastNWidgets(2));
    expect(find.text('Total population'), findsOneWidget);
    expect(find.text('Members'), findsNothing);
  });

  testWidgets('shows live member totals including living and deceased counts', (tester) async {
    await tester.pumpWidget(const app.FamilyTreeApp());

    final membersCard = find.byType(StatsCard).first;
    await tester.ensureVisible(membersCard);
    await tester.pump();
    await tester.tap(membersCard);
    await tester.pumpAndSettle();

    expect(find.text('Total members'), findsOneWidget);
    expect(find.text('Living'), findsOneWidget);
    expect(find.text('Deceased'), findsOneWidget);
  });

  testWidgets('filters the members list by living and deceased status', (tester) async {
    final members = [
      const FamilyMember(
        id: '1',
        name: 'Alice Smith',
        role: 'Matriarch',
        generation: 0,
        gender: FamilyGender.female,
        status: LifeStatus.alive,
      ),
      const FamilyMember(
        id: '2',
        name: 'Bob Smith',
        role: 'Patriarch',
        generation: 0,
        gender: FamilyGender.male,
        status: LifeStatus.deceased,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: MembersDirectoryScreen(members: members),
      ),
    );

    await tester.tap(find.text('Living'));
    await tester.pumpAndSettle();

    expect(find.text('Alice Smith'), findsOneWidget);
    expect(find.text('Bob Smith'), findsNothing);

    await tester.tap(find.text('Deceased'));
    await tester.pumpAndSettle();

    expect(find.text('Alice Smith'), findsNothing);
    expect(find.text('Bob Smith'), findsOneWidget);
  });

  testWidgets('adds a sibling using the same parent automatically', (tester) async {
    final parent = const FamilyMember(
      id: 'parent-1',
      name: 'Parent One',
      role: 'Matriarch',
      generation: 0,
      gender: FamilyGender.female,
    );
    final sibling = const FamilyMember(
      id: 'child-1',
      name: 'First Child',
      role: 'Daughter',
      generation: 1,
      parentId: 'parent-1',
      gender: FamilyGender.female,
    );

    FamilyMember? savedMember;

    await tester.pumpWidget(
      MaterialApp(
        home: AddMemberScreen(
          allMembers: const [parent, sibling],
          onSave: (member) => savedMember = member,
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'Second Child');
    await tester.tap(find.byKey(const ValueKey('sibling-selector')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('First Child').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save member'));
    await tester.pumpAndSettle();

    expect(savedMember, isNotNull);
    expect(savedMember!.parentId, equals('parent-1'));
    expect(savedMember!.generation, equals(1));
  });

  testWidgets('shows the cause of death intent on the form', (tester) async {
    await tester.pumpWidget(const app.FamilyTreeApp());

    expect(find.text('Cause of death'), findsNothing);
  });
}
