import 'package:bookapin/components/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailBook extends StatefulWidget {
  const DetailBook({super.key});

  @override
  State<DetailBook> createState() => _DetailBookState();
}

class _DetailBookState extends State<DetailBook> {
  int qty = 1;
  final int pricePerDay = 5000;
  int selectedTab = 0; 

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
                          "Book Detail",
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
                Text("Preview Book Informations", style:AppTheme.headingStyle),
                const SizedBox(height: 8),
                
                // Container with Tab and Content
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
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
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => selectedTab = 0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: selectedTab == 0
                                      ? AppTheme.primaryPurple
                                      : Colors.grey.shade200,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Summary",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: selectedTab == 0
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => selectedTab = 1),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: selectedTab == 1
                                      ? AppTheme.primaryPurple
                                      : Colors.grey.shade200,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Details",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: selectedTab == 1
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),     
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: selectedTab == 0
                              ? _buildSummaryContent()
                              : _buildDetailsContent(),
                        ),
                      ),

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rent books for",
                  style: AppTheme.subtitleDetail,
                ),

                Row(
                  children: [
                    _QtyButton(
                      icon: Icons.remove,
                      onTap: qty > 1
                          ? () => setState(() => qty--)
                          : null,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "$qty",
                        style: AppTheme.titleDetail
                      ),
                    ),

                    _QtyButton(
                      icon: Icons.add,
                      onTap: qty < 7
                          ? () => setState(() => qty++)
                          : null,
                    ),
                    Text(qty == 1 ? " Day":" Days", style:AppTheme.subtitleDetail)
                  ],
                ),

                Text(
                  "Rp. ${(qty * pricePerDay).toString()}",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:AppTheme.primaryPurple
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            GestureDetector(
              onTap: () {
              },
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
                          "Rent Now",
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

  Widget _buildSummaryContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Summary", style: AppTheme.titleDetail),
        const SizedBox(height: 8),
        Text(
          "Harry Potter and the Philosopher's Stone is a fantasy novel written by British author J.K. Rowling. It is the first novel in the Harry Potter series and Rowling's debut novel. The story follows Harry Potter, a young wizard who discovers his magical heritage on his eleventh birthday.",
          style: AppTheme.cardBody,
        ),
      ],
    );
  }

  Widget _buildDetailsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, 
        mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildDetailRow("Publisher", "Bloomsbury Publishing"),
        const SizedBox(height: 12),
        _buildDetailRow("Publication Date", "26 June 1997"),
        const SizedBox(height: 12),
        _buildDetailRow("No GM", "GM-12345"),
        const SizedBox(height: 12),
        _buildDetailRow("ISBN", "978-0-7475-3269-9"),
        const SizedBox(height: 12),
        _buildDetailRow("Pages", "223 pages"),
        const SizedBox(height: 12),
        _buildDetailRow("Language", "English"),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.titleDetail),
        const SizedBox(height: 4),
        Text(value, style: AppTheme.cardBody),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QtyButton({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onTap == null ? Colors.grey : Colors.black,
        ),
      ),
    );
  }
}