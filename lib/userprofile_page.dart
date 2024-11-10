import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';
import 'addclothes_page.dart';
import 'package:flutter/services.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;
  UserProfilePage({required this.userId});

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Récupère informations utilisateur connecté sur Firestore
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();

    if (snapshot.exists) {
      setState(() {
        passwordController.text = snapshot['password'];
        birthdayController.text = snapshot['birthday'];
        addressController.text = snapshot['adress'];
        postalCodeController.text = snapshot['postalCode'];
        cityController.text = snapshot['city'];
      });
    }
  }

  // Mettre à jours informations validées dans Firestore Database
  void _saveUserData() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
        'password': passwordController.text,
        'birthday': birthdayController.text,
        'adress': addressController.text,
        'postalCode': postalCodeController.text,
        'city': cityController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Informations mises à jour avec succès.'),
      ));
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de la mise à jour des informations: $e'),
      ));
    }
  }  

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Center(
          child: Text(
            "Mon profil",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.blue,

        actions: [
          TextButton(
            onPressed: _saveUserData,
            child: Text(
              "Valider",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          SizedBox(width: 5),
        ],
      ),


      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: widget.userId,
              decoration: InputDecoration(labelText: 'Login'),
              readOnly: true,
            ),
            SizedBox(height: 10),

            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              autofillHints: null,
              obscureText: true,
            ),
            SizedBox(height: 10),

            TextFormField(
              controller: birthdayController,
              decoration: InputDecoration(labelText: 'Birthday'),
            ),
            SizedBox(height: 10),

            TextFormField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Adress'),
            ),
            SizedBox(height: 10),

            TextFormField(
              controller: postalCodeController,
              decoration: InputDecoration(labelText: 'Postal Code'),
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            SizedBox(height: 10),

            TextFormField(
              controller: cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
            SizedBox(height: 100),

            // Bouton se déconnecter
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                onPressed: _logout,
                child: Text(
                  "Se déconnecter",
                  style: TextStyle(color: Colors.white),
                ),
                
              ),
            ),
            SizedBox(height: 20),

            // Bouton ajouter un vetement
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddClothesPage()),
                  );
                },
                child: Text(
                  "Ajouter un vêtement",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
