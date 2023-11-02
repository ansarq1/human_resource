import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:human_resource/screen/home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future <void> _login(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    if(_emailController.text.isEmpty || _passwordController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Please fill in all the fields",
                style: TextStyle(
                  fontSize: 14
                ),
              )
            ],
          ),
        )
      );
      setState(() {
        _isLoading = false;
      });
      return;
    } else {
      try{
        final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text
        );

        final User? user = userCredential.user;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Logged in Successfully",
                )
              ],
            ),
          ),
        );
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        print("error: $e");
        if (e is FirebaseAuthException) {
          if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Login Failed. Please check your credentials",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ),
            );
          } else if (e.code == 'user-not-found') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  backgroundColor: Colors.red,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "User not found, Please Sign Up First",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      )
                    ],
                  )
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "An error occured",
                        style: TextStyle(
                            fontSize: 14
                        ),
                      )
                    ],
                  ),
                )
            );
          }
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "H u m a n  R e s o u r c e \n M a n a g e m e n t",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 25
                ),
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Colors.black),
                      labelText: "Email",
                    ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      }

                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Colors.black),
                      labelText: "Password",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    obscureText: true,
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading
                    ? null : () => _login(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                    : const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
