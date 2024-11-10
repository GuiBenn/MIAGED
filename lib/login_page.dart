import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // headerBar MIAGED
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(
          child: Text(
            "MIAGED",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Cadre message d'erreur authentification
            if (errorMessage.isNotEmpty) 
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(bottom: 5),
                color: Colors.red.withOpacity(0.5),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            // Champs pour écrire son login et password
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Login'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 10),
            // Bouton se connecter avec gestion erreur
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text;
                String password = passwordController.text;

                // Vérifie que les champs sont remplis
                if (email.isEmpty && password.isEmpty) {
                  setState(() {
                    errorMessage = "Les champs ne doivent pas être vides";
                  });
                  return;
                }

                // Authentification dans Firestore Database
                try {
                  DocumentSnapshot snapshot = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(email)
                      .get();

                  // Vérification correspondance entre login et password du Firestore
                  if (snapshot.exists && snapshot['password'] == password) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(userId: email),
                      ),
                    );
                  } else {
                    setState(() {
                      print("Incorrect login and/or password");
                      errorMessage = "Incorrect login and/or password";
                    });
                  }
                } catch (e) {
                  setState(() {
                    errorMessage = "Erreur lors de la récupération des données dans la base de données: $e";
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),    
              ),
              child: Text("Se connecter"),
            ),
          ],
        ),
      ),
    );
  }
}