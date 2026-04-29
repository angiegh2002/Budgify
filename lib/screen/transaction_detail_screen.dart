import 'package:budgify/component.dart';
import 'package:flutter/material.dart';
import '../const.dart';
import '../database/database_helper.dart';
import 'add_transaction.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetailsScreen({
    super.key,
    required this.transaction,
  });

  Color getColor(String type) {
    return type == "income" ? green : orange;
  }

  IconData getIcon(String type) {
    return type == "income"
        ? Icons.arrow_upward
        : Icons.arrow_downward;
  }
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Transaction?"),
        content: const Text("Are you sure you want to delete this transaction?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseHelper.deleteTransaction(transaction["id"]);
              Navigator.pop(ctx); // close dialog
              Navigator.pop(context, true); // back + refresh
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
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
        backgroundColor: green,
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
            color: white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // ICON
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: getColor(transaction["type"])
                      .withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  getIcon(transaction["type"]),
                  size: 40,
                  color: getColor(transaction["type"]),
                ),
              ),

              const SizedBox(height: 20),

              // AMOUNT
              Text(
                "${transaction["amount"]} ${transaction["currency"]}",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // CATEGORY
              Text(
                "Category: ${transaction["category_name"]}",
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 10),

              // DATE
              Text(
                "Date: ${transaction["date"].toString().substring(0, 16)}",
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              // NOTES
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
              }, label: "Edit Transaction",fontSize: 18),

            ],
          ),
        ),
      ),
    );
  }
}