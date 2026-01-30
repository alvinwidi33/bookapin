import 'package:bookapin/components/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'Menampilkan semua menu (Home, My Rents, Profile)',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: CurvedBottomNavBar(
              currentIndex: 0,
              onTap: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('My Rents'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    },
  );

  testWidgets(
    'Tap Home memanggil onTap dengan index 0',
    (tester) async {
      int? tappedIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: CurvedBottomNavBar(
              currentIndex: 1,
              onTap: (index) {
                tappedIndex = index;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      expect(tappedIndex, 0);
    },
  );

  testWidgets(
    'Tap My Rents memanggil onTap dengan index 1',
    (tester) async {
      int? tappedIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: CurvedBottomNavBar(
              currentIndex: 0,
              onTap: (index) {
                tappedIndex = index;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('My Rents'));
      await tester.pumpAndSettle();

      expect(tappedIndex, 1);
    },
  );

  testWidgets(
    'Tap Profile memanggil onTap dengan index 2',
    (tester) async {
      int? tappedIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: CurvedBottomNavBar(
              currentIndex: 0,
              onTap: (index) {
                tappedIndex = index;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(tappedIndex, 2);
    },
  );
}
