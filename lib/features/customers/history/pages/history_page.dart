import 'package:bookapin/components/navbar.dart';
import 'package:bookapin/components/theme_data.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              const SizedBox(height:12),
              Text("My Rents", style:AppTheme.headingStyle),
              const SizedBox(height:24),
              Align(
                alignment: Alignment.center,
                child:Container(
                width: MediaQuery.of(context).size.width * 0.92,
                decoration:BoxDecoration(
                  color:Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.24),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                ),
                child:Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          "assets/Harry Potter.jpg",
                          width: 48,
                          height: 72,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text("Harry Potter and The Sorcerer Stone", style:AppTheme.cardTitle),
                        const SizedBox(height:4),
                        Text("Category", style:AppTheme.cardBody),
                        const SizedBox(height:12),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color:AppTheme.googleBlue,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color:AppTheme.googleBlue.withValues(alpha:0.24),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              ),
                              child: Icon(Icons.access_time, size:16, color:Colors.white),
                            ),
                            const SizedBox(width:4),
                            Text("Dec 12", style:AppTheme.cardBody),
                            const SizedBox(width:12),
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color:AppTheme.primaryPurple,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color:AppTheme.primaryPurple.withValues(alpha:0.24),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              ),
                              child: Icon(Icons.monetization_on, size:16, color:Colors.white),
                            ),
                            const SizedBox(width: 4),
                            Text("6000", style:AppTheme.cardBody),
                          ],
                        )
                      ]
                      ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child:Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color:AppTheme.iconColor,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color:AppTheme.iconColor.withValues(alpha:0.24),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )
                          ]
                        ),
                        child: Text("Not Return", style:AppTheme.cardBody),
                      ),
                      )
                    ],
                  )
                )
              ),
            ]
          ),
        )
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
}