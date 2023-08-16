import 'dart:convert';

import 'package:http/http.dart';

const String apiKey =
    '&api_key=live_uW9dz1dZZtB3IPNcmeYpLWXyhG0I56hTsh73sSsKjSGKbGdVEmKP8vkiIRhuxaaw';
const String catAPIURL = 'https://api.thecatapi.com/v1/breeds?';
const String catImageAPIURL =
    'https://api.thecatapi.com/v1/images/search?limit=20';
const String tesapi = 'https://api.thecatapi.com/v1/images/search?limit=20';
const String breedString = '&breed_ids=';
const String apiKeyString = apiKey;

class Network {
  Future<List<dynamic>> getData(List<String> urls) async {
    List<Future<Response>> responses =
        urls.map((url) => get(Uri.parse(url))).toList();

    List<Response> completedResponses = await Future.wait(responses);

    List<String> data = [];

    for (Response response in completedResponses) {
      if (response.statusCode == 200) {
        data.add(response.body);
      } else {
        print(response.statusCode);
        throw 'Error fetching data';
      }
    }

    return data;
  }
}

class CatAPI {
  Future<List<dynamic>> getCatBreedsList() async {
    Network network = Network();
    var catData = await network.getData([catAPIURL]);
    return jsonDecode(catData[0]);
  }

  Future<List<dynamic>> getTenRandomCatImages() async {
    Network network = Network();
    var catData = await network.getData(['$tesapi$apiKey']);
    return jsonDecode(catData[0]);
  }

  Future<List<dynamic>> getImagesForSelectedBreed(String breedId) async {
    Network network = Network();
    var catData = await network
        .getData([catImageAPIURL + breedString + breedId + apiKeyString]);
    return jsonDecode(catData[0]);
  }

  Future<String> getRandomCatFact() async {
    Network network = Network();
    var factData = await network.getData(['https://catfact.ninja/fact']);
    return jsonDecode(factData[0])['fact'];
  }
}
