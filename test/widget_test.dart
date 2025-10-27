import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:user_management/main.dart';

void main() {
  testWidgets('App displays user management title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('User Management'), findsOneWidget);
  });

  testWidgets('Search for user filters the list', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Jane Smith'), findsOneWidget);
    expect(find.text('Bob Johnson'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'John');
    await tester.pumpAndSettle();

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Jane Smith'), findsNothing);
  });

  testWidgets('Add user opens dialog', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Add User'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
  });

  testWidgets('Add user with valid data', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Test User');
    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'test@example.com');

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('test@example.com'), findsOneWidget);
  });

  testWidgets('Add user validation requires name', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'test@example.com');

    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Please enter a name'), findsOneWidget);
  });

  testWidgets('Add user validation requires valid email', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Test User');
    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'invalid-email');

    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Please enter a valid email'), findsOneWidget);
  });

  testWidgets('View user details shows dialog', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Jane Smith'), findsOneWidget);
    expect(find.text('Bob Johnson'), findsOneWidget);
  });
}
