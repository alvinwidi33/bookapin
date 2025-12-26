import 'package:flutter/material.dart';
import 'package:bookapin/components/theme_data.dart';

class BookFilterSheet extends StatefulWidget {
  final List<String> selectedCategories;
  final Function(List<String>) onApplyFilter;

  const BookFilterSheet({
    super.key,
    required this.selectedCategories,

    required this.onApplyFilter,
  });

  @override
  State<BookFilterSheet> createState() => _BookFilterSheetState();
}

class _BookFilterSheetState extends State<BookFilterSheet> {
  late List<String> _selectedCategories;

  final List<String> _availableCategories = [
    'Picture Books',
    'Self-Improvement',
    'Activity Books',
    'Culinary',
    'Literary',
    'Romance',
    'Harlequin',
    'Mysteries & Thrillers',
    'Science Fiction & Fantasy',
    'Social Sciences',
    'Business Management & Leadership',
    'Poetry',
    'MetroPop',
    'TeenLit',
    'Young Adult',
    'Historical Romance',
    'Religion & Spirituality',
    'Short Stories',
    'Diet & Health',
    'English Classics',
    'English Classics - Terjemahan',
    'AsianLit - Japan',
    'AsianLit - Korea',
    'AsianLit - China/Taiwan/Hongkong',
    'AsianLit - Others',
    'Fashion & Beauty',
    'Biography',
    'Science & Nature',
    'Latin American Literature',
    'Craft',
    'Parenting & Family',
    'Historical Fiction',
    'Middle Grade Readers',
    'Economics & Accounting',
    'Inspirational',
    'Business & Economics',
    'Novel',
    'Slice of Life',
    'Politics',
    'Reference & Dictionary',
    'Philosophy',
    'Board Books',
    'Humor',
    'Classics',
    'Psychology',
    'Comics',
    'Graphic Novel',
    'Encyclopedia',
    'Adult',
    'Agriculture',
    'Marketing & Public Relation',
    'Memoir',
    'Law',
    'Classic Books',
    'Culture',
    'Entertainment',
    'Coloring Books for Grown-Ups',
    'Amore',
    'Education & Teaching',
    'English Classics - Poem',
    'Illustrated Book',
    'Travel',
    'Investment & Banking',
    'Beginning Readers',
    'Drama',
    'Nonfiction',
    'Medical',
    'Movie Tie-In',
    'Sport',
    'Media & Communication',
    'Art, Architecture, & Photography',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategories = List.from(widget.selectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategorySection(),
                  const SizedBox(height: 32),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filter Books',
            style: AppTheme.headingStyle,
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            color: AppTheme.iconColor,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: AppTheme.titleDetail,
            ),
            if (_selectedCategories.isNotEmpty)
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedCategories.clear();
                  });
                },
                child: Text(
                  'Clear All',
                  style: AppTheme.linkStyle.copyWith(fontSize: 12),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableCategories.map((category) {
            final isSelected = _selectedCategories.contains(category);
            return _CategoryChip(
              label: category,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedCategories.remove(category);
                  } else {
                    _selectedCategories.add(category);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _selectedCategories.clear();
              });
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.primaryPurple, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'Reset',
              style: AppTheme.buttonStyle.copyWith(
                color: AppTheme.primaryPurple,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Container(
            decoration: AppTheme.buttonDecorationPrimary,
            child: ElevatedButton(
              onPressed: () {
                widget.onApplyFilter(
                  _selectedCategories
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Apply Filter',
                style: AppTheme.buttonStyle.copyWith(fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryPurple : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryPurple
                : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryPurple.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: AppTheme.cardBody.copyWith(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
