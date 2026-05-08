import 'package:budgify/component.dart';
import 'package:flutter/material.dart';
import '../const.dart';
import '../database/database_helper.dart';
<<<<<<< HEAD
import '../server/cache_helper.dart';
=======
>>>>>>> 8019d3427e4c74a8dbbfde77ea2158dfe5dd6f57
import 'add_transaction.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetailsScreen({
    super.key,
    required this.transaction,
  });

<<<<<<< HEAD
  void _showDeleteDialog(BuildContext context) {
    bool isDarkmode = CacheHelper.prefs.getBool("enableDarkMode") ?? false;
=======
  Color getColor(String type) {
    return type == "income" ? green : orange;
  }

  IconData getIcon(String type) {
    return type == "income"
        ? Icons.arrow_upward
        : Icons.arrow_downward;
  }
  void _showDeleteDialog(BuildContext context) {
>>>>>>> 8019d3427e4c74a8dbbfde77ea2158dfe5dd6f57
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Transaction?"),
        content: const Text("Are you sure you want to delete this transaction?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
<<<<<<< HEAD
            child: Text("Cancel",style: TextStyle(color: isDarkmode ? gray3 : gray4),),
=======
            child: const Text("Cancel"),
>>>>>>> 8019d3427e4c74a8dbbfde77ea2158dfe5dd6f57
          ),
          TextButton(
            onPressed: () async {
              await DatabaseHelper.deleteTransaction(transaction["id"]);
<<<<<<< HEAD
              Navigator.pop(ctx);
              Navigator.pop(context, true);
            },
            child: const Text("Delete", style: TextStyle(color:orange)),
=======
              Navigator.pop(ctx); // close dialog
              Navigator.pop(context, true); // back + refresh
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
>>>>>>> 8019d3427e4c74a8dbbfde77ea2158dfe5dd6f57
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
<<<<<<< HEAD
=======
        backgroundColor: green,
>>>>>>> 8019d3427e4c74a8dbbfde77ea2158dfe5dd6f57
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
<<<<<<< HEAD
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
=======
            color: white,
            borderRadius: BorderRadius.circular(20),
>>>>>>> 8019d3427e4c74a8dbbfde77ea2158dfe5dd6f57
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
<<<<<<< HEAD
=======

              // ICON
>>>>>>> 8019d3427e4c74a8dbbfde77ea2158dfe5dd6f57
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
<<<<<<< HEAD
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
=======
                  color: getColor(transaction["type"])
                      .withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  getIcon(transaction["type"]),
                  size: 40,
                  color: getColor(transaction["type"]),
>>>>>>> 8019d3427e4c74a8dbbfde77ea2158dfe5dd6f57
                ),
              ),

              const SizedBox(height: 20),

<<<<<<< HEAD
=======
              // AMOUNT
>>>>>>> 8019d3427e4c74a8dbbfde77ea2158dfe5dd6f57
              Text(
                "${transaction["amount"]} ${transaction["currency"]}",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

<<<<<<< HEAD
=======
              // CATEGORY
>>>>>>> 8019d3427e4c74a8dbbfde77ea2158dfe5dd6f57
              Text(
                "Category: ${transaction["category_name"]}",
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 10),

<<<<<<< HEAD
=======
              // DATE
>>>>>>> 8019d3427e4c74a8dbbfde77ea2158dfe5dd6f57
              Text(
                "Date: ${transaction["date"].toString().substring(0, 16)}",
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

<<<<<<< HEAD
=======
              // NOTES
>>>>>>> 8019d3427e4c74a8dbbfde77ea2158dfe5dd6f57
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
<<<<<<< HEAD
              }, label: "Edit Transaction",),
=======
              }, label: "Edit Transaction",fontSize: 18),
>>>>>>> 8019d3427e4c74a8dbbfde77ea2158dfe5dd6f57

            ],
          ),
        ),
      ),
    );
  }
}