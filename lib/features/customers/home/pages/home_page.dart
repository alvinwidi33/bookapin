import 'package:bookapin/components/navbar.dart';
import 'package:bookapin/components/theme_data.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    int _currentIndex = 0;

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Expanded(
                      child: Container(
                        decoration: AppTheme.inputContainerDecoration,
                        clipBehavior: Clip.antiAlias,
                        child: TextField(
                          decoration: AppTheme.inputDecoration("Search here").copyWith(
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.search, color:AppTheme.iconColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width:12),
                    Container(
                      decoration:BoxDecoration(
                        color:AppTheme.googleBlue,
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
                      child: Icon(Icons.filter_list, size:32 , color:Colors.white),
                    )
                  ]
                ),
                SizedBox(height:40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha:0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 108,
                              width: double.infinity,
                              child: Image.asset(
                                'assets/Harry Potter.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Cecilja',
                                        style: AppTheme.cardTitle
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.star, color: Colors.amber, size: 12),
                                          SizedBox(width: 4),
                                          Text('4.8', style: AppTheme.cardBody),
                                        ],
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, size: 12, color: Colors.grey),
                                      SizedBox(width: 4),
                                      Text(
                                        'Karawang',
                                        style: AppTheme.cardBody,
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _InfoChip(
                                        icon: Icons.access_time,
                                        text: '09.00 - 20.00',
                                      ),
                                      _InfoChip(
                                        icon: Icons.attach_money,
                                        text: '500k/hari',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha:0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 108,
                              width: double.infinity,
                              child: Image.asset(
                                'assets/Harry Potter.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Cecilja',
                                        style: AppTheme.cardTitle
                                      ),
                                      Row(
                                        children: const [
                                          Icon(Icons.star, color: Colors.amber, size: 12),
                                          SizedBox(width: 4),
                                          Text('4.8', style: TextStyle(fontSize: 10.8),),
                                        ],
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 4),
                                  Row(
                                    children: const [
                                      Icon(Icons.location_on, size: 12, color: Colors.grey),
                                      SizedBox(width: 4),
                                      Text(
                                        'Karawang',
                                        style: TextStyle(color: Colors.grey, fontSize: 10.8),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _InfoChip(
                                        icon: Icons.access_time,
                                        text: '09.00 - 20.00',
                                      ),
                                      _InfoChip(
                                        icon: Icons.attach_money,
                                        text: '500k/hari',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CurvedBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        }
                ),
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
      children:[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(icon, size: 12, color: Colors.blue),       
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 8),
        ),
      ]
    );
  }
}