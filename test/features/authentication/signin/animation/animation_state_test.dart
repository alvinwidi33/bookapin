import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookapin/features/authentication/signin/animation/animation_state.dart';

void main() {
  Widget buildTestWidget(AuthAnimState state) {
    return MaterialApp(
      home: Scaffold(
        body: AuthIndicator(state: state),
      ),
    );
  }

  testWidgets('AuthIndicator hidden when idle', (tester) async {
    await tester.pumpWidget(buildTestWidget(AuthAnimState.idle));

    final opacityWidget =
        tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity).first);

    expect(opacityWidget.opacity, 0);
  });

  testWidgets('AuthIndicator shows email icon when typing email',
      (tester) async {
    await tester.pumpWidget(buildTestWidget(AuthAnimState.typingEmail));

    expect(find.byIcon(Icons.email), findsOneWidget);
    expect(find.text('Typing email'), findsOneWidget);
  });

  testWidgets('AuthIndicator shows lock icon when typing password',
      (tester) async {
    await tester.pumpWidget(buildTestWidget(AuthAnimState.typingPassword));

    expect(find.byIcon(Icons.lock), findsOneWidget);
    expect(find.text('Typing password'), findsOneWidget);
  });

  testWidgets('AuthIndicator shows loading indicator', (tester) async {
    await tester.pumpWidget(buildTestWidget(AuthAnimState.loading));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading'), findsOneWidget);
  });

  testWidgets('AuthIndicator shows success state', (tester) async {
    await tester.pumpWidget(buildTestWidget(AuthAnimState.success));

    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.text('Login Success'), findsOneWidget);
  });

  testWidgets('AuthIndicator shakes on error', (tester) async {
    await tester.pumpWidget(buildTestWidget(AuthAnimState.error));

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byIcon(Icons.lock), findsOneWidget);
    expect(find.text('Ups error'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 500));
  });
}
