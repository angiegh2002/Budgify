import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../component.dart';
import '../const.dart';
import '../layout/home_layout.dart';
import '../services/cache_helper.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isPasswordHidden = true;
  bool isDarkmode = CacheHelper.prefs.getBool("enableDarkMode") ?? false;
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
    passwordController.dispose();
    rePasswordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  isDarkmode ? grayDarkM : gray1,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_outlined,color: isDarkmode ? white : gray4,)),

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
                          Text("SING UP",
                            style: TextStyle(
                                color: green,fontSize:title,fontWeight: FontWeight.bold ),
                          ),
                          const SizedBox(height: 30),defaultTextFormField(
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
                          defaultTextFormField(
                            controller: passwordController,
                            textInputType: TextInputType.visiblePassword,
                            labelText: "Password",
                            prefixIcon: Icons.lock_outline,
                            isPasswordHidden: isPasswordHidden,
                            suffixIcon: isPasswordHidden?  Icons.visibility_off_outlined : Icons.visibility_outlined,
                            togglePassword: (){
                              setState(() {
                                isPasswordHidden= !isPasswordHidden;
                              });
                            },

                            validator:  (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is required";
                              }
                              if (value.length < 8) {
                                return "Password must be at least 8 characters";
                              }
                              return null;
                            },
                          ),const SizedBox(height: 30),
                          defaultTextFormField(
                            controller: rePasswordController,
                            textInputType: TextInputType.visiblePassword,
                            labelText: "Re_Password",
                            prefixIcon: Icons.lock_outline,
                            isPasswordHidden: isPasswordHidden,
                            suffixIcon: isPasswordHidden?  Icons.visibility_off_outlined : Icons.visibility_outlined,
                            togglePassword: (){
                              setState(() {
                                isPasswordHidden= !isPasswordHidden;
                              });
                            },

                            validator:  (value) {

                              if (value == null || value.isEmpty) {
                                return "Re-Password is required";
                              }
                              if (value != passwordController.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          defaultMaterialButton(
                            onPressed: () async{
                              if (_formKey.currentState!.validate()) {
                                await CacheHelper.prefs.setString("name", nameController.text);
                                await CacheHelper.prefs.setString("userName", userNameController.text);
                                await CacheHelper.prefs.setString("email", emailController.text);
                                await CacheHelper.prefs.setString("password", passwordController.text);
                                Fluttertoast.showToast(
                                    msg: "Account create successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 2,
                                    backgroundColor: green,
                                    textColor: white,
                                    fontSize: 16.0
                                );
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (BuildContext context)=> LoginScreen()));
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Failed to create account",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: orange,
                                  textColor: white,
                                  fontSize: 16,
                                );
                                print("error");
                              }
                            },
                            label: "Sing up",),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "you have an account",
                                style: TextStyle(
                                  fontSize:16,
                                ),
                              ),
                              const SizedBox(width: 5),
                              defaultTextButton(onPressed: (){
                                Navigator.pop(context);
                              }, label: "Log in"),
                            ],),
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
