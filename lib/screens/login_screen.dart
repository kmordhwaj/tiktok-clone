import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktokclone/screens/home_screen.dart';
import 'package:tiktokclone/screens/signup_screen.dart';
import 'package:tiktokclone/universal_variables.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 final TextEditingController _emailController = TextEditingController();
final  TextEditingController _passwordController = TextEditingController();
  var isLoading = false;

  loginUser(BuildContext context) {
    setState(() {
      isLoading = false;
    });
    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      setState(() {
        isLoading = true;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
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
        const    SizedBox(
              height: 15,
            ),
            Text(
              "Login",
              style: ralewayStyle(25, Colors.white, FontWeight.w700),
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
          const    SizedBox(
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
                  prefixIcon: const  Icon(Icons.lock),
                  labelStyle: latoStyle(20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
       const       SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () => loginUser(context),
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 50,
                decoration: const  BoxDecoration(
                  color: Colors.red,
                ),
                child: Center(
                  child: isLoading == false? Text(
                    "Login",
                    style: latoStyle(20, Colors.white, FontWeight.w700),
                  )
                  :
                const    CircularProgressIndicator(backgroundColor: Colors.white,),
                ),
              ),
            ),
           const   SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: latoStyle(20, Colors.white),
                ),
             const     SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const  SignUpScreen(),
                    ),
                  ),
                  child: Text(
                    "Register",
                    style: latoStyle(20, Colors.purple),
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
