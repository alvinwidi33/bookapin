import 'package:bookapin/components/filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  testWidgets(
  'Apply memanggil onApplyFilter dengan nilai yang benar',
  (tester) async {
    List<String>? categories;
    String? year;
    String? sort;

    await tester.pumpWidget(
      MaterialApp(
  home: Scaffold(
    body: Material(
      child: BookFilterSheet(
        selectedCategories: ['Novel'],
        selectedYear: '2024',
        selectedSort: 'newest',
        onApplyFilter: (c, y, s) {
          categories = c;
          year = y;
          sort = s;
        },
      ),
    ),
  ),
)
    );

    await tester.ensureVisible(find.text('Apply'));
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    expect(categories, ['Novel']);
    expect(year, '2024');
    expect(sort, 'newest');
  },
);
}
