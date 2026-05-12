import 'package:flutter_test/flutter_test.dart';
import 'package:prompt_vault/main.dart';

void main() {
  testWidgets('App initialization smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PromptVaultApp());

    // Verify that the app title or main screen loads.
    expect(find.text('PromptVault'), findsWidgets);
  });
}
