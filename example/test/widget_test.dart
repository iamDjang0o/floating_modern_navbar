import 'package:flutter_test/flutter_test.dart';
import 'package:floating_modern_navbar_example/main.dart';

void main() {
  testWidgets('renders example app', (WidgetTester tester) async {
    await tester.pumpWidget(const FloatingModernNavBarExampleApp());
    expect(find.text('Home'), findsNWidgets(2));
    expect(
      find.text('Minimal and modern floating nav for Flutter apps.'),
      findsOneWidget,
    );
  });
}
