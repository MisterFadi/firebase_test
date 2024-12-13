import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/main.dart';
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

  late Future<List<Map<String, dynamic>>> datenBringMe;

  @override
  void initState() {
    super.initState();
    datenBringMe = pleasePress();
  }

  Future<void> loginUser() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailControll.text,
      password: passwordControll.text,
    );
  }

  Future<List<Map<String, dynamic>>> pleasePress() async {
    try {
      final querySnapshot = await firestoreInstance.collection("food").get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Fehler beim Laden der Daten min Jung");
    }
    return [];
  }

  Future<void> logoutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              onPressed: () {
                pleasePress();
              },
              textColor: Colors.black,
              color: Colors.green,
              child: const Text("Daten nehmen"),
            ),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(width: 10),
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Expanded(
                  child: SingleChildScrollView(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: datenBringMe,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final data = snapshot.data;
                            return ListView.builder(
                              itemBuilder: (context, index) {
                                return Text(data[index]["name"]);
                              },
                              itemCount: data!.length,
                            );
                          } else if (!snapshot.hasData) {
                            return const Text("Keine Daten vorhanden min jung");
                          } else if (snapshot.hasError) {
                            return const Text("Error 404");
                          }
                          return const Text("20 Punkte für Gryffindor");
                        }),
                  ),
                ),
              ),
            ),
            StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const Column(
                    children: [
                      Icon(Icons.lock_open, size: 100),
                      SizedBox(height: 20),
                      Text("Endlich !!!"),
                    ],
                  );
                } else if (!snapshot.hasData) {
                  return const Column(
                    children: [
                      Icon(Icons.lock, size: 100),
                      SizedBox(height: 20),
                      Text("Bitte einlogen Brother"),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return const Text("Error 404");
                }
                return const Text("20 Punkte für Gryffindor");
              },
            ),
            const SizedBox(height: 20),
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
