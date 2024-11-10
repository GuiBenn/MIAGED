import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';

class AddClothesPage extends StatefulWidget {
  @override
  AddClothesPageState createState() => AddClothesPageState();
}

class AddClothesPageState extends State<AddClothesPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  String category = 'Classification en attente';
  bool _loading = false;
  // Pour interpreteur TFLite
  Interpreter? interpreter;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  // Fonction pour charger le modèle TFLite
  Future<void> _loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset("assets/model_unquant.tflite");
      print("Modèle TFLite chargé !");
    } catch (e) {
      print("Erreur lors du chargement du modèle TFLite : $e");
    }
  }

  // Télécharger l'image depuis l'URL pour la classification
  Future<void> _loadImageFromUrl() async {
    // requette http GET pour télécharger image depuis url spécifiée
    final response = await http.get(Uri.parse(imageController.text));
    if (response.statusCode == 200) { // requette réussie
      setState(() {
        _loading = true;
      });
      await _classifyImage(response.bodyBytes); // passe données images en bytes
    } else {
      print("Erreur lors du téléchargement de l'image : ${response.statusCode}");
    }
  }

  // Convertir l'image téléchargée en entrée pour TFLite
  Uint8List? imageToByteListFloat32(Uint8List imageBytes, int inputSize) {
    try {
      final image = img.decodeImage(imageBytes);

      if (image == null) {
        throw "Erreur : Impossible de décoder l'image pour TFLite.";
      }

      final resizedImage = img.copyResize(image, width: inputSize, height: inputSize);
      var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
      var buffer = Float32List.view(convertedBytes.buffer);

      int pixelIndex = 0;
      for (var y = 0; y < inputSize; y++) {
        for (var x = 0; x < inputSize; x++) {
          var pixel = resizedImage.getPixel(x, y);
          buffer[pixelIndex++] = pixel.r - 127.5 / 127.5; // normalisation valeur autour 0
          buffer[pixelIndex++] = pixel.g - 127.5 / 127.5;
          buffer[pixelIndex++] = pixel.b - 127.5 / 127.5;
        }
      } // parcourt chaque pixels de l'image resized et extrait valeur rgb de chaque pixels
      return convertedBytes.buffer.asUint8List();
    } catch (e) {
      print("Erreur lors de la conversion de l'image pour TFLite : $e");
      return null;
    }
  }

  // Classification de l'image
  Future<void> _classifyImage(Uint8List imageBytes) async {
    print("Classification de l'image...");

    if (interpreter == null) {
      print("Erreur : L'interprète TFLite n'est pas chargé.");
      return;
    }

    var input = imageToByteListFloat32(imageBytes, 224);

    if (input == null) {
      print("Erreur : Entrée TFLite invalide.");
      return;
    }

    var output = List<List<double>>.generate(1, (_) => List.filled(5, 0.0)); // prend sortie du modèle adapté aux sortie attendue par TFLite

    try {
      interpreter!.run(input, output);
    } catch (e) {
      print("Erreur lors de la classification : $e");
      return;
    }

    setState(() {
      _loading = false;

      List<double> probabilities = List<double>.from(output[0]); // converti proba catégorie image en liste de flottant

      double maxProbability = probabilities.reduce((double a, double b) => a > b ? a : b);
      int maxIndex = probabilities.indexOf(maxProbability);
      // identifies proba la plus élevée

      // Mapping d'index à nom de catégories
      List<String> categoryNames = ["Pantalon", "Chaussures", "Chapeau", "Robe", "T-Shirt"];
      category = categoryNames[maxIndex];
      print("Catégorie détectée : $category");
    });
  }

  void _saveClothes() async {
    // Il faut tout remplir pour ajouter un article
    if (titleController.text.isNotEmpty &&
        sizeController.text.isNotEmpty &&
        brandController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        imageController.text.isNotEmpty) {
      
      // Sauvegarder les informations dans Firestore
      await FirebaseFirestore.instance.collection('clothes').add({
        'name': titleController.text,
        'size': sizeController.text,
        'brand': brandController.text,
        'price': double.parse(priceController.text),
        'image': imageController.text,
        'category': category,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vêtement ajouté avec succès !')),
      );
      Navigator.pop(context);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs et ajouter un lien d\'image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),


      body: Padding(
        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              TextField(
                controller: imageController,
                decoration: InputDecoration(labelText: 'Image'),
                onSubmitted: (value) => _loadImageFromUrl(),
              ),
              SizedBox(height: 10),

              _buildImageWidget(),
              SizedBox(height: 10),

              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Titre'),
              ),
              SizedBox(height: 10),

              TextField(
                controller: TextEditingController(text: category),
                decoration: InputDecoration(labelText: 'Catégorie'),
                readOnly: true,
              ),
              SizedBox(height: 10),

              TextField(
                controller: sizeController,
                decoration: InputDecoration(labelText: 'Taille'),
              ),
              SizedBox(height: 10),

              TextField(
                controller: brandController,
                decoration: InputDecoration(labelText: 'Marque'),
              ),
              SizedBox(height: 10),

              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
              ),
              SizedBox(height: 50),
              

              Center(
                child: ElevatedButton(
                  onPressed: _saveClothes,
                  child: Text("Valider"),
                ),
              ),
              if (_loading) CircularProgressIndicator(), 
            ],
          ),
        ),
      ),
    );
  }

  // Affichage de l'image
  Widget _buildImageWidget() {
  if (imageController.text.isNotEmpty) {
    return Image.network(
      imageController.text,
      height: 250,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  } else {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.grey[200],
      child: Icon(Icons.add_photo_alternate, size: 50),
    );
  }
}
}
