import 'package:budgify/component.dart';
import 'package:flutter/material.dart';
import '../const.dart';
import '../database/database_helper.dart';
import '../server/cache_helper.dart';

class AddTransactionScreen extends StatefulWidget {
  final Map<String, dynamic>? transaction;
  final bool isEdit;

  const AddTransactionScreen({
    super.key,
    this.transaction,
    this.isEdit = false,
  });

  @override
  State<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {

  TextEditingController amountController =
  TextEditingController();

  TextEditingController notesController =
  TextEditingController();

  String type = "expense";

  List<Map<String, dynamic>> categories = [];

  int? selectedCategoryId;

  String currency = "";

  @override
  void initState() {
    super.initState();
    currency =
        CacheHelper.prefs.getString("currency") ?? "USD";
    if (widget.isEdit && widget.transaction != null) {
      amountController.text =
          widget.transaction!["amount"].toString();
      notesController.text =
          widget.transaction!["notes"] ?? "";
      type = widget.transaction!["type"];
      selectedCategoryId = widget.transaction!["category_id"];
    }


    loadCategories();
  }

  // Future<void> loadCategories() async {
  //   categories =
  //   await DatabaseHelper.getCategoriesByType(type);
  //
  //   if (categories.isNotEmpty) {
  //     selectedCategoryId = categories.first["id"];
  //   } else {
  //     selectedCategoryId = null;
  //   }
  //
  //   setState(() {});
  // }
  Future<void> loadCategories() async {
    categories = await DatabaseHelper.getCategoriesByType(type);

    if (widget.isEdit &&
        categories.any((e) => e["id"] == selectedCategoryId)) {

    } else {
      selectedCategoryId =
      categories.isNotEmpty ? categories.first["id"] : null;
    }

    setState(() {});
  }
  @override
  void dispose() {
    amountController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> saveTransaction() async {
    double amount =
        double.tryParse(amountController.text) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter valid amount"),
          backgroundColor: orange,
        ),
      );
      return;
    }
    if (selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select category"),
          backgroundColor: orange,
        ),
      );
      return;
    }
    if (widget.isEdit) {

      await DatabaseHelper.updateTransaction(
        id: widget.transaction!["id"],
        amount: amount,
        type: type,
        categoryId: selectedCategoryId!,
        notes: notesController.text,
        currency: currency,
      );
    } else {
      await DatabaseHelper.insertTransaction(
        amount: amount,
        type: type,
        categoryId: selectedCategoryId!,
        notes: notesController.text,
        currency: currency,
      );
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Transaction" : "Add Transaction",),
        backgroundColor: green,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius:
                BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Transaction Type",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                    children: [
                      ChoiceChip(
                        label:
                        const Text("Income"),
                        selected:
                        type == "income",
                        selectedColor: green,
                        onSelected:
                            (val) async {
                          setState(() {
                            type = "income";
                          });

                          await loadCategories();
                        },
                      ),
                      ChoiceChip(
                        label:
                        const Text("Expense"),
                        selected:
                        type == "expense",
                        selectedColor: orange,
                        onSelected:
                            (val) async {
                          setState(() {
                            type = "expense";
                          });

                          await loadCategories();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  defaultTextFormField(
                      controller: amountController,
                      textInputType: TextInputType.number,
                      labelText: "Amount ($currency)",
                      prefixIcon: Icons.attach_money,
                      validator: (valeu){return null;}),
                  const SizedBox(height: 20),

                  if (categories.isEmpty)
                    const Text(
                        "No categories available")
                  else
                    DropdownButtonFormField<int>(
                      icon: const Icon(Icons.keyboard_arrow_down,),
                      value:
                      selectedCategoryId,
                      items: categories.map((e) {
                          return DropdownMenuItem<int>(
                            value: e["id"],
                            child: Text(
                              e["name"].toString(),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedCategoryId =
                              val;
                        });
                      },
                      decoration:
                      const InputDecoration(
                        labelText:
                        "Category",
                        border:
                        OutlineInputBorder(),
                      ),
                    ),

                  const SizedBox(height: 20),

                  TextField(
                    controller:
                    notesController,
                    maxLines: 5,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {
                      FocusScope.of(context).unfocus();
                    },

                    decoration:
                    const InputDecoration(
                      labelText:
                      "Notes...",
                      alignLabelWithHint:
                      true,
                      border:
                      OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 30),
                  defaultMaterialButton(onPressed: saveTransaction, label: widget.isEdit ?
                  "Update Transaction":"Save Transaction",),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

