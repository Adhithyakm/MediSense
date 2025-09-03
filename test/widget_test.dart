import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mainproject/screens/signup.dart'; // Make sure the import path matches your project structure

void main() {
  testWidgets('SignUpPage displays Email field', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SignUpPage()));

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
  });
}
