import 'package:budgify/screen/transaction_detail_screen.dart';
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

  Map<String, List<Map<String, dynamic>>> grouped = {};

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    List<Map<String, dynamic>> all =
    await DatabaseHelper.getTransactions();

    DateTime now = DateTime.now();

    List<Map<String, dynamic>> filtered =
    all.where((t) {
      DateTime d = DateTime.parse(t["date"]);

      if (selectedFilter == "today") {
        return d.year == now.year &&
            d.month == now.month &&
            d.day == now.day;
      }

      if (selectedFilter == "week") {
        return d.isAfter(
            now.subtract(const Duration(days: 7)));
      }

      if (selectedFilter == "month") {
        return d.year == now.year &&
            d.month == now.month;
      }

      if (selectedFilter == "year") {
        return d.year == now.year;
      }

      return true;
    }).toList();

    if (selectedFilter == "year") {
      groupByMonth(filtered);
    } else {
      transactions = filtered;
    }

    setState(() {});
  }

  void groupByMonth(List<Map<String, dynamic>> data) {
    Map<String, List<Map<String, dynamic>>> temp = {};

    for (var t in data) {
      DateTime d = DateTime.parse(t["date"]);

      String key =
          "${d.year}-${d.month.toString().padLeft(2, '0')}";

      temp.putIfAbsent(key, () => []);
      temp[key]!.add(t);
    }

    var sortedKeys = temp.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    grouped = {
      for (var k in sortedKeys) k: temp[k]!
    };
  }

  IconData categoryIcon(int? codePoint) {
    return IconData(
      codePoint ?? Icons.category.codePoint,
      fontFamily: 'MaterialIcons',
    );
  }

  Color categoryColor(int? colorValue) {
    return Color(colorValue ?? 0xFF9E9E9E);
  }
  Color amountColor(String type) {
    return type == "income" ? green : orange;
  }
  String monthName(int m) {
    const months = [
      "Jan", "Feb", "Mar", "Apr",
      "May", "Jun", "Jul", "Aug",
      "Sep", "Oct", "Nov", "Dec"
    ];
    return months[m - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadTransactions,
          child: Column(
            children: [

              const SizedBox(height: 20),

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
                      buildSegment("Year", "year"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: selectedFilter == "year"
                    ? buildGroupedList()
                    : buildNormalList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNormalList() {
    return transactions.isEmpty
        ? const Center(child: Text("No transactions"))
        : ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        var item = transactions[index];

        return Card(
          margin: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 8),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TransactionDetailsScreen(
                    transaction: item,
                  ),
                ),
              );
            },

            leading: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: categoryColor(item["category_color"])
                    .withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                categoryIcon(item["category_icon"]),
                color: categoryColor(item["category_color"]),
              ),
            ),

            title: Text(
              item["category_name"] ?? "Category",
            ),

            subtitle: Text(
              item["date"].toString().substring(0, 10),
            ),

            trailing: Text(
              "${item["amount"]} ${item["currency"]}",
              style: TextStyle(
                color: amountColor(item["type"]),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildGroupedList() {
    return grouped.isEmpty
        ? const Center(child: Text("No transactions"))
        : ListView(
      children: grouped.keys.map((key) {
        List items = grouped[key]!;

        DateTime d =
        DateTime.parse(items.first["date"]);

        double total = items.fold(0, (sum, e) {
          if (e["type"] == "income") {
            return sum + (e["amount"] ?? 0);
          } else {
            return sum - (e["amount"] ?? 0);
          }
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.fromLTRB(
                  16, 20, 16, 10),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${monthName(d.month)} ${d.year}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Total: $total",
                    style: TextStyle(
                      color: green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            ...items.map((item) {
              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 6),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TransactionDetailsScreen(
                          transaction: item,
                        ),
                      ),
                    );
                  },

                  leading: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: categoryColor(item["category_color"])
                          .withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      categoryIcon(item["category_icon"]),
                      color: categoryColor(item["category_color"]),
                    ),
                  ),

                  title: Text(
                    item["category_name"] ?? "Category",
                  ),

                  subtitle: Text(
                    item["date"].toString().substring(0, 10),
                  ),

                  trailing: Text(
                    "${item["amount"]} ${item["currency"]}",
                    style: TextStyle(
                      color: amountColor(item["type"]),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        );
      }).toList(),
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
                color: isSelected ? white : black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}