import 'package:flutter_test/flutter_test.dart';
import 'package:taxytac_mobile/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TaxyTacApp());

    // Verify that the app title is displayed
    expect(find.text('TaxyTac - Demo'), findsOneWidget);
  });
}
