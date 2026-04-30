import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cabkaro/utils/constants.dart';

class PlacesService {
  static Future<List<String>> getSuggestions(String input) async {
    if (input.isEmpty) return [];

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json'
      '?input=${Uri.encodeComponent(input)}'
      '&key=$googleApiKey'
      '&language=en',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final predictions = data['predictions'] as List;
        return predictions
            .map((p) => p['description'] as String)
            .toList();
      }
    }
    return [];
  }
}