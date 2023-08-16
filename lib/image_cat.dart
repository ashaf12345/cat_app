import 'package:flutter/material.dart';

import 'api_service.dart';

class CatHomeScreen extends StatefulWidget {
  final VoidCallback changeToRandomFactPage;

  const CatHomeScreen({Key? key, required this.changeToRandomFactPage})
      : super(key: key);

  @override
  _CatHomeScreenState createState() => _CatHomeScreenState();
}

class _CatHomeScreenState extends State<CatHomeScreen> {
  CatAPI catAPI = CatAPI();
  List<dynamic> catImages = [];
  List<dynamic> catBreeds = [];
  String selectedBreed = '';

  @override
  void initState() {
    super.initState();
    fetchCatBreeds();
    fetchTenRandomCatImages();
  }

  void fetchCatBreeds() async {
    try {
      final data = await catAPI.getCatBreedsList();
      setState(() {
        catBreeds = data;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void fetchTenRandomCatImages() async {
    try {
      final data = await catAPI.getTenRandomCatImages();
      setState(() {
        catImages = data;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void onBreedSelected(String? breedId) {
    if (breedId != null) {
      setState(() {
        selectedBreed = breedId;
      });
      fetchImagesForSelectedBreed(breedId);
    }
  }

  void fetchImagesForSelectedBreed(String breed) async {
    try {
      final data = await catAPI.getImagesForSelectedBreed(breed);
      setState(() {
        catImages = data;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cat App'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'randomFact') {
                widget.changeToRandomFactPage();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'randomFact',
                  child: Text('Random Fact'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButton<String?>(
            value: selectedBreed.isNotEmpty ? selectedBreed : null,
            hint: const Text('Select a breed'),
            onChanged: onBreedSelected,
            items: catBreeds.map<DropdownMenuItem<String?>>((breed) {
              return DropdownMenuItem<String?>(
                value: breed['id'],
                child: Text(breed['name']),
              );
            }).toList(),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: catImages.length,
              itemBuilder: (context, index) {
                final imageUrl = catImages[index]['url'];
                return Image.network(imageUrl, fit: BoxFit.cover);
              },
            ),
          ),
        ],
      ),
    );
  }
}
