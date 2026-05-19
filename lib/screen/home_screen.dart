import 'package:budgify/component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../const.dart';
import '../database/database_helper.dart';
import '../provider/currency_provider.dart';
import '../services/cache_helper.dart';
import '../services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double balance = 0;
  double income = 0;
  double expenses = 0;
  double monthlyBudget = 0;
  double percentage = 0;

  String BASE_CURRENCY = 'USD';

  bool isDarkmode =
      CacheHelper.prefs.getBool("enableDarkMode") ?? false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      income = await DatabaseHelper.getIncome();
      expenses = await DatabaseHelper.getExpenses();
      balance = await DatabaseHelper.getBalance();

      monthlyBudget =
          CacheHelper.prefs.getDouble("monthlyBudget") ?? 0;

      bool budgetAlertEnabled =
          CacheHelper.prefs.getBool("budgetAlert") ?? false;

      if (monthlyBudget > 0) {
        percentage = expenses / monthlyBudget;

        if (percentage > 1) {
          percentage = 1;
        }

        if (percentage >= 0.8 && budgetAlertEnabled) {
          await NotificationService.budgetAlert(
            percentage,
            true,
          );
        }
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print("Error in loadData: $e");

      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyProvider =
    context.watch<CurrencyProvider>();

    final convertedBalance = currencyProvider.convert(
      balance,
      BASE_CURRENCY,
      currencyProvider.selectedCurrency,
    );

    final convertedIncome = currencyProvider.convert(
      income,
      BASE_CURRENCY,
      currencyProvider.selectedCurrency,
    );

    final convertedExpenses = currencyProvider.convert(
      expenses,
      BASE_CURRENCY,
      currencyProvider.selectedCurrency,
    );

    final convertedBudget = currencyProvider.convert(
      monthlyBudget,
      BASE_CURRENCY,
      currencyProvider.selectedCurrency,
    );

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  /// Balance Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius:
                      BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Available Balance",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                "${convertedBalance.toStringAsFixed(2)} "
                                    "${currencyProvider.selectedCurrency}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10),

                        const CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(
                            "assets/images/budgify.png",
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Income & Expenses
                  Row(
                    children: [
                      Expanded(
                        child: buildSmallCard(
                          title: "Expenses",
                          amount:
                          "${convertedExpenses.toStringAsFixed(2)} "
                              "${currencyProvider.selectedCurrency}",
                          icon: Icons.arrow_downward,
                          iconColor: orange,
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: buildSmallCard(
                          title: "Income",
                          amount:
                          "${convertedIncome.toStringAsFixed(2)} "
                              "${currencyProvider.selectedCurrency}",
                          icon: Icons.arrow_upward,
                          iconColor: green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Monthly Budget Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius:
                      BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                          children: [
                            const Text(
                              "Monthly Budget",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                FontWeight.w500,
                              ),
                            ),

                            IconButton(
                              icon: const Icon(
                                Icons
                                    .mode_edit_outline_outlined,
                                color: green,
                                size: 30,
                              ),
                              onPressed: () {
                                TextEditingController
                                budgetEditController =
                                TextEditingController();

                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor:
                                      Theme.of(context)
                                          .cardColor,

                                      title: const Text(
                                        "Edit Monthly Budget",
                                      ),

                                      content:
                                      defaultTextFormField(
                                        controller:
                                        budgetEditController,
                                        textInputType:
                                        TextInputType
                                            .number,
                                        labelText:
                                        "Enter budget amount",
                                        prefixIcon: Icons
                                            .mode_edit_outline_outlined,
                                        validator:
                                            (value) {
                                          return null;
                                        },
                                      ),

                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context);
                                          },
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                              color:
                                              isDarkmode
                                                  ? gray3
                                                  : gray4,
                                            ),
                                          ),
                                        ),

                                        TextButton(
                                          onPressed:
                                              () async {
                                            double
                                            enteredBudget =
                                                double.tryParse(
                                                  budgetEditController
                                                      .text,
                                                ) ??
                                                    0;

                                            final currencyProvider =
                                            context.read<
                                                CurrencyProvider>();

                                            double
                                            budgetInBaseCurrency =
                                            currencyProvider
                                                .convert(
                                              enteredBudget,
                                              currencyProvider
                                                  .selectedCurrency,
                                              BASE_CURRENCY,
                                            );

                                            await CacheHelper
                                                .prefs
                                                .setDouble(
                                              "monthlyBudget",
                                              budgetInBaseCurrency,
                                            );

                                            await loadData();

                                            Navigator.pop(
                                                context);

                                            ScaffoldMessenger.of(
                                                context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Budget saved: "
                                                      "${enteredBudget.toStringAsFixed(2)} "
                                                      "${currencyProvider.selectedCurrency}",
                                                ),
                                                backgroundColor:
                                                gray2,
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            "Save",
                                            style: TextStyle(
                                              color: green,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "${convertedBudget.toStringAsFixed(2)} "
                              "${currencyProvider.selectedCurrency}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        ClipRRect(
                          borderRadius:
                          BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: percentage,
                            minHeight: 18,
                            backgroundColor:
                            Colors.grey.shade300,
                            valueColor:
                            AlwaysStoppedAnimation(
                              green,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "${percentage.toStringAsFixed(2)}% "
                              "of your budget has been used",
                          style: const TextStyle(
                            fontSize: 14,
                            color: gray2,
                          ),
                        ),
                      ],
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

  Widget buildSmallCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            amount,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}