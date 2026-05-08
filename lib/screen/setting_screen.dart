import 'package:budgify/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart' show showIconPicker;
import '../const.dart';
import '../main.dart';
import '../server/cache_helper.dart';
import '../database/database_helper.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool enableDarkMode = false;
  String selectedCurrency = "USD";
  List<Map<String, dynamic>> categories = [];


  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    enableDarkMode = CacheHelper.prefs.getBool("enableDarkMode") ?? false;
    selectedCurrency = CacheHelper.prefs.getString("currency") ?? "USD";
    categories = await DatabaseHelper.getCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context,true),
        ),
        title: const Text(
          "Settings",
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWhiteContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Currency",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCurrency,
                      decoration:
                      const InputDecoration(
                        labelText:
                        "Category",
                        border:
                        OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "USD",
                          child: Text(
                            "united states dollar (usd)",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "EUR",
                          child: Text(
                            "euro (eur)",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "SYP",
                          child: Text(
                            "syrian pound (syp)",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedCurrency = value);
                          CacheHelper.prefs.setString("currency", value);
                        }
                      },
                      icon: const Icon(Icons.keyboard_arrow_down,),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              _buildWhiteContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Enable dark mode",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Switch(
                      value: enableDarkMode,
                      onChanged: (v) {
                        setState(() => enableDarkMode = v);
                        CacheHelper.prefs.setBool("enableDarkMode", v);

                        toggleTheme(v);
                      },
                      activeColor: green,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              _buildWhiteContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "manage categories",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildCategorySection(
                      title: "Expense categories",
                      type: "expense",
                    ),
                    const SizedBox(height: 12),

                    _buildCategorySection(
                      title: "Income categories",
                      type: "income",
                    ),
                  const SizedBox(height: 20),
                    defaultMaterialButton(onPressed: () => openCategorySheet(), label: "add new categories"),
                  ],
                ),
              ),
        
              const SizedBox(height: 20),

              //
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton.icon(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: green,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //       padding: const EdgeInsets.symmetric(vertical: 14),
              //       elevation: 0,
              //     ),
              //     onPressed: () => openCategorySheet(),
              //     icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              //     label: const Text(
              //       "add new categories",
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 16,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWhiteContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildCategorySection({
    required String title,
    required String type,
  }) {
    final filtered = categories.where((c) => c["type"] == type).toList();

    return Container(
      decoration: BoxDecoration(
        color: gray3,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (filtered.isNotEmpty)
            ...filtered.map((c) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: white,
                  border: Border(
                    top: BorderSide(
                      color: gray3,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(c["color"] ?? 0xFF2196F3),
                      child: Icon(
                        IconData(
                          c["icon"] ?? Icons.category.codePoint,
                          fontFamily: "MaterialIcons",
                        ),
                        color: white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        c["name"] ?? "",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          onPressed: () => openCategorySheet(edit: c),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded,color: orange, size: 18),
                          onPressed: () async {
                            try {
                              await DatabaseHelper.deleteCategory(c["id"]);
                              loadData();
                            } catch (_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(backgroundColor: orange,
                                  content: Text("Category in use"),
                                ),
                              );
                            }
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList()
          else
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "No categories",
                style: TextStyle(color: Colors.black54),
              ),
            ),
        ],
      ),
    );
  }

  void openCategorySheet({Map? edit}) {
    TextEditingController nameController =
    TextEditingController(text: edit?["name"]);

    String type = edit?["type"] ?? "expense";
    Color selectedColor = edit != null
        ? Color(edit["color"] ?? 0xFF2196F3)
        : green;

    IconData selectedIcon = edit != null
        ? IconData(
      edit["icon"] ?? Icons.category.codePoint,
      fontFamily: "MaterialIcons",
    )
        : Icons.category;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: gray3,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  defaultTextFormField(
                      controller: nameController,
                      textInputType: TextInputType.name,
                      labelText: "Category Name",
                      prefixIcon: Icons.category,
                      validator: (val){return null;}),

                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    icon: const Icon(Icons.keyboard_arrow_down,),
                    value: type,
                    items: [
                      DropdownMenuItem(
                          value: "income", child: Text("Income")),
                      DropdownMenuItem(
                          value: "expense", child: Text("Expense")),
                    ],isExpanded: true,
                    onChanged:  (value) {
                              setModal(() {
                                type = value!;
                              });
                            },
                    decoration:
                    const InputDecoration(
                      labelText:
                      "Type",
                      border:
                      OutlineInputBorder(),
                    ),
                  ),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 12),
                  //   decoration: BoxDecoration(
                  //     color: gray3,
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  //   child: DropdownButtonHideUnderline(
                  //     child: DropdownButton<String>(
                  //       value: type,
                  //       isExpanded: true,
                  //       items: const [
                  //         DropdownMenuItem(
                  //             value: "income", child: Text("Income")),
                  //         DropdownMenuItem(
                  //             value: "expense", child: Text("Expense")),
                  //       ],
                  //       onChanged: (value) {
                  //         setModal(() {
                  //           type = value!;
                  //         });
                  //       },
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Color",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      GestureDetector(
                        onTap: () {
                          Color tempColor = selectedColor;
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: const Text("Pick Color"),
                                content: SingleChildScrollView(
                                  child: BlockPicker(
                                    pickerColor: tempColor,
                                    onColorChanged: (color) {
                                      tempColor = color;
                                    },
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setModal(() {
                                        selectedColor = tempColor;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Done"),
                                  )
                                ],
                              );
                            },
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: selectedColor,
                          child:
                          const Icon(Icons.brush, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Icon",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      GestureDetector(
                        onTap: () async {
                          IconPickerIcon? icon = await showIconPicker(
                            context,
                            configuration: SinglePickerConfiguration(
                              iconPackModes: [
                                IconPack.material,
                                IconPack.cupertino,
                                // IconPack.fontAwesome,
                                // IconPack.fontAwesome,
                              ],
                              showSearchBar: true,
                              searchHintText: "Search icon...",
                              showTooltips: true,
                              iconSize: 30,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                            ),
                          );

                          if (icon != null) {
                            setModal(() {
                              selectedIcon = IconData(
                                icon.data.codePoint,
                                fontFamily: icon.data.fontFamily,
                              );
                            });
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: orange,
                          child: Icon(
                            selectedIcon,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  defaultMaterialButton(onPressed: () async {
                    if (edit == null) {
                      await DatabaseHelper.insertCategory(
                        nameController.text,
                        type,
                        selectedColor.value,
                        selectedIcon.codePoint,
                      );
                    } else {
                      await DatabaseHelper.updateCategory(
                        edit["id"],
                        nameController.text,
                        selectedColor.value,
                        selectedIcon.codePoint,
                      );
                    }
                    Navigator.pop(context);
                    loadData();
                  }, label: edit == null ? "Add" : "Update",),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}