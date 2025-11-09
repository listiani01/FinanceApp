import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/atm_card.dart';
import '../widgets/grid_menu_item.dart';
import '../models/transaction.dart';
import '../widgets/transaction_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final transactions = [
      TransactionModel('Salary', '+Rp6.000.000', 'Income'),
      TransactionModel('Coffee Shop', '-Rp35.000', 'Food'),
      TransactionModel('Grab Ride', '-Rp25.000', 'Travel'),
      TransactionModel('Dental Care', '-Rp150.000', 'Health'),
    ];

    final displayedTransactions =
        showAll ? transactions : transactions.take(3).toList();

    final cards = [
      AtmCard(
        bankName: 'Bank A',
        cardNumber: '**** 2345',
        balance: 'Rp20.000.000',
        color1: Colors.orangeAccent,
        color2: Colors.deepOrange,
      ),
      AtmCard(
        bankName: 'Bank B',
        cardNumber: '**** 8765',
        balance: 'Rp7.500.000',
        color1: Colors.purple,
        color2: Colors.white,
      ),
      AtmCard(
        bankName: 'Bank C',
        cardNumber: '**** 5678',
        balance: 'Rp10.500.000',
        color1: Colors.blueGrey,
        color2: Colors.black,
      ),
      AtmCard(
        bankName: 'Bank D',
        cardNumber: '**** 5432',
        balance: 'Rp5.350.000',
        color1: Colors.blue,
        color2: Colors.yellow,
      ),
    ];

    final bool isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AppBar(
        title: Text('Finance Mate', style: GoogleFonts.poppins()),
        centerTitle: true,
        backgroundColor: const Color(0xFF310461),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: DefaultTextStyle(
          style: GoogleFonts.poppins(color: Colors.black),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== 1. My Cards =====
              const Text(
                'My Cards',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              if (isDesktop)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: cards,
                )
              else
                SizedBox(
                  height: 220,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: cards
                        .map((c) => Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: c,
                            ))
                        .toList(),
                  ),
                ),

              const SizedBox(height: 24),

              // ===== 2. Balance Summary =====
              _buildBalanceSummary(),
              const SizedBox(height: 24),

              // ===== 3. Goals Tracker =====
              _buildGoalsSection(),
              const SizedBox(height: 24),

              // ===== 4. Grid Menu =====
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  GridMenuItem(icon: Icons.home, label: 'All'),
                  GridMenuItem(icon: Icons.favorite, label: 'Health'),
                  GridMenuItem(icon: Icons.travel_explore, label: 'Travel'),
                  GridMenuItem(icon: Icons.fastfood, label: 'Food'),
                ],
              ),

              const SizedBox(height: 24),

              // ===== 5. Expense Chart =====
              _buildExpenseChart(),
              const SizedBox(height: 24),

              // ===== 6. Recent Transactions =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showAll = !showAll;
                      });
                    },
                    child: Text(
                      showAll ? 'Show Less' : 'Show All',
                      style: const TextStyle(color: Color(0xFF310461)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayedTransactions.length,
                itemBuilder: (context, index) {
                  return TransactionItem(transaction: displayedTransactions[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== BALANCE SUMMARY =====
  Widget _buildBalanceSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0d9cf1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Balance', style: TextStyle(color: Colors.white70)),
              SizedBox(height: 8),
              Text('Rp43.350.000',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Icon(Icons.account_balance_wallet, color: Colors.white, size: 36),
        ],
      ),
    );
  }

  // ===== GOALS SECTION =====
  Widget _buildGoalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Saving Goals',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _goalItem('Vacation to Bali', 0.7),
        _goalItem('Emergency Fund', 0.5),
        _goalItem('New Laptop', 0.3),
      ],
    );
  }

  Widget _goalItem(String title, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            color: const Color(0xFF310461),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // ===== EXPENSE CHART =====
  Widget _buildExpenseChart() {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Expense Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= months.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          months[index],
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: const Color(0xFF310461),
                    barWidth: 3,
                    spots: const [
                      FlSpot(0, 1),
                      FlSpot(1, 2.5),
                      FlSpot(2, 1.8),
                      FlSpot(3, 3),
                      FlSpot(4, 2.2),
                      FlSpot(5, 4),
                    ],
                    belowBarData: BarAreaData(
                      show: true,
                      color: Color(0xFF310461).withOpacity(0.2),
                    ),
                    dotData: const FlDotData(show: false),
                  ),
                ],
                minY: 0,
                maxY: 5,
                minX: 0,
                maxX: (months.length - 1).toDouble(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}