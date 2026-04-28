import 'package:flutter/material.dart';
import '../const.dart';
import '../database/database_helper.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() =>
      _TransactionsScreenState();
}

class _TransactionsScreenState
    extends State<TransactionsScreen> {

  List<Map<String, dynamic>> transactions = [];
  String selectedFilter = "today";

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    List<Map<String, dynamic>> allTransactions =
    await DatabaseHelper.getTransactions();

    DateTime now = DateTime.now();

    List<Map<String, dynamic>> filtered =
    allTransactions.where((transaction) {
      DateTime transactionDate =
      DateTime.parse(transaction["date"]);

      if (selectedFilter == "today") {
        return transactionDate.year == now.year &&
            transactionDate.month == now.month &&
            transactionDate.day == now.day;
      }

      if (selectedFilter == "week") {
        DateTime weekAgo =
        now.subtract(const Duration(days: 7));
        return transactionDate.isAfter(weekAgo);
      }

      if (selectedFilter == "month") {
        return transactionDate.year == now.year &&
            transactionDate.month == now.month;
      }

      return true;
    }).toList();

    setState(() {
      transactions = filtered;
    });
  }

  Color getColor(String type) {
    return type == "income" ? green : orange;
  }

  IconData getIcon(String type) {
    return type == "income"
        ? Icons.arrow_upward
        : Icons.arrow_downward;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
            onRefresh: () async {
              await loadTransactions();
            },
        child: Column(
          children: [

            const SizedBox(height: 20),

            // 🔥 Segmented Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: gray3,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    buildSegment("Today", "today"),
                    buildSegment("Week", "week"),
                    buildSegment("Month", "month"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: transactions.isEmpty
                  ? const Center(
                child: Text("No transactions found"),
              )
                  : ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  var item = transactions[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: getColor(item["type"]).withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          getIcon(item["type"]),
                          color: getColor(item["type"]),
                        ),
                      ),

                      // 🔥 اسم الفئة بدل notes
                      title: Text(
                        item["category_name"] ??
                            "Unknown Category",
                      ),

                      subtitle: Text(
                        item["date"]
                            .toString()
                            .substring(0, 10),
                      ),

                      trailing: Text(
                        "${item["amount"]} ${item["currency"]}",
                        style: TextStyle(
                          color:
                          getColor(item["type"]),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),),
      ),
    );
  }

  Widget buildSegment(String title, String value) {
    bool isSelected = selectedFilter == value;

    return Expanded(
      child: GestureDetector(
        onTap: () async {
          setState(() {
            selectedFilter = value;
          });
          await loadTransactions();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? green : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}