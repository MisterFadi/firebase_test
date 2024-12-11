import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final emailControll = TextEditingController();
  final passwordControll = TextEditingController();
  bool showPassword = true;

  void loginUser() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailControll.text,
      password: passwordControll.text,
    );
  }

  void logoutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const Column(
                    children: [
                      Icon(
                        Icons.lock_open,
                        size: 100,
                      ),
                      SizedBox(height: 20),
                      Text("Endlich !!!"),
                    ],
                  );
                } else if (!snapshot.hasData) {
                  return const Column(
                    children: [
                      Icon(
                        Icons.lock,
                        size: 100,
                      ),
                      SizedBox(height: 20),
                      Text("Versuch dich einzulogen Brother"),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return const Text("Error 404");
                }
                return const Text("20 Punkte für Gryffindor");
              },
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: emailControll,
                style: const TextStyle(color: Colors.black54),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: passwordControll,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Passwort",
                  hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () {
                    loginUser();
                  },
                  textColor: Colors.white,
                  color: Colors.green,
                  child: const Text("Login"),
                ),
                const SizedBox(
                  width: 100,
                ),
                MaterialButton(
                  onPressed: () {
                    logoutUser();
                  },
                  textColor: Colors.white,
                  color: Colors.red,
                  child: const Text("Logout"),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
