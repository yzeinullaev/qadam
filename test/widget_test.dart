import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:qadam/app/app.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ru');
  });

  testWidgets('Qadam app loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: QadamApp()),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(QadamApp), findsOneWidget);
  });
}
