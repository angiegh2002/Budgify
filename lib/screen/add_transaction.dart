import 'package:flutter/material.dart';
import '../const.dart';
import '../database/database_helper.dart';
import '../server/cache_helper.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState
    extends State<AddTransactionScreen> {

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

    // جلب العملة المحفوظة محليًا
    currency =
        CacheHelper.prefs.getString("currency") ?? "USD";

    loadCategories();
  }

  Future<void> loadCategories() async {
    categories =
    await DatabaseHelper.getCategoriesByType(type);

    if (categories.isNotEmpty) {
      selectedCategoryId = categories.first["id"];
    } else {
      selectedCategoryId = null;
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

    // تحقق من المبلغ
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter valid amount"),
        ),
      );
      return;
    }

    // تحقق من وجود تصنيف
    if (selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select category"),
        ),
      );
      return;
    }

    await DatabaseHelper.insertTransaction(
      amount: amount,
      type: type,
      categoryId: selectedCategoryId!,
      notes: notesController.text,
      currency: currency,
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction"),
        backgroundColor: green,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: white,
                borderRadius:
                BorderRadius.circular(20),
              ),
              child: Column(
                children: [

                  // Amount
                  TextField(
                    controller: amountController,
                    keyboardType:
                    TextInputType.number,
                    decoration: InputDecoration(
                      labelText:
                      "Amount ($currency)",
                      border:
                      const OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Type
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceEvenly,
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

                  // Categories
                  if (categories.isEmpty)
                    const Text(
                        "No categories available")
                  else
                    DropdownButtonFormField<int>(
                      value:
                      selectedCategoryId,
                      items: categories.map(
                            (e) {
                          return DropdownMenuItem<
                              int>(
                            value: e["id"],
                            child: Text(
                              e["name"]
                                  .toString(),
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

                  // Notes
                  TextField(
                    controller:
                    notesController,
                    maxLines: 5,
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

                  // Save Button
                  SizedBox(
                    width:
                    double.infinity,
                    child:
                    ElevatedButton(
                      style:
                      ElevatedButton
                          .styleFrom(
                        backgroundColor:
                        green,
                        padding:
                        const EdgeInsets
                            .all(15),
                      ),
                      onPressed:
                      saveTransaction,
                      child:
                      const Text(
                        "Save Transaction",
                        style: TextStyle(
                          color:
                          Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}