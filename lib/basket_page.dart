import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BasketPage extends StatelessWidget {
  final String userId;
  BasketPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Center(
          child: Text(
            "Mon panier",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.blue,
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart')
            .snapshots(),

        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final cartItems = snapshot.data!.docs;
          double totalPrice = 0;

          // Calcul du total des articles
          for (var item in cartItems) {
            totalPrice += double.tryParse(item['price'].toString()) ?? 0.0;
          }

          // Affichage des vetements dans le panier
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var item = cartItems[index];

                    return ListTile(
                      leading: Image.network(item['image']),
                      title: Text(item['name']),
                      subtitle: Text('Taille: ${item['size']} - Prix: ${item['price']}€'),

                      trailing: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          // Suppression de l'article du panier
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId) 
                              .collection('cart')
                              .doc(item.id)
                              .delete();
                        },
                      ),
                    );
                  },
                ),
              ),

              // Affichage du total
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Total : ${totalPrice.toStringAsFixed(2)}€',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
