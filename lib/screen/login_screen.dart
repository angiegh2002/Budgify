import 'package:budgify/component.dart';
import 'package:budgify/screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../const.dart';
import '../layout/home_layout.dart';
import '../server/cache_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
final _formKey = GlobalKey<FormState>();
bool isPasswordHidden = true;
final TextEditingController emailController=TextEditingController();
final TextEditingController passwordController = TextEditingController();
@override
void dispose() {
  emailController.dispose();
  passwordController.dispose();
  super.dispose();
}
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundImage:
                  const AssetImage("assets/images/budgify.png"),
                  radius: 60,
                ),

                const SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text("LOG IN",
                          style: TextStyle(
                              color: green,fontSize:title,fontWeight: FontWeight.bold ),
                        ),
                        const SizedBox(height: 30),
                        defaultTextFormField(
                            controller: emailController,
                            textInputType: TextInputType.emailAddress,
                            labelText: "Email / Username",
                            prefixIcon: Icons.email_outlined,
                            validator: (value){
                              if (value==null || value.isEmpty){
                                return "Email/username is required";
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

                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        defaultMaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {

                              String? savedEmail = CacheHelper.prefs.getString("email");
                              String? savedUserName=CacheHelper.prefs.getString("userName");
                              String? savedPassword=CacheHelper.prefs.getString("password");
                              if ((emailController.text== savedEmail ||
                                  emailController.text ==savedUserName) &&
                                  passwordController.text == savedPassword){
                                await CacheHelper.prefs.setBool("isLogin", true);
                                Fluttertoast.showToast(
                                    msg: "Logged in successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 2,
                                    backgroundColor: green,
                                    textColor: white,
                                    fontSize: 16.0
                                );
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeLayout()),
                                      (route) => false,
                                );
                              }else{
                                Fluttertoast.showToast(
                                    msg: "Email or password is wrong",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 2,
                                    backgroundColor: orange,
                                    textColor: white,
                                    fontSize: 16.0
                                );
                              }


                            } else {
                              print("error");
                              Fluttertoast.showToast(
                                  msg: "Email or password is wrong",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: orange,
                                  textColor: white,
                                  fontSize: 16.0
                              );
                            }
                          },
                          label: "log in",),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "don\'t have an account",
                              style: TextStyle(
                                fontSize:16,
                              ),
                            ),
                            const SizedBox(width: 5),
                            defaultTextButton(onPressed: (){
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) => const RegisterScreen(),
                                ),
                              );
                            }, label: "Sign up"),
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