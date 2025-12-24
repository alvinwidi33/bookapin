import 'package:bookapin/components/navbar.dart';
import 'package:bookapin/components/theme_data.dart';
import 'package:bookapin/features/customers/home/bloc/home_bloc.dart';
import 'package:bookapin/features/customers/home/bloc/home_event.dart';
import 'package:bookapin/features/customers/home/bloc/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final state = context.read<HomeBloc>().state;

    if (_isBottom && state is HomeLoaded && !state.isLoadingMore) {
      context.read<HomeBloc>().add(LoadMoreBooks());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width * 0.92;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: screenWidth,
            child: Column(
              children: [
                SizedBox(height: 16),
                _buildSearchBar(),
                SizedBox(height: 24),
                Expanded(
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is HomeError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, size: 64, color: Colors.red),
                              SizedBox(height: 16),
                              Text(
                                'Error: ${state.message}',
                                style: TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<HomeBloc>().add(
                                    FetchAllBooks(isRefresh: true),
                                  );
                                },
                                child: Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is HomeLoaded) {
                        if (state.allBooks.isEmpty) {
                          return const Center(
                            child: Text('No books available'),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () async {
                            context.read<HomeBloc>().add(
                              FetchAllBooks(isRefresh: true),
                            );
                          },
                          child: Column(
                            children: [
                              Expanded(
                                child: GridView.builder(
                                  controller: _scrollController,
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(bottom: 8),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.72,
                                  ),
                                  itemCount: state.allBooks.length,
                                  itemBuilder: (context, index) {
                                    final book = state.allBooks[index];
                                    return _BookCard(book: book);
                                  },
                                ),
                              ),

                              // ✅ LOADING BENAR-BENAR TENGAH
                              if (state.isLoadingMore)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }


                      return SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CurvedBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == _currentIndex) return;
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/history');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            decoration: AppTheme.inputContainerDecoration,
            clipBehavior: Clip.antiAlias,
            child: TextField(
              decoration: AppTheme.inputDecoration("Search here").copyWith(
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search, color: AppTheme.iconColor),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.googleBlue,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.googleBlue.withValues(alpha: 0.24),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.all(12),
          child: Icon(Icons.filter_list, size: 32, color: Colors.white),
        )
      ],
    );
  }
}

class _BookCard extends StatelessWidget {
  final dynamic book;

  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.pushNamed(
          context,
          "/detail-book",
          arguments: book.id,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // ✅ SATU-SATUNYA FLEXIBLE WIDGET
              Expanded(
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: Container(
                    color: Colors.grey.shade100,
                    child: (book.coverImage != null &&
                            book.coverImage!.isNotEmpty)
                        ? Image.network(
                            book.coverImage!,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => _noImage(),
                          )
                        : _noImage(),
                  ),
                ),
              ),

              // ✅ CONTENT BAWAH TIDAK FLEKSIBEL
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // 🔥 PENTING
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title ?? 'Unknown',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.cardTitle,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.person_2_outlined,
                            size: 12, color: AppTheme.iconColor),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            book.author ?? 'Unknown',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.cardBody,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: _InfoChip(
                            icon: Icons.category,
                            text: book.category ?? 'N/A',
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Rp 5000/day',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.cardBody.copyWith(fontWeight: FontWeight.bold, color:AppTheme.primaryPurple),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _noImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.image_not_supported_outlined,
            size: 40, color: Colors.grey),
        SizedBox(height: 6),
        Text(
          'No cover',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(icon, size: 14.4, color: AppTheme.googleBlue),
        ),
        const SizedBox(width: 4),
        Expanded(
          child:Text( 
          text,
          style: const TextStyle(fontSize: 10.8),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        ),
      ],
    );
  }
}