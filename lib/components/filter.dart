import 'package:flutter/material.dart';
import 'package:bookapin/components/theme_data.dart';

class BookFilterSheet extends StatefulWidget {
  final List<String> selectedCategories;
  final String? selectedYear;
  final String? selectedSort;
  final Function(List<String>, String?, String?) onApplyFilter;

  const BookFilterSheet({
    super.key,
    required this.selectedCategories,
    this.selectedYear,
    this.selectedSort,
    required this.onApplyFilter,
  });

  @override
  State<BookFilterSheet> createState() => _BookFilterSheetState();
}

class _BookFilterSheetState extends State<BookFilterSheet> {
  late List<String> _selectedCategories;
  String? _selectedYear;
  String? _selectedSort;

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

  final List<String> _availableYears = [
    '2025',
    '2024',
    '2023',
    '2022',
    '2021',
    '2020',
    '2019',
    '2018',
    '2017',
    '2016',
    '2015',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategories = List.from(widget.selectedCategories);
    _selectedYear = widget.selectedYear;
    _selectedSort = widget.selectedSort;
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
                  _buildSortSection(),
                  const SizedBox(height: 24),
                  _buildYearSection(),
                  const SizedBox(height: 24),
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
            'Filter & Sort',
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

  Widget _buildSortSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sort By',
              style: AppTheme.titleDetail,
            ),
            if (_selectedSort != null)
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedSort = null;
                  });
                },
                child: Text(
                  'Clear',
                  style: AppTheme.linkStyle.copyWith(fontSize: 12),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        _SortOption(
          icon: Icons.new_releases,
          title: 'Newest First',
          subtitle: 'Most recent publications',
          isSelected: _selectedSort == 'newest',
          onTap: () {
            setState(() {
              _selectedSort = _selectedSort == 'newest' ? null : 'newest';
            });
          },
        ),
        const SizedBox(height: 8),
        _SortOption(
          icon: Icons.history,
          title: 'Oldest First',
          subtitle: 'Earliest publications',
          isSelected: _selectedSort == 'oldest',
          onTap: () {
            setState(() {
              _selectedSort = _selectedSort == 'oldest' ? null : 'oldest';
            });
          },
        ),
      ],
    );
  }

  Widget _buildYearSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Publication Year',
              style: AppTheme.titleDetail,
            ),
            if (_selectedYear != null)
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedYear = null;
                  });
                },
                child: Text(
                  'Clear',
                  style: AppTheme.linkStyle.copyWith(fontSize: 12),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableYears.map((year) {
            final isSelected = _selectedYear == year;
            return _CategoryChip(
              label: year,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  _selectedYear = isSelected ? null : year;
                });
              },
            );
          }).toList(),
        ),
      ],
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
                _selectedYear = null;
                _selectedSort = null;
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
              'Reset All',
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
                  _selectedCategories,
                  _selectedYear,
                  _selectedSort,
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
                'Apply',
                style: AppTheme.buttonStyle.copyWith(fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SortOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryPurple.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryPurple : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryPurple : AppTheme.iconColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.cardTitle.copyWith(
                      color: isSelected ? AppTheme.primaryPurple : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTheme.cardBody.copyWith(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppTheme.primaryPurple,
                size: 24,
              ),
          ],
        ),
      ),
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