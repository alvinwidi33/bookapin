import 'package:bookapin/components/navbar_admin.dart';
import 'package:bookapin/components/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';
import 'package:bookapin/features/admin/dashboard/bloc/dashboard_bloc.dart';
import 'package:bookapin/features/admin/dashboard/bloc/dashboard_event.dart';
import 'package:bookapin/features/admin/dashboard/bloc/dashboard_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
  
}

class _DashboardPageState extends State<DashboardPage> {
  final int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadDashboardStats());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryPurple,
              ),
            );
          }

          if (state is DashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppTheme.iconColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: AppTheme.cardBody
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DashboardBloc>().add(LoadDashboardStats());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Coba Lagi',
                      style: AppTheme.cardTitle,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is DashboardLoaded) {
            final genreList = state.genreStatistics
                .where((e) => e.genre != null && e.genre!.isNotEmpty)
                .map(
                  (e) => GenreData(
                    genre: e.genre!,
                    count: e.count,
                  ),
                )
                .toList();

            final totalGenres = genreList.length;
            final totalBooks =
                genreList.fold(0, (sum, item) => sum + item.count);
            final top10 = genreList.take(10).toList();
            final maxCount = top10.isNotEmpty ? top10.first.count : 1;

            return SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<DashboardBloc>().add(LoadDashboardStats());
                },
                color: AppTheme.primaryPurple,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Book Genre Dashboard',
                        style: AppTheme.headingStyle
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Statistics and insights from your book collection',
                        style: AppTheme.bodyStyle
                      ),
                      const SizedBox(height: 24),

                      // Statistics Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Total Books',
                              totalBooks.toString(),
                              Icons.book,
                              AppTheme.gradientStart,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Total Genres',
                              totalGenres.toString(),
                              Icons.category,
                              AppTheme.gradientEnd,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Most Popular',
                              genreList.isNotEmpty
                                  ? genreList.first.genre
                                  : '-',
                              Icons.star,
                              AppTheme.iconColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Top Genre Count',
                              genreList.isNotEmpty
                                  ? genreList.first.count.toString()
                                  : '0',
                              Icons.trending_up,
                              AppTheme.googleBlue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      Text(
                        'Top 10 Most Popular Genres',
                        style: AppTheme.headingStyle.copyWith(
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: top10.map((genre) {
                            final percentage = (genre.count / maxCount);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          genre.genre,
                                          style: AppTheme.subtitleDetail,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        genre.count.toString(),
                                        style: AppTheme.cardTitle.copyWith(
                                          color: AppTheme.primaryPurple,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: percentage,
                                      minHeight: 10,
                                      backgroundColor: Colors.grey[200],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        _getGradientColor(percentage),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Distribution Chart
                      Text(
                        'Genre Distribution (Top 5)',
                        style: AppTheme.headingStyle.copyWith(
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 200,
                              height: 200,
                              child: totalBooks > 0
                                  ? CustomPaint(
                                      painter: PieChartPainter(
                                        genreList.take(5).toList(),
                                        totalBooks,
                                      ),
                                    )
                                  : const Center(
                                      child: Text('No data available'),
                                    ),
                            ),

                            const SizedBox(height: 20),
                            ...genreList.take(5).map((genre) {
                              final percentage =
                                  (genre.count / totalBooks * 100);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: _getColorForIndex(
                                          genreList.indexOf(genre),
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        genre.genre,
                                        style: AppTheme.cardBody,
                                      ),
                                    ),
                                    Text(
                                      '${percentage.toStringAsFixed(1)}%',
                                      style: AppTheme.cardBody
                                    ),
                                  ],
                                ),
                              );
                            })
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: SafeArea(
        top: false, 
        child: CurvedBottomNavBarAdmin(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == _currentIndex) return;
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/dashboard');
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, '/users');
            } else if (index == 2) {
              Navigator.pushReplacementNamed(context, '/profile');
            }
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: AppTheme.cardBody
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTheme.cardBody,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }


  Color _getGradientColor(double percentage) {
    return Color.lerp(
      AppTheme.gradientStart,
      AppTheme.gradientEnd,
      percentage,
    )!;
  }

  Color _getColorForIndex(int index) {
    final colors = [
      AppTheme.gradientStart,
      AppTheme.gradientEnd,
      AppTheme.iconColor,
      AppTheme.googleBlue,
      AppTheme.primaryPurple,
    ];
    return colors[index % colors.length];
  }
}

class GenreData {
  final String genre;
  final int count;

  GenreData({required this.genre, required this.count});
}

class PieChartPainter extends CustomPainter {
  final List<GenreData> data;
  final int total;

  PieChartPainter(this.data, this.total);

  @override
  void paint(Canvas canvas, Size size) {
    if (total <= 0) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 * 0.8;
    double startAngle = -90 * 3.14159 / 180;

    final colors = [
      AppTheme.gradientStart,
      AppTheme.gradientEnd,
      AppTheme.iconColor,
      AppTheme.googleBlue,
      AppTheme.primaryPurple,
    ];

    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i].count / total) * 2 * 3.14159;
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Draw white circle in center for donut effect
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.5, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}