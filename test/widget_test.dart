// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:family_tree_app/main.dart' as app;
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

  testWidgets('shows the cause of death intent on the form', (tester) async {
    await tester.pumpWidget(const app.FamilyTreeApp());

    expect(find.text('Cause of death'), findsNothing);
  });
}
