import 'package:flutter_test/flutter_test.dart';
import 'package:family_tree_app/main.dart' as app;
import 'package:family_tree_app/screens/home_screen.dart';
import 'package:family_tree_app/widgets/stats_card.dart';

void main() {
  testWidgets('debug tap members stat card', (tester) async {
    await tester.pumpWidget(const app.FamilyTreeApp());

    final cards = tester.widgetList(find.byType(StatsCard)).toList();
    print('statsCard count=${cards.length}');
    for (final card in cards) {
      final c = card as StatsCard;
      print('title=${c.title}, onTap=${c.onTap != null}');
    }

    final firstCard = find.byType(StatsCard).first;
    await tester.ensureVisible(firstCard);
    await tester.pump();
    await tester.tap(firstCard);
    await tester.pumpAndSettle();

    print('after tap route widgets:');
    final types = tester.allWidgets.map((w) => w.runtimeType.toString()).toList();
    for (final type in types.take(50)) {
      print(type);
    }
  });
}
