// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:family_tree_app/main.dart' as app;

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

  testWidgets('shows the cause of death intent on the form', (tester) async {
    await tester.pumpWidget(const app.FamilyTreeApp());

    expect(find.text('Cause of death'), findsNothing);
  });
}
