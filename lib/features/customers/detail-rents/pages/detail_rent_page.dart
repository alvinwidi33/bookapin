import 'package:bookapin/components/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailRent extends StatefulWidget {
  const DetailRent({super.key});

  @override
  State<DetailRent> createState() => _DetailRentState();
}

class _DetailRentState extends State<DetailRent> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child:Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.92,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.googleBlue,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.googleBlue.withValues(alpha: 0.24),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),

                    Expanded(
                      child: Center(
                        child: Text(
                          "Rent Detail",
                          style: AppTheme.headingStyle,
                        ),
                      ),
                    ),

                    const SizedBox(width: 40),
                  ],
                ),

                const SizedBox(height: 12),

                Container(
                  height: 320,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color:Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.24),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ]
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Harry Potter and The Philosopher's Stone",
                        style: AppTheme.titleDetail,
                      ),
                      Container(
                        width: 160,
                        padding: EdgeInsets.all(12),
                        child: Image.asset("assets/Harry Potter.jpg")
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color:AppTheme.primaryPurple,
                                  borderRadius: BorderRadius.circular(4)
                                ),
                                child: Icon(Icons.person, color: Colors.white, size:16),
                              ),
                              const SizedBox(width:4),
                              Text("J.K. Rowling", style:AppTheme.subtitleDetail),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color:AppTheme.googleBlue,
                                  borderRadius: BorderRadius.circular(4)
                                ),
                                child: Icon(Icons.category, color: Colors.white, size:16),
                              ),
                              const SizedBox(width:4),
                              Text("Category", style:AppTheme.subtitleDetail),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color:AppTheme.iconColor,
                                  borderRadius: BorderRadius.circular(4)
                                ),
                                child: Icon(Icons.pages, color: Colors.white, size:16),
                              ),
                              const SizedBox(width:4),
                              Text("Size", style:AppTheme.subtitleDetail),
                            ],
                          ),
                        ],
                      )
                    ],
                  )
                ),
                const SizedBox(height: 28),
                Text("Preview Rent Informations", style:AppTheme.headingStyle),
                const SizedBox(height: 8),
                Container(
  width: double.infinity,
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.12),
        blurRadius: 12,
        offset: const Offset(0, 4),
      )
    ],
  ),
  child: Column(
    children: [
      _infoRow("Borrowed At", "Dec 18, 2025"),
      const Divider(height: 24),
      _infoRow("Duration", "4 Days"),
      const Divider(height: 24),
      _infoRow("Price", "Rp 20.000", isPrice: true),
    ],
  ),
),
                SizedBox(height:20)
              ],
            ),
          ),
        ),
      ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Should return before: ",
                      style: AppTheme.subtitleDetail,
                    ),
                    Text(
                      "Dec 21, 2025 08:00",
                      style: AppTheme.titleDetail,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your fine: ",
                      style: AppTheme.subtitleDetail,
                    ),
                    Text(
                      "Rp. 25000",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:AppTheme.primaryPurple
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            GestureDetector(
              onTap: () {},
              child: Container(
                height: 56,
                decoration: AppTheme.buttonDecorationPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const SizedBox(width: 32),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Book Returned",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_right,
                      size: 32,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Widget _infoRow(String label, String value, {bool isPrice = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: AppTheme.subtitleDetail),
      Text(
        value,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isPrice ? AppTheme.primaryPurple : Colors.black,
        ),
      ),
    ],
  );
}

