import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClothesDetailPage extends StatelessWidget {
  final QueryDocumentSnapshot clothing;
  final String userId;

  ClothesDetailPage({required this.clothing, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              clothing['image'],
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Text('Image non disponible'));
              },
            ),
            SizedBox(height: 20),

            Text(
              clothing['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Catégorie: ${clothing['category']}'),
            Text('Taille: ${clothing['size']}'),
            Text('Marque: ${clothing['brand']}'),
            Text('Prix: ${clothing['price']}€'),
            SizedBox(height: 30.0),


            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final cart = FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .collection('cart');

                  // Vérifie si l'article existe déjà dans le panier
                  final existingItem = await cart
                      .where('name', isEqualTo: clothing['name'])
                      .get();

                  String message;
                  if (existingItem.docs.isEmpty) {
                    // Ajoute l'article s'il n'est pas déjà présent
                    await cart.add({
                      'name': clothing['name'],
                      'category': clothing['category'],
                      'image': clothing['image'],
                      'size': clothing['size'],
                      'brand': clothing['brand'],
                      'price': clothing['price']
                    });
                    message = "${clothing['name']} a été ajouté au panier";
                  } else {
                    message = "${clothing['name']} est déjà dans le panier";
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                },
                child: Text("Ajouter au panier"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
