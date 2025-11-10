

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:contact_keeper/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(
      child: ContactKeeperApp(),
    ));

    expect(find.text('Contact Keeper'), findsOneWidget);
    expect(find.text('Belum ada kontak.'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
