import 'package:flutter/material.dart';

import 'api_service.dart';

class RandomFactPage extends StatefulWidget {
  final VoidCallback changeToHomeScreen;

  const RandomFactPage({Key? key, required this.changeToHomeScreen})
      : super(key: key);

  @override
  _RandomFactPageState createState() => _RandomFactPageState();
}

class _RandomFactPageState extends State<RandomFactPage> {
  late Future<String> _factFuture;
  late Future<List<dynamic>> _catImagesFuture;

  @override
  void initState() {
    super.initState();
    _factFuture = CatAPI().getRandomCatFact();
    _catImagesFuture = CatAPI().getTenRandomCatImages();
  }

  void _loadNextFactAndImage() {
    setState(() {
      _factFuture = CatAPI().getRandomCatFact();
      _catImagesFuture = CatAPI().getTenRandomCatImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Cat Fact'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.changeToHomeScreen,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _loadNextFactAndImage,
              child: const Text('NEXT'),
            ),
            const SizedBox(height: 20),
            FutureBuilder<String>(
              future: _factFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error fetching cat fact.');
                } else {
                  return Text(
                    snapshot.data ?? 'No cat fact available.',
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<dynamic>>(
              future: _catImagesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error fetching cat images.');
                } else {
                  final catImages = snapshot.data as List<dynamic>;
                  if (catImages.isNotEmpty) {
                    return Image.network(catImages[0]['url'], height: 300);
                  } else {
                    return const Text('No cat images available.');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
