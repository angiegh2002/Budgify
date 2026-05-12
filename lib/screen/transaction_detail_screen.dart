import 'package:budgify/component.dart';
import 'package:flutter/material.dart';
import '../const.dart';
import '../database/database_helper.dart';
import '../services/cache_helper.dart';
import 'add_transaction.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetailsScreen({
    super.key,
    required this.transaction,
  });

  void _showDeleteDialog(BuildContext context) {
    bool isDarkmode = CacheHelper.prefs.getBool("enableDarkMode") ?? false;

  Color getColor(String type) {
    return type == "income" ? green : orange;
  }

  IconData getIcon(String type) {
    return type == "income"
        ? Icons.arrow_upward
        : Icons.arrow_downward;
  }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Transaction?"),
        content: const Text("Are you sure you want to delete this transaction?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),

            child: Text("Cancel",style: TextStyle(color: isDarkmode ? gray3 : gray4),),

          ),
          TextButton(
            onPressed: () async {
              await DatabaseHelper.deleteTransaction(transaction["id"]);
              Navigator.pop(ctx);
              Navigator.pop(context, true);
            },
            child: const Text("Delete", style: TextStyle(color:orange)),

          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_outlined, color:orange,
              size: 28,),
            onPressed: () {
              _showDeleteDialog(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(

            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(transaction["category_color"]).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  IconData(
                    transaction["category_icon"],
                    fontFamily: 'MaterialIcons',
                  ),
                  size: 40,
                  color: Color(transaction["category_color"]),

                ),
              ),

              const SizedBox(height: 20),

              Text(
                "${transaction["amount"]} ${transaction["currency"]}",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Category: ${transaction["category_name"]}",
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 10),

              Text(
                "Date: ${transaction["date"].toString().substring(0, 16)}",
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Notes:",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 5),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  transaction["notes"]?.isNotEmpty == true
                      ? transaction["notes"]
                      : "No notes",
                ),
              ),
              const SizedBox(height: 20),
              defaultMaterialButton(onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddTransactionScreen(
                      transaction: transaction,
                      isEdit: true,
                    ),
                  ),
                );

                if (result == true) {
                  Navigator.pop(context, true);
                }

              }, label: "Edit Transaction",),

            ],
          ),
        ),
      ),
    );
  }
}