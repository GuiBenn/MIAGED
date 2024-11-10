import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'clothesdetail_page.dart';
import 'basket_page.dart';
import 'userprofile_page.dart';

class HomePage extends StatefulWidget {
  final String userId;
  HomePage({required this.userId});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _initializePages();
  }

  // Initialise les pages du BottomNavigationBar
  void _initializePages() {
    _pages = [
      ClothesList(userId: widget.userId),
      BasketPage(userId: widget.userId),
      UserProfilePage(userId: widget.userId),
    ];
  }

  // Pour mettre à jour l'index du BottomNavigationBar
  void _onPageSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages[_currentIndex],
      ),
      // Création bottomNavigationBar pour changer de page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Acheter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onPageSelected,
      ),
    );
  }
}

class ClothesList extends StatelessWidget {
  final String userId;
  ClothesList({required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('clothes').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final clothes = snapshot.data!.docs;

        // Affiche chaque vêtement de la liste
        return ListView.builder(
          itemCount: clothes.length,
          itemBuilder: (context, index) {
            var clothing = clothes[index];
            return ListTile(
              leading: Image.network(clothing['image']),
              title: Text(clothing['name']),
              subtitle: Text('Taille: ${clothing['size']} - Prix: ${clothing['price']}€'),
              onTap: () {
                // Redirection vers page détail du vetement concerné
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClothesDetailPage(clothing: clothing, userId: userId),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}