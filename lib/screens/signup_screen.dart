import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:tiktokclone/screens/login_screen.dart';
import '../universal_variables.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
 final TextEditingController _emailController = TextEditingController();
 final TextEditingController _passwordController = TextEditingController();
 final TextEditingController _usernameController = TextEditingController();

  var isLoading = false;

  signUpUser() {
    setState(() {
      isLoading = true;
    });
    try {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .then((value) {
        userCollection.doc(value.user!.uid).set({
          "username": _usernameController.text,
          "email": _emailController.text,
          "password": _passwordController.text,
          "uid": value.user!.uid,
          "profilePic":
              "https://www.accountingweb.co.uk/sites/all/modules/custom/sm_pp_user_profile/img/default-user.png",
        });
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      });
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      // ignore: avoid_print
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Tiktok Clone",
              style: ralewayStyle(35, Colors.red, FontWeight.w900),
            ),
          const  SizedBox(
              height: 15,
            ),
            Text(
              "Sign Up",
              style: ralewayStyle(25, Colors.white, FontWeight.w700),
            ),
          const    SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const  EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Username",
                  prefixIcon: const  Icon(Icons.person),
                  labelStyle: latoStyle(20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          const    SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const  EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Email",
                  prefixIcon: const  Icon(Icons.email),
                  labelStyle: latoStyle(20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
         const     SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const  EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Password",
                  prefixIcon: const  Icon(Icons.lock_open),
                  labelStyle: latoStyle(20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
           const   SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () => signUpUser(),
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 50,
                decoration: const  BoxDecoration(
                  color: Colors.red,
                ),
                child: Center(
                  child: !isLoading
                      ? Text(
                          "Register",
                          style: latoStyle(20, Colors.white, FontWeight.w700),
                        )
                      :  const  CircularProgressIndicator(backgroundColor: Colors.white,),
                ),
              ),
            ),
          const    SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: latoStyle(20, Colors.white),
                ),
             const     SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (ctx) =>const LoginScreen())),
                  child: Text(
                    "Login",
                    style: latoStyle(
                      20,
                      Colors.purple,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
