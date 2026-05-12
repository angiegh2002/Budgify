import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../component.dart';
import '../const.dart';
import '../services/cache_helper.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isPasswordHidden = true;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  @override
  void dispose() {
    nameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    nameController.text = CacheHelper.prefs.getString("name") ?? "";
    userNameController.text = CacheHelper.prefs.getString("userName") ?? "";
    emailController.text = CacheHelper.prefs.getString("email") ?? "";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: green,
        title: Text("Profile"),
        leading: IconButton(onPressed: (){Navigator.pop(context, true);}, icon: Icon(Icons.arrow_back_outlined,)),

      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          defaultTextFormField(
                              controller: nameController,
                              textInputType: TextInputType.name,
                              labelText: "Name",
                              prefixIcon: Icons.person_outlined,
                              validator: (value){
                                if (value==null || value.isEmpty){
                                  return "Name is required";
                                }
                                return null;
                              }),
                          const SizedBox(height: 30),defaultTextFormField(
                              controller: userNameController,
                              textInputType: TextInputType.name,
                              labelText: "User name",
                              prefixIcon: Icons.person,
                              validator: (value){
                                if (value==null || value.isEmpty){
                                  return "User name is required";
                                }
                                return null;
                              }),
                          const SizedBox(height: 30),
                          defaultTextFormField(
                              controller: emailController,
                              textInputType: TextInputType.emailAddress,
                              labelText: "Email",
                              prefixIcon: Icons.email_outlined,
                              validator: (value){
                                if (value==null || value.isEmpty){
                                  return "Email is required";
                                }
                                RegExp emailRegex =
                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                                if (!emailRegex.hasMatch(value)) {
                                  return "Please enter a valid email";
                                }
                                return null;
                              }),
                          const SizedBox(height: 30),
                          defaultMaterialButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {

                                await CacheHelper.prefs.setString("name", nameController.text);
                                await CacheHelper.prefs.setString("userName", userNameController.text);
                                await CacheHelper.prefs.setString("email", emailController.text);
                                Fluttertoast.showToast(
                                  msg: "Profile updated successfully",
                                  backgroundColor: green,
                                  textColor: white,
                                );
                              }
                            },
                            label: "Save change",),

                          const SizedBox(height: 30),


                        ],
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