import 'dart:async';
import 'dart:convert';

import 'package:barter_it/views/screens/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:barter_it/myconfig.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailditingController = TextEditingController();
  final TextEditingController _phonelditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();
  bool _isChecked = false;
  bool _isObscure = true;
  bool _isObscure1 = true;
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;

  @override
  void initState() {
    super.initState();
    _isObscure = true;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Registration"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/loginbackground.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                height: screenHeight * 0.30,
                width: screenWidth * 0.95,
                child: Image.asset(
                  "assets/images/Registerpage.png",
                  fit: BoxFit.cover,
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 8,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(children: [
                    Form(
                      key: _formKey,
                      child: Column(children: [
                        TextFormField(
                            controller: _nameEditingController,
                            validator: (val) => val!.isEmpty || (val.length < 5)
                                ? "name must be longer than 5"
                                : null,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Username',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.person),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        TextFormField(
                            keyboardType: TextInputType.phone,
                            validator: (val) =>
                                val!.isEmpty || (val.length < 10)
                                    ? "phone must be longer or equal than 10"
                                    : null,
                            controller: _phonelditingController,
                            decoration: const InputDecoration(
                                labelText: 'Phone',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.phone),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        TextFormField(
                            controller: _emailditingController,
                            validator: (val) => val!.isEmpty ||
                                    !val.contains("@") ||
                                    !val.contains(".")
                                ? "enter a valid email"
                                : null,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.email),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        TextFormField(
                            controller: _passEditingController,
                            validator: (val) => val!.isEmpty || (val.length < 5)
                                ? "password must be longer than 5"
                                : null,
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(_isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(
                                      () {
                                        _isObscure = !_isObscure;
                                      },
                                    );
                                  },
                                ),
                                alignLabelWithHint: false,
                                filled: false,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        TextFormField(
                            controller: _pass2EditingController,
                            validator: (val) => val!.isEmpty || (val.length < 5)
                                ? "password must be longer than 5"
                                : null,
                            obscureText: _isObscure1,
                            decoration: InputDecoration(
                                labelText: 'Re-enter password',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(_isObscure1
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(
                                      () {
                                        _isObscure1 = !_isObscure1;
                                      },
                                    );
                                  },
                                ),
                                alignLabelWithHint: false,
                                filled: false,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isChecked,
                              onChanged: (bool? value) {
                                if (!_isChecked) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Terms have been read and accepted.")));
                                }
                                setState(() {
                                  _isChecked = value!;
                                });
                              },
                            ),
                            GestureDetector(
                              onTap: null,
                              child: const Text('Agree with terms',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                                child: ElevatedButton(
                                    onPressed: onRegisterDialog,
                                    child: const Text("Register")))
                          ],
                        )
                      ]),
                    )
                  ]),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: _goLogin,
              child: const Text(
                "Already Registered? Login",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ]),
        ),
      ),
    );
  }

  void onRegisterDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please agree with terms and conditions")));
      return;
    }
    String passa = _passEditingController.text;
    String passb = _pass2EditingController.text;
    if (passa != passb) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your password")));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Register new account?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                registerUser();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void registerUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Please Wait"),
          content: Text("Registration..."),
        );
      },
    );
    String name = _nameEditingController.text;
    String email = _emailditingController.text;
    String phone = _phonelditingController.text;
    String passa = _passEditingController.text;

    try {
      http.post(
          Uri.parse("${MyConfig().SERVER}/barter_it/php/register_user.php"),
          body: {
            "name": name,
            "email": email,
            "phone": phone,
            "password": passa,
          }).then((response) {
        print(response.body);
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                    "Registration Success. Returning to Login Page in a minute...")));
            Timer(
                const Duration(seconds: 5),
                () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (content) => LoginScreen())));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Registration Failed")));
          }
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Failed")));
          Navigator.pop(context);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Registration Failed. Email is already used.")));
    }
  }

  void _goLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }
}
