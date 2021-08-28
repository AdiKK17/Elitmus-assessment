import 'dart:convert';

import 'package:flutter/material.dart';

import 'home_page.dart';
import 'global_config.dart';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum AuthMode { Login, SignUp }

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Widget _buildNameTextField() {
    return Container(
      padding: EdgeInsets.all(5),
      child: TextField(
        controller: _nameController,
        decoration: InputDecoration(
            border: OutlineInputBorder(), hintText: 'Enter Name'),
      ),
    );
  }

  Widget _buildEmailTextField() {
    return Container(
      padding: EdgeInsets.all(5),
      child: TextField(
        controller: _emailController,
        decoration: InputDecoration(
            border: OutlineInputBorder(), hintText: 'Enter Email'),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Container(
      padding: EdgeInsets.all(5),
      child: TextField(
        obscureText: true,
        controller: _passwordController,
        decoration: InputDecoration(
            border: OutlineInputBorder(), hintText: 'Enter Password'),
      ),
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return Container(
      padding: EdgeInsets.all(5),
      child: TextField(
        obscureText: true,
        controller: _confirmPasswordController,
        decoration: InputDecoration(
            border: OutlineInputBorder(), hintText: 'Confirm Password'),
      ),
    );
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> _submitForm() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty ||
        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(email)) {
      _showToast("Email not valid");
      return;
    }
    if (password.isEmpty || password.length < 5) {
      _showToast("Password not valid");
      return;
    }

    try {
      if (_authMode == AuthMode.SignUp) {
        if (name.isEmpty) {
          _showToast("Name empty");
          return;
        }
        if (password != _confirmPasswordController.text) {
          _showToast("Passwords do not match");
          return;
        }
        setState(() {
          _isLoading = true;
        });
        final response = await Dio().post('${GlobalConfigs.baseURl}/user',
            data: {'email': email, 'password': password, 'name': name},
            options: Options(responseType: ResponseType.json));
        if (response.statusCode == 200) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("name", response.data["user"]["name"]);
          await prefs.setString("id", response.data["user"]["id"].toString());
          await prefs.setString("email", response.data["user"]["email"]);
          await prefs.setString("token", response.data["token"]);
          await prefs.setString("isLoggedIn", "yes");
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
        }
      } else {
        setState(() {
          _isLoading = true;
        });
        final response = await Dio().post(
          '${GlobalConfigs.baseURl}/user/login',
          data: {'email': email, 'password': password},
          options: Options(
            headers: {
              "Access-Control-Allow-Origin": "*",
              "Accept": "application/json",
            },
          ),
        );
        if (response.statusCode == 200) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("name", response.data["user"]["name"]);
          await prefs.setString("id", response.data["user"]["id"].toString());
          await prefs.setString("email", response.data["user"]["email"]);
          await prefs.setString("token", response.data["token"]);
          await prefs.setString("isLoggedIn", "yes");
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
        }
      }
    } catch (e) {
      _showToast(e.toString());
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      child: Text(
        _authMode == AuthMode.Login ? "LOGIN" : "SIGNUP",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onPressed: () => _submitForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 180),
                alignment: Alignment.center,
                child: Text(
                  "Welcome",
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 50),
                ),
              ),
              SizedBox(
                height: 70,
              ),
              _authMode == AuthMode.SignUp
                  ? Container(
                      child: _buildNameTextField(),
                      width: deviceWidth * 0.85,
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              Container(
                child: _buildEmailTextField(),
                width: deviceWidth * 0.85,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: _buildPasswordTextField(),
                width: deviceWidth * 0.85,
              ),
              SizedBox(
                height: 10,
              ),
              _authMode == AuthMode.SignUp
                  ? Container(
                      child: _buildPasswordConfirmTextField(),
                      width: deviceWidth * 0.85,
                    )
                  : Container(),
              SizedBox(
                height: 25,
              ),
              _isLoading == true
                  ? CircularProgressIndicator()
                  : Container(
                      child: _buildSubmitButton(),
                      width: 200,
                    ),
              SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    if (_authMode == AuthMode.Login) {
                      _authMode = AuthMode.SignUp;
                    } else {
                      _authMode = AuthMode.Login;
                    }
                  });
                },
                child: Text(
                  _authMode == AuthMode.Login
                      ? "Not a user?  SignUp first"
                      : "Login Instead",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
